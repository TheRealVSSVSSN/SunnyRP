import * as Biz from '../repositories/businesses.repo.js';
import * as Items from '../repositories/businessItems.repo.js';
import * as Tx from '../repositories/transactions.repo.js';
import { db } from '../repositories/db.js';
import process from 'node:process';

const TREASURY = process.env.ECON_TREASURY_ACCOUNT_ID || 'gov:treasury';

// simple sales tax: business.tax_rate || global default
function taxRate(biz, globalDefault) {
    const b = Number(biz?.tax_rate);
    return Number.isFinite(b) ? b : Number(globalDefault || 0);
}

export async function catalog(query) {
    if (query.slug) {
        const b = await Biz.bySlug(String(query.slug)); if (!b) return null;
        const items = await Items.catalog(b.id);
        return { business: b, items };
    }
    if (query.businessId) {
        const b = await Biz.get(Number(query.businessId)); if (!b) return null;
        const items = await Items.catalog(b.id);
        return { business: b, items };
    }
    return null;
}

export async function purchase(body, actor, globals) {
    const { slug, businessId, lines, idempotencyKey, payFrom = 'cash' } = body || {};
    if (!lines || !Array.isArray(lines) || !lines.length) { const e = new Error('BAD_REQUEST'); e.statusCode = 400; throw e; }

    const biz = slug ? await Biz.bySlug(String(slug)) : await Biz.get(Number(businessId));
    if (!biz) { const e = new Error('NOT_FOUND'); e.statusCode = 404; throw e; }
    if (!biz.open) { const e = new Error('CLOSED'); e.statusCode = 409; throw e; }

    // compute totals + stock checks inside a transaction
    return await db.transaction(async (trx) => {
        let subtotal = 0;
        const outLines = [];
        for (const l of lines) {
            const code = String(l.code); const qty = Math.max(1, Number(l.qty || 1));
            const item = await trx('business_items').where({ business_id: biz.id, item_code: code, enabled: true }).first();
            if (!item) { const e = new Error('ITEM_NOT_SOLD'); e.statusCode = 409; throw e; }
            // consume stock (locks row)
            if (item.stock_qty != null) {
                if (item.stock_qty < qty) { const e = new Error('OUT_OF_STOCK'); e.statusCode = 409; throw e; }
                await trx('business_items').where({ id: item.id }).update({ stock_qty: item.stock_qty - qty });
            }
            subtotal += (Number(item.price_cents) * qty);
            outLines.push({ code, qty, price_cents: Number(item.price_cents) });
        }

        const rate = taxRate(biz, globals.defaultTax);
        const tax = Math.round(subtotal * (rate / 100));
        const total = subtotal + tax;

        // Economy (Phase H): debit player -> credit business; then business -> treasury for tax
        // Here we write to the transactions table and rely on /economy/transfer endpoint via internal call hook (http.js util)
        const { httpPost } = await import('../utils/http.js'); // same secured client used by server Lua
        const econBase = ''; // local service, use direct route path
        const econHeaders = { 'X-API-Token': globals.apiToken };

        // player -> business revenue (total - tax)
        const revenue = total - tax;
        if (revenue > 0) {
            await httpPost('/economy/transfer', {
                from: { type: 'char', id: actor.char_id, wallet: payFrom }, to: { type: 'account', id: biz.account_id || `biz:${biz.slug}` },
                cents: revenue, reason: 'shop_sale', idempotencyKey
            }, econHeaders);
        }
        // player -> treasury (tax) OR business -> treasury? (we’ll do player -> treasury for simplicity)
        if (tax > 0) {
            await httpPost('/economy/transfer', {
                from: { type: 'char', id: actor.char_id, wallet: payFrom }, to: { type: 'account', id: TREASURY },
                cents: tax, reason: 'sales_tax', idempotencyKey: idempotencyKey && `${idempotencyKey}:tax`
            }, econHeaders);
        }

        // audit row
        const txid = await Tx.record({
            business_id: biz.id, char_id: actor.char_id, kind: 'sale',
            amount_cents: revenue, idempotency_key: idempotencyKey || null,
            lines: JSON.stringify(outLines), meta: JSON.stringify({ tax_cents: tax, payFrom })
        });

        return {
            ok: true,
            data: {
                business: { id: biz.id, slug: biz.slug, label: biz.label, type: biz.type },
                totals: { subtotal_cents: subtotal, tax_cents: tax, total_cents: total, tax_rate: rate },
                lines: outLines,
                transaction_id: txid
            }
        };
    });
}
import crypto from 'crypto';
import { db } from '../repositories/db.js';
import * as Accounts from '../repositories/accounts.repo.js';
import * as Ledger from '../repositories/ledger.repo.js';
import * as Idem from '../repositories/idempotency.repo.js';

const toCents = (n) => Math.round(Number(n) * 100);

// ----- CA defaults (override via env) -----
const SALES_BASE = Number(process.env.SRP_SALES_TAX_BASE ?? 0.0725);
const SALES_DIST = Number(process.env.SRP_SALES_TAX_DIST ?? 0.0);
const CASDI = Number(process.env.SRP_CASDI_RATE ?? 0.012);

// 2024 CA PIT (single filer) - thresholds in USD per year (approx withholding)
const PIT = [
    { up: 10756, rate: 0.01, base: 0 },
    { up: 25499, rate: 0.02, base: 107.56 },
    { up: 40245, rate: 0.04, base: 402.42 },
    { up: 55866, rate: 0.06, base: 992.26 },
    { up: 70606, rate: 0.08, base: 1929.52 },
    { up: 360659, rate: 0.093, base: 3108.72 },
    { up: 432787, rate: 0.103, base: 30083.65 },
    { up: 721314, rate: 0.113, base: 37512.83 },
    { up: Infinity, rate: 0.123, base: 70116.38 },
];
// Withholding approximator: annualized method
function caPitAnnual(taxableAnnual) {
    let prevUp = 0;
    for (const br of PIT) {
        if (taxableAnnual <= br.up) {
            const over = Math.max(0, taxableAnnual - prevUp);
            return br.base + br.rate * over;
        }
        prevUp = br.up;
    }
    return 0;
}

export function calcSalesTax(subtotal) {
    const rate = SALES_BASE + SALES_DIST;
    return { rate, tax: subtotal * rate };
}

export function calcPayroll({ grossCents, period = 'weekly' }) {
    const perYear = period === 'biweekly' ? 26 : 52;
    const gross = grossCents / 100;
    const annual = gross * perYear;
    const pitAnnual = caPitAnnual(Math.max(0, annual));     // simplistic; no standard deduction modeled
    const pitPer = pitAnnual / perYear;
    const sdiPer = gross * CASDI;
    const withhold = Math.round((pitPer + sdiPer) * 100);
    const net = grossCents - withhold;
    return { gross_cents: grossCents, pit_cents: Math.max(0, Math.round(pitPer * 100)), sdi_cents: Math.max(0, Math.round(sdiPer * 100)), net_cents: net };
}

function normalizeEndpointAccount(a) {
    // accepted shapes: { type:'char', charId, pocket:'bank'|'cash' } or { type:'gov', code:'state:pit' }
    if (a.type === 'char') return { type: 'char', ref: String(a.charId), pocket: a.pocket === 'cash' ? 'cash' : 'bank' };
    if (a.type === 'gov') return { type: 'gov', ref: String(a.code || 'treasury'), pocket: null };
    if (a.type === 'biz') return { type: 'biz', ref: String(a.code), pocket: null };
    throw new Error('BAD_ACCOUNT');
}

export async function transfer(body, headers) {
    const idemKey = headers['x-idempotency-key'] || headers['X-Idempotency-Key'];
    const scope = 'economy:transfer';
    const claimed = idemKey ? await Idem.claim(scope, idemKey) : { created: true };
    if (!claimed.created && claimed.response) return claimed.response;

    const transferId = body.transfer_id || crypto.randomBytes(8).toString('hex');
    const from = normalizeEndpointAccount(body.from);
    const to = normalizeEndpointAccount(body.to);
    const kind = body.kind || 'transfer';
    const amountCents = Number(body.amount_cents || 0);
    if (!(amountCents > 0)) { const e = new Error('BAD_AMOUNT'); e.statusCode = 400; throw e; }

    const out = await db.transaction(async (trx) => {
        // money moves
        if (from.type === 'char') await Accounts.delta(Number(from.ref), from.pocket, -amountCents, trx);
        // gov/biz can go negative: skip

        if (to.type === 'char') await Accounts.delta(Number(to.ref), to.pocket, amountCents, trx);

        // ledger write
        const entry = {
            transfer_id: transferId, idem_key: idemKey || null, kind,
            from_type: from.type, from_ref: from.ref, from_pocket: from.pocket || null,
            to_type: to.type, to_ref: to.ref, to_pocket: to.pocket || null,
            amount_cents: amountCents, currency: 'USD', meta: body.meta || null
        };
        const id = await Ledger.write(entry, trx);

        const resp = { ok: true, data: { transfer_id: transferId, ledger_id: id } };
        if (idemKey) await Idem.fulfill(scope, idemKey, resp, trx);
        return resp;
    });
    return out;
}

// Payroll wrapper: splits gross -> net to char, withholds to gov:state:pit and gov:state:sdi
export async function runPayroll(body, headers) {
    const period = (process.env.SRP_PAY_PERIOD || 'weekly').toLowerCase();
    const calc = calcPayroll({ grossCents: Number(body.gross_cents), period });

    // 1) net pay
    await transfer({
        kind: 'payroll',
        from: { type: 'gov', code: 'treasury' },
        to: { type: 'char', charId: body.char_id, pocket: 'bank' },
        amount_cents: calc.net_cents,
        meta: { job_code: body.job_code || 'GEN', period, breakdown: calc }
    }, headers);

    // 2) PIT
    if (calc.pit_cents > 0) await transfer({
        kind: 'tax',
        from: { type: 'gov', code: 'treasury' },
        to: { type: 'gov', code: 'state:pit' },
        amount_cents: calc.pit_cents,
        meta: { char_id: body.char_id, job_code: body.job_code || 'GEN', period }
    }, headers);

    // 3) SDI
    if (calc.sdi_cents > 0) await transfer({
        kind: 'tax',
        from: { type: 'gov', code: 'treasury' },
        to: { type: 'gov', code: 'state:sdi' },
        amount_cents: calc.sdi_cents,
        meta: { char_id: body.char_id, job_code: body.job_code || 'GEN', period }
    }, headers);

    return { ok: true, data: { ...calc } };
}
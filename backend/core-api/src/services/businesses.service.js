import * as Biz from '../repositories/businesses.repo.js';
import * as Emp from '../repositories/businessEmployees.repo.js';
import * as Items from '../repositories/businessItems.repo.js';

function assert(b, code = 'BAD_REQUEST', status = 400) { if (!b) { const e = new Error(code); e.statusCode = status; throw e; } }
const isBossy = (role) => ['boss', 'manager'].includes(role);

export async function create(body, actor) {
    assert(body?.slug && body?.label && body?.type, 'BAD_REQUEST');
    const id = await Biz.create({
        slug: String(body.slug), label: String(body.label), type: String(body.type),
        npc_owned: !body.owner_char_id, owner_char_id: body.owner_char_id || null,
        open: true, tax_rate: body.tax_rate ?? null, account_id: body.account_id || null,
        metadata: body.metadata ? JSON.stringify(body.metadata) : null
    });
    if (body.owner_char_id) await Emp.grant(id, Number(body.owner_char_id), 'boss');
    return await Biz.get(id);
}

export async function list(q) { return await Biz.list(q); }

export async function setOpen(body, actor) {
    assert(body?.business_id != null && typeof body.open === 'boolean', 'BAD_REQUEST');
    const b = await Biz.get(body.business_id); assert(b, 'NOT_FOUND', 404);
    if (b.owner_char_id && b.owner_char_id !== actor.char_id) {
        assert(await Emp.hasRole(b.id, actor.char_id, ['boss', 'manager']), 'FORBIDDEN', 403);
    }
    return await Biz.update(b.id, { open: !!body.open });
}

export async function hire(body, actor) {
    assert(body?.business_id && body?.char_id && body?.role, 'BAD_REQUEST');
    const b = await Biz.get(body.business_id); assert(b, 'NOT_FOUND', 404);
    assert(b.owner_char_id === actor.char_id || await Emp.hasRole(b.id, actor.char_id, 'boss'), 'FORBIDDEN', 403);
    await Emp.grant(b.id, Number(body.char_id), String(body.role));
    return { ok: true };
}

export async function fire(body, actor) {
    assert(body?.business_id && body?.char_id, 'BAD_REQUEST');
    const b = await Biz.get(body.business_id); assert(b, 'NOT_FOUND', 404);
    assert(b.owner_char_id === actor.char_id || await Emp.hasRole(b.id, actor.char_id, 'boss'), 'FORBIDDEN', 403);
    await Emp.revoke(b.id, Number(body.char_id));
    return { ok: true };
}

export async function setItem(body, actor) {
    assert(body?.business_id && body?.item_code && body?.price_cents != null, 'BAD_REQUEST');
    const b = await Biz.get(body.business_id); assert(b, 'NOT_FOUND', 404);
    assert(b.owner_char_id ? (b.owner_char_id === actor.char_id || await Emp.hasRole(b.id, actor.char_id, ['boss', 'manager'])) : true, 'FORBIDDEN', 403);
    await Items.upsert({
        business_id: b.id, item_code: String(body.item_code),
        price_cents: Number(body.price_cents), stock_qty: body.stock_qty == null ? null : Number(body.stock_qty),
        enabled: body.enabled !== false
    });
    return { ok: true };
}

export async function catalogBySlug(slug) {
    const b = await Biz.bySlug(slug); if (!b) return null;
    const items = await Items.catalog(b.id);
    return { business: b, items };
}
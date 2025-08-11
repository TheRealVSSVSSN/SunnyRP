import * as Props from '../repositories/properties.repo.js';
import * as Access from '../repositories/propAccess.repo.js';
import * as Leases from '../repositories/leases.repo.js';
import * as Ints from '../repositories/interiors.repo.js';

function assert(b, code = 'BAD_REQUEST', status = 400) { if (!b) { const e = new Error(code); e.statusCode = status; throw e; } }

export async function list(query, actor) {
    if (query.charId) return await Props.listForChar(Number(query.charId));
    // admin / all listings optional
    return [];
}

export async function purchase(body, actor) {
    assert(body?.property_id && actor?.char_id, 'BAD_REQUEST');
    const p = await Props.get(body.property_id);
    assert(p && p.for_sale, 'NOT_FOR_SALE', 409);
    assert(!p.owner_char_id, 'ALREADY_OWNED', 409);
    // (Economy debit would happen here; out-of-scope for this phase)
    const updated = await Props.update(p.id, { owner_char_id: actor.char_id, for_sale: false, locked: true });
    await Access.grant(p.id, actor.char_id, 'owner', null);
    return updated;
}

export async function sell(body, actor) {
    assert(body?.property_id && actor?.char_id, 'BAD_REQUEST');
    const p = await Props.get(body.property_id);
    assert(p && p.owner_char_id === actor.char_id, 'FORBIDDEN', 403);
    const updated = await Props.update(p.id, { owner_char_id: null, for_sale: true, locked: true });
    // clear access keys
    return updated;
}

export async function grant(body, actor) {
    assert(body?.property_id && body?.target_char_id && actor?.char_id, 'BAD_REQUEST');
    const p = await Props.get(body.property_id);
    assert(p && (p.owner_char_id === actor.char_id), 'FORBIDDEN', 403);
    await Access.grant(p.id, Number(body.target_char_id), body.access_type || 'key', body.expires_at || null);
    return { ok: true };
}

export async function revoke(body, actor) {
    assert(body?.property_id && body?.target_char_id && actor?.char_id, 'BAD_REQUEST');
    const p = await Props.get(body.property_id);
    assert(p && (p.owner_char_id === actor.char_id), 'FORBIDDEN', 403);
    await Access.revoke(p.id, Number(body.target_char_id));
    return { ok: true };
}

export async function rentStart(body, actor) {
    assert(body?.property_id && actor?.char_id, 'BAD_REQUEST');
    const p = await Props.get(body.property_id);
    assert(p && p.for_rent, 'NOT_FOR_RENT', 409);
    await Leases.start(p.id, actor.char_id, p.rent_cents, 'weekly');
    await Access.grant(p.id, actor.char_id, 'rent', null);
    return await Props.get(p.id);
}

export async function rentStop(body, actor) {
    assert(body?.property_id && actor?.char_id, 'BAD_REQUEST');
    await Leases.stop(Number(body.property_id), actor.char_id);
    return { ok: true };
}

export async function enter(body, actor) {
    assert(body?.property_id && actor?.char_id, 'BAD_REQUEST');
    const p = await Props.get(body.property_id);
    assert(p, 'NOT_FOUND', 404);
    const allowed = await Access.hasAccess(p.id, actor.char_id);
    assert(allowed && !p.locked, 'LOCKED', 403);
    const interior = await Ints.get(p.interior_id);
    return { property: p, interior };
}

export async function lock(body, actor) {
    assert(body?.property_id && typeof body.locked === 'boolean', 'BAD_REQUEST');
    const p = await Props.get(body.property_id);
    assert(p, 'NOT_FOUND', 404);
    assert(p.owner_char_id === actor.char_id, 'FORBIDDEN', 403);
    return await Props.update(p.id, { locked: !!body.locked });
}
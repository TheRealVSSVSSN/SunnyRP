// Usage: BASE_URL=http://127.0.0.1:3010 API_TOKEN=CHANGE-ME node scripts/smoke.mjs
const BASE_URL = process.env.BASE_URL || 'http://127.0.0.1:3010';
const API_TOKEN = process.env.API_TOKEN || 'CHANGE-ME';
const headers = { 'X-API-Token': API_TOKEN, 'Content-Type': 'application/json' };

async function call(path, init = {}) {
    const res = await fetch(`${BASE_URL}${path}`, {
        ...init,
        headers: { ...headers, ...(init.headers || {}) }
    });
    const text = await res.text();
    try { return { status: res.status, body: JSON.parse(text) }; }
    catch { return { status: res.status, body: text }; }
}

(async () => {
    const hex = `license:test${Date.now()}`;

    console.log('GET /v1/healthz'); console.log(await call('/v1/healthz'));

    console.log('GET /v1/users/exists'); console.log(await call(`/v1/users/exists?hex_id=${encodeURIComponent(hex)}`));

    console.log('POST /v1/users');
    console.log(await call('/v1/users', {
        method: 'POST',
        body: JSON.stringify({ hex_id: hex, name: 'Test User', identifiers: [{ type: 'license', value: hex }] })
    }));

    console.log('GET /v1/users/:hex_id'); console.log(await call(`/v1/users/${encodeURIComponent(hex)}`));

    console.log('POST /v1/characters');
    const created = await call('/v1/characters', { method: 'POST', body: JSON.stringify({ owner_hex: hex, first_name: 'Jordan', last_name: 'Avery' }) });
    console.log(created);

    console.log('GET /v1/characters?owner_hex=hex'); console.log(await call(`/v1/characters?owner_hex=${encodeURIComponent(hex)}`));

    if (created.body && created.body.data && created.body.data.id) {
        console.log('GET /v1/characters/:id'); console.log(await call(`/v1/characters/${created.body.data.id}`));
    }
})().catch(e => { console.error(e); process.exit(1); });
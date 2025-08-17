// backend/services/srp-base/src/scripts/smoke.mjs
import fetch from 'node-fetch';

const API = process.env.BASE_URL || 'http://127.0.0.1:3010';
const TOKEN = process.env.API_TOKEN || 'CHANGE-ME';

function headers(extra = {}) {
    return {
        'X-API-Token': TOKEN,
        'Content-Type': 'application/json',
        ...extra,
    };
}

async function go() {
    const hex = `license:test${Date.now()}`;

    const j = (r) => r.json();

    console.log('healthz');
    console.log(await fetch(`${API}/v1/healthz`, { headers: headers() }).then(j));

    console.log('users exists');
    console.log(await fetch(`${API}/v1/users/exists?hex_id=${encodeURIComponent(hex)}`, { headers: headers() }).then(j));

    console.log('users create');
    console.log(await fetch(`${API}/v1/users`, {
        method: 'POST',
        headers: headers(),
        body: JSON.stringify({ hex_id: hex, name: 'Test User', identifiers: [{ type: 'license', value: hex }] }),
    }).then(j));

    console.log('users get');
    console.log(await fetch(`${API}/v1/users/${encodeURIComponent(hex)}`, { headers: headers() }).then(j));

    console.log('characters create');
    console.log(await fetch(`${API}/v1/characters`, {
        method: 'POST',
        headers: headers(),
        body: JSON.stringify({ owner_hex: hex, first_name: 'Jordan', last_name: 'Avery' }),
    }).then(j));

    console.log('characters list');
    console.log(await fetch(`${API}/v1/characters?owner_hex=${encodeURIComponent(hex)}`, { headers: headers() }).then(j));
}

go().catch((e) => {
    console.error(e);
    process.exit(1);
});
/**
 * SunnyRP — Webhooks retry worker (ESM)
 * PM2 runs this as a separate app.
 */
import https from 'https';
import { URL } from 'url';
import knex from '../repositories/db.js';
import { nextPending, markDelivered, markFailed } from '../repositories/webhooks.repo.js';

function postJson(urlStr, body) {
    const url = new URL(urlStr);
    const json = JSON.stringify(body || {});
    const opts = {
        method: 'POST',
        hostname: url.hostname,
        port: url.port || 443,
        path: url.pathname + url.search,
        headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(json) },
        timeout: 5000,
    };
    return new Promise((resolve, reject) => {
        const req = https.request(opts, (res) => {
            let data = '';
            res.on('data', (d) => (data += d));
            res.on('end', () => {
                if (res.statusCode >= 200 && res.statusCode < 300) resolve();
                else reject(new Error(`HTTP ${res.statusCode}: ${data}`));
            });
        });
        req.on('error', reject);
        req.on('timeout', () => req.destroy(new Error('timeout')));
        req.write(json); req.end();
    });
}

async function deliverOnce() {
    const batch = await nextPending(10);
    for (const evt of batch) {
        try {
            const wh = await knex('webhooks').where({ id: evt.webhook_id, enabled: 1 }).first();
            if (!wh) { await markFailed(evt.id, 'webhook disabled or missing'); continue; }

            const payload = evt.payload || {};
            const body = {};
            if (payload.content) body.content = String(payload.content).slice(0, 1900);
            if (payload.embed) body.embeds = [payload.embed];

            await postJson(wh.url, body);
            await markDelivered(evt.id);
        } catch (e) {
            await markFailed(evt.id, e.message || String(e));
        }
    }
}

async function loop() {
    // eslint-disable-next-line no-constant-condition
    while (true) {
        await deliverOnce().catch(() => { });
        await new Promise(r => setTimeout(r, 3000));
    }
}

if (process.argv[1] && process.argv[1].includes('webhooks.worker.js')) {
    loop();
}

export default { loop };
/**
 * Simple worker to retry pending webhook events.
 * Add this to PM2 if you want background retries.
 */
const webhooks = require('../repositories/webhooks.repo');
const notify = require('../services/notify.service'); // we reuse HTTP sender logic
const knex = require('../repositories/db');

let running = false;

async function deliverOnce() {
    const batch = await webhooks.nextPending(10);
    for (const evt of batch) {
        try {
            // load webhook
            const [wh] = await knex('webhooks').where({ id: evt.webhook_id, enabled: 1 }).limit(1);
            if (!wh) {
                await webhooks.markFailed(evt.id, 'webhook disabled or missing');
                continue;
            }
            const hooks = [{ id: wh.id, url: wh.url, channels: [] }];
            // quick-n-dirty: bypass emit(); send directly to url
            const payload = evt.payload || {};
            // Use the same sender as in service
            const { URL } = require('url');
            const https = require('https');
            const body = {};
            if (payload.content) body.content = String(payload.content).slice(0, 1900);
            if (payload.embed) body.embeds = [payload.embed];
            const url = new URL(wh.url);
            const json = JSON.stringify(body);
            const opts = {
                method: 'POST', hostname: url.hostname, port: url.port || 443, path: url.pathname + url.search,
                headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(json) }, timeout: 5000
            };
            await new Promise((resolve, reject) => {
                const req = https.request(opts, (res) => {
                    let data = ''; res.on('data', d => data += d);
                    res.on('end', () => (res.statusCode >= 200 && res.statusCode < 300) ? resolve() : reject(new Error(`HTTP ${res.statusCode}`)));
                });
                req.on('error', reject);
                req.on('timeout', () => req.destroy(new Error('timeout')));
                req.write(json); req.end();
            });
            await webhooks.markDelivered(evt.id);
        } catch (e) {
            await webhooks.markFailed(evt.id, e.message || String(e));
        }
    }
}

async function loop() {
    if (running) return;
    running = true;
    // eslint-disable-next-line no-constant-condition
    while (true) {
        await deliverOnce().catch(() => { });
        await new Promise(r => setTimeout(r, 3000));
    }
}

if (require.main === module) {
    loop();
}

module.exports = { loop };
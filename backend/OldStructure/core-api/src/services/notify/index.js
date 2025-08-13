import https from 'https';
import { URL } from 'url';
import * as webhooksRepo from '../repositories/webhooks.repo.js';

function postJson(urlStr, body) {
    const url = new URL(urlStr);
    const payload = JSON.stringify(body || {});
    const opts = {
        method: 'POST',
        hostname: url.hostname,
        port: url.port || 443,
        path: url.pathname + url.search,
        headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(payload) },
        timeout: 5000,
    };
    return new Promise((resolve, reject) => {
        const req = https.request(opts, (res) => {
            let data = '';
            res.on('data', (d) => (data += d));
            res.on('end', () => {
                if (res.statusCode >= 200 && res.statusCode < 300) resolve({ status: res.statusCode, data });
                else reject(new Error(`HTTP ${res.statusCode}: ${data}`));
            });
        });
        req.on('error', reject);
        req.on('timeout', () => req.destroy(new Error('timeout')));
        req.write(payload);
        req.end();
    });
}

export async function emit(payload) {
    const { channel } = payload || {};
    if (!channel) throw new Error('channel required');

    const hooks = await webhooksRepo.listEnabled();
    const targets = hooks.filter(h => (h.channels || []).includes(channel));
    const body = {};
    if (payload.content) body.content = String(payload.content).slice(0, 1900);
    if (payload.embed) body.embeds = [payload.embed];

    const ids = [];
    for (const h of targets) {
        const id = await webhooksRepo.createEvent(h.id, 'srp.notify', payload);
        ids.push(id);
        postJson(h.url, body)
            .then(() => webhooksRepo.markDelivered(id))
            .catch((err) => webhooksRepo.markFailed(id, err.message || String(err)));
    }
    return { ok: true, enqueued: ids.length };
}

export default { emit }
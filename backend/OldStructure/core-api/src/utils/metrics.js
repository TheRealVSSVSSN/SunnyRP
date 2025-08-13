import client from 'prom-client';

const register = client.register;

const telemetryEvents = new client.Counter({
    name: 'srp_telemetry_events_total',
    help: 'Count of telemetry events ingested',
    labelNames: ['type', 'subcategory']
});
const anomalies = new client.Counter({
    name: 'srp_anomalies_total',
    help: 'Anomalies detected',
    labelNames: ['kind', 'severity']
});
const replayBlocked = new client.Counter({ name: 'srp_replay_blocked_total', help: 'Requests blocked by replay guard' });
const rateBlocked = new client.Counter({ name: 'srp_rate_blocked_total', help: 'Requests blocked by burst shield' });
const ingestLatency = new client.Histogram({ name: 'srp_telemetry_ingest_ms', help: 'Ingest latency ms', buckets: [5, 10, 25, 50, 100, 200, 500, 1000] });

const cacheHits = new client.Counter({ name: 'srp_cache_hits_total', help: 'cache hits', labelNames: ['driver'] });
const cacheMisses = new client.Counter({ name: 'srp_cache_misses_total', help: 'cache misses', labelNames: ['driver'] });
const lockAcquired = new client.Counter({ name: 'srp_locks_acquired_total', help: 'distributed locks acquired', labelNames: ['type'] });
const lockFailed = new client.Counter({ name: 'srp_locks_failed_total', help: 'distributed locks failed', labelNames: ['type'] });
const lockReleased = new client.Counter({ name: 'srp_locks_released_total', help: 'locks released' });
const lockHold = new client.Histogram({ name: 'srp_lock_hold_ms', help: 'lock hold duration', buckets: [5, 10, 25, 50, 100, 200, 500, 1000, 2000] });

const outboxProcessed = new client.Counter({ name: 'srp_outbox_processed_total', help: 'outbox processed', labelNames: ['result', 'type'] });
const outboxLag = new client.Gauge({ name: 'srp_outbox_lag_seconds', help: 'seconds since newest pending event' });

export default {
    register, client,
    telemetryEvents, anomalies, replayBlocked, rateBlocked, ingestLatency,
    register, client,
    telemetryEvents, anomalies, replayBlocked, rateBlocked, ingestLatency,
    cacheHits, cacheMisses,
    lockAcquired, lockFailed, lockReleased, lockHold,
    outboxProcessed, outboxLag
};
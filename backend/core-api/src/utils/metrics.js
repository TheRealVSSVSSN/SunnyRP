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

export default {
    register, client,
    telemetryEvents, anomalies, replayBlocked, rateBlocked, ingestLatency
};
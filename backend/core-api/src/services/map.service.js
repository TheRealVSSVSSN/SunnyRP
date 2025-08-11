import { patchState } from '../repositories/character_state.repo.js'; // already created in Phase C request
import { writeAudit } from '../repositories/audit.repo.js';

function truthy(v) {
    if (v === true) return true;
    if (typeof v === 'string') return ['1', 'true', 'on', 'yes'].includes(v.toLowerCase());
    return false;
}

/**
 * Handle telemetry position updates.
 * - Opt-in via env at gateway (FiveM) and/or header 'x-srp-telemetry: on'
 * - Stores latest position in character_state (and routing_bucket if provided)
 * - Writes lightweight audit if you want visibility (optional)
 */
export async function ingestPosition({ req, userId, characterId, position, routing_bucket = undefined, speed = undefined, ts = undefined }) {
    const enabledHeader = truthy(req.headers['x-srp-telemetry'] || 'true'); // default true if server opted-in
    if (!enabledHeader) return { stored: false, reason: 'telemetry_disabled' };

    const patch = { position };
    if (routing_bucket !== undefined) patch.routing_bucket = routing_bucket;
    patch.touch = true;

    await patchState(characterId, patch);

    // Optional minimal audit breadcrumb (disable if noisy)
    await writeAudit({
        actor_type: 'player', actor_id: userId, user_id: userId, action: 'telemetry_position',
        meta: { characterId, speed, ts }
    });
    return { stored: true };
}
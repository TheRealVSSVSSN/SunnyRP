import * as config from './config.service.js';

export async function getTime() {
    const live = await config.getLive();
    return live.Time || {};
}

export async function setTimeOverride(hhmm) {
    if (!/^\d{1,2}:\d{2}$/.test(hhmm)) throw new Error('Bad time format HH:MM');
    const merged = await config.patchLive({ Time: { override: hhmm } });
    return merged.Time || {};
}

export async function getWeather() {
    const live = await config.getLive();
    return live.Weather || {};
}

export async function setWeather(type) {
    if (!type || typeof type !== 'string') throw new Error('type required');
    const merged = await config.patchLive({ Weather: { current: { type } } });
    return merged.Weather || {};
}

export default { getTime, setTimeOverride, getWeather, setWeather };
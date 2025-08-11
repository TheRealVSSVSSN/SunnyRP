const config = require('./config.service');

async function getTime() {
    const live = await config.getLive();
    return live.Time || {};
}

async function setTimeOverride(hhmm) {
    if (!/^\d{1,2}:\d{2}$/.test(hhmm)) throw new Error('Bad time format HH:MM');
    const patch = { Time: { override: hhmm } };
    return config.patchLive(patch);
}

async function getWeather() {
    const live = await config.getLive();
    return live.Weather || {};
}

async function setWeather(type) {
    const patch = { Weather: { current: { type } } };
    return config.patchLive(patch);
}

module.exports = {
    getTime,
    setTimeOverride,
    getWeather,
    setWeather,
};
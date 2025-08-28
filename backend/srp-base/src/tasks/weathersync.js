const config = require('../config/env');
const worldRepo = require('../repositories/worldRepository');
const websocket = require('../realtime/websocket');

const JOB_NAME = 'weathersync-forecast';
const INTERVAL_MS = config.weathersync.fetchIntervalMs;

async function syncForecast() {
  if (!config.weathersync.enabled || !config.weathersync.point) return;
  try {
    const url = `https://api.weather.gov/points/${config.weathersync.point}/forecast`;
    const resp = await fetch(url, { headers: { 'User-Agent': 'SunnyRP/1.0 (srp-base)' } });
    if (!resp.ok) return;
    const data = await resp.json();
    const periods = (data.properties?.periods || []).map((p) => ({
      name: p.name,
      startTime: p.startTime,
      endTime: p.endTime,
      temperature: p.temperature,
      windSpeed: p.windSpeed,
      shortForecast: p.shortForecast,
    }));
    await worldRepo.updateForecast(periods);
    websocket.broadcast('world', 'forecast.updated', { forecast: periods });
  } catch (err) {
    // Swallow errors; scheduler will retry on next interval.
  }
}

module.exports = { JOB_NAME, INTERVAL_MS, syncForecast };

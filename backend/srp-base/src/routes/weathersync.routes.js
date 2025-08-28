const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const worldRepo = require('../repositories/worldRepository');
const websocket = require('../realtime/websocket');

// Router providing weather synchronisation utilities including
// forecast retrieval and proxy access to api.weather.gov endpoints.
const router = express.Router();

// Retrieve the latest stored weather forecast.
router.get('/v1/weathersync/forecast', async (req, res, next) => {
  try {
    const forecast = await worldRepo.getForecast();
    sendOk(res, forecast, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Update the stored forecast and broadcast to clients.
router.post('/v1/weathersync/forecast', async (req, res, next) => {
  try {
    const { forecast } = req.body || {};
    await worldRepo.updateForecast(forecast);
    websocket.broadcast('world', 'forecast.updated', { forecast });
    sendOk(res, { message: 'Forecast updated' }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Proxy for api.weather.gov. Clients supply the desired endpoint via
// the `endpoint` query parameter, e.g.
// `/v1/weathersync/weather.gov?endpoint=points/39.7456,-97.0892/forecast`.
router.get('/v1/weathersync/weather.gov', async (req, res, next) => {
  try {
    const { endpoint = '' } = req.query;
    const url = `https://api.weather.gov/${endpoint}`.replace(/\/+$/, '');
    const resp = await fetch(url, {
      headers: { 'User-Agent': 'SunnyRP/1.0 (srp-base)' },
    });
    const bodyText = await resp.text();
    if (!resp.ok) {
      return sendError(
        res,
        { code: 'WEATHER_GOV_ERROR', message: bodyText.slice(0, 200) },
        resp.status,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    let data;
    try {
      data = JSON.parse(bodyText);
    } catch {
      data = bodyText;
    }
    sendOk(res, data, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;

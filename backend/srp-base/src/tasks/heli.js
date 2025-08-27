const websocket = require('../realtime/websocket');
const dispatcher = require('../hooks/dispatcher');
const heliRepo = require('../repositories/heliRepository');
const config = require('../config/env');
const logger = require('../utils/logger');

const JOB_NAME = 'heli-expire-flights';
const INTERVAL_MS = config.heli.checkIntervalMs;

async function expireStale() {
  const flights = await heliRepo.endStaleFlights(config.heli.maxFlightHours);
  flights.forEach((flight) => {
    websocket.broadcast('heli', 'heli.flightExpired', flight);
    dispatcher.dispatch('heli.flightExpired', flight);
  });
  if (flights.length > 0) {
    logger.info({ count: flights.length }, 'heli: ended stale flights');
  }
}

module.exports = { JOB_NAME, INTERVAL_MS, expireStale };

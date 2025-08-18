const pino = require('pino');

/**
 * Create a base logger instance.  Pino is chosen for its speed and
 * structured output.  Log level defaults to 'info' and can be
 * overridden via the PINO_LOG_LEVEL environment variable.  When
 * running under PM2 the `pino-pretty` module may be used to format
 * output for human consumption.  Logs always include a requestId if
 * present on the request object (see middleware/requestId.js).
 */
const logger = pino({
  level: process.env.PINO_LOG_LEVEL || 'info',
  base: null, // disable pid and hostname in logs
  timestamp: pino.stdTimeFunctions.isoTime,
});

module.exports = logger;
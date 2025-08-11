import pino from 'pino';
import fs from 'fs';
import path from 'path';
import { config } from '../config/index.js';

if (!fs.existsSync(config.log.dir)) fs.mkdirSync(config.log.dir, { recursive: true });

export const logger = pino({
    level: config.log.level,
    transport: config.log.json ? undefined : { target: 'pino-pretty' },
    base: undefined,
    timestamp: pino.stdTimeFunctions.isoTime
}, pino.destination(path.join(config.log.dir, 'core-api.log')));
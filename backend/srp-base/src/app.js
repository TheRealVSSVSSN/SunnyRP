import express from 'express';
import cors from 'cors';
import rateLimit from 'express-rate-limit';
import { requestId } from './middleware/requestId.js';
import { httpMetrics } from './middleware/httpMetrics.js';
import { verifySignature } from './middleware/auth.js';
import { errorHandler } from './middleware/errorHandler.js';
import systemRouter from './routes/system.js';
import accountsRouter from './routes/accounts.js';
import hooksRouter from './routes/hooks.js';
import authRouter from './routes/auth.js';
import inventoryRouter from './routes/inventory.js';
import bankingRouter from './routes/banking.js';
import rolesRouter from './routes/roles.js';
import scoreboardRouter from './routes/scoreboard.js';
import telemetryRouter from './routes/telemetry.js';
import queueRouter from './routes/queue.js';
import schedulerRouter from './routes/scheduler.js';
import voiceRouter from './routes/voice.js';
import sessionsRouter from './routes/sessions.js';
import jobsRouter from './routes/jobs.js';
import worldRouter from './routes/world.js';
import uxRouter from './routes/ux.js';
import { metricsHandler } from './metrics.js';

export const app = express();

app.use(requestId);
app.use(express.json({
  verify: (req, res, buf) => {
    req.rawBody = buf.toString();
  }
}));
app.use(cors());
app.use(rateLimit({ windowMs: 60_000, max: 100 }));
app.use(httpMetrics);
app.use(verifySignature);
app.use('/v1', systemRouter);
app.use('/v1/auth', authRouter);
app.use('/v1/accounts', accountsRouter);
app.use('/v1/hooks', hooksRouter);
app.use('/v1/inventory', inventoryRouter);
app.use('/v1/banking', bankingRouter);
app.use('/v1/roles', rolesRouter);
app.use('/v1/scoreboard', scoreboardRouter);
app.use('/v1/telemetry', telemetryRouter);
app.use('/v1/queue', queueRouter);
app.use('/v1/scheduler', schedulerRouter);
app.use('/v1/voice', voiceRouter);
app.use('/v1/sessions', sessionsRouter);
app.use('/v1/jobs', jobsRouter);
app.use('/v1/world', worldRouter);
app.use('/v1/ux', uxRouter);
app.get('/metrics', metricsHandler);
app.use(errorHandler);

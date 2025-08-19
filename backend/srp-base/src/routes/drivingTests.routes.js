const express = require('express');
const drivingRepo = require('../repositories/drivingTestsRepository');
const { sendOk, sendError } = require('../utils/respond');

/**
 * Routes for managing driving tests.  Driving instructors can record
 * new tests via POST /v1/driving-tests.  Players and authorised
 * instructors can list recent tests with GET /v1/driving-tests?cid=123
 * and fetch specific test reports via GET /v1/driving-tests/:id.
 */
const router = express.Router();

// POST /v1/driving-tests
router.post('/v1/driving-tests', express.json(), async (req, res) => {
  const { cid, icid, instructor, points, passed, results } = req.body || {};
  if (!cid || !icid || typeof points !== 'number' || typeof passed !== 'boolean') {
    return sendError(
      res,
      { code: 'INVALID_INPUT', message: 'cid, icid, points (number) and passed (boolean) are required' },
      400,
      res.locals.requestId,
      res.locals.traceId
    );
  }
  try {
    const timestamp = Math.floor(Date.now() / 1000);
    const test = await drivingRepo.createTest({ cid, icid, instructor: instructor || '', timestamp, points, passed, results });
    sendOk(res, { test }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to record driving test' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/driving-tests?cid=123
router.get('/v1/driving-tests', async (req, res) => {
  const cid = req.query.cid;
  if (!cid) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'cid query parameter is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const history = await drivingRepo.getHistory(cid);
    sendOk(res, { tests: history }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch driving tests' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/driving-tests/:id
router.get('/v1/driving-tests/:id', async (req, res) => {
  const id = parseInt(req.params.id, 10);
  if (Number.isNaN(id)) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'Test ID must be a number' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const test = await drivingRepo.getTest(id);
    if (!test) {
      return sendError(res, { code: 'NOT_FOUND', message: 'Driving test not found' }, 404, res.locals.requestId, res.locals.traceId);
    }
    sendOk(res, { test }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch driving test' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
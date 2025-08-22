const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const { listTweets, createTweet } = require('../repositories/phoneRepository');

const router = express.Router();

router.get('/v1/phone/tweets', async (req, res) => {
  try {
    const tweets = await listTweets();
    sendOk(res, { tweets }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'TWEETS_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

router.post('/v1/phone/tweets', async (req, res) => {
  const { handle, message, time } = req.body || {};
  if (!handle || !message) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'handle and message are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  if (String(message).length > 280 || String(handle).length > 64) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'handle or message too long' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const tweet = await createTweet(handle, message, time);
    sendOk(res, { tweet }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'TWEET_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;

const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const WebsitesRepository = require('../repositories/websitesRepository');
const economyRepository = require('../repositories/economyRepository');

const router = express.Router();

// Rate limit: allow up to 5 website creations per minute per IP
const { createRateLimiter } = require('../middleware/rateLimit');
const websitesLimiter = createRateLimiter({ windowMs: 60_000, max: 5 });
router.use('/v1/websites', websitesLimiter);

/**
 * GET /v1/websites
 *
 * Returns a list of websites.  If `ownerId` query parameter is provided,
 * only websites belonging to that character are returned.  Otherwise all
 * websites are returned.  This endpoint mirrors the `websitesList`
 * event in the original server, but exposed as an HTTP API.
 */
router.get('/v1/websites', async (req, res) => {
  try {
    const { ownerId } = req.query;
    let websites;
    if (ownerId) {
      const owner = parseInt(ownerId, 10);
      if (Number.isNaN(owner)) {
        return sendError(
          res,
          { code: 'INVALID_ARGUMENT', message: 'ownerId must be a valid integer' },
          400,
          res.locals.requestId,
          res.locals.traceId,
        );
      }
      websites = await WebsitesRepository.getWebsitesByOwner(owner);
    } else {
      websites = await WebsitesRepository.getAllWebsites();
    }
    return sendOk(res, { websites }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    return sendError(res, { code: 'INTERNAL_ERROR', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

/**
 * POST /v1/websites
 *
 * Creates a new website owned by the specified character.  The body
 * must contain `ownerId` (character ID), `name`, and may include
 * `keywords` and `description`.  A fixed fee of $500 is charged from
 * the player's cash balance.  If the player does not have enough
 * money, the request fails with a 400 error.  On success the
 * created website record is returned.
 */
router.post('/v1/websites', async (req, res) => {
  try {
    const { ownerId, name, keywords, description } = req.body || {};
    if (!ownerId || !name) {
      return sendError(
        res,
        { code: 'INVALID_ARGUMENT', message: 'ownerId and name are required' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const owner = parseInt(ownerId, 10);
    if (Number.isNaN(owner)) {
      return sendError(
        res,
        { code: 'INVALID_ARGUMENT', message: 'ownerId must be a valid integer' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const trimmedName = String(name).trim();
    if (trimmedName.length === 0) {
      return sendError(
        res,
        { code: 'INVALID_ARGUMENT', message: 'name cannot be empty' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    // Fixed cost for purchasing a website, in cents (500 dollars)
    const cost = 500;
    // Withdraw money from player's cash balance.  Throws if insufficient.
    await economyRepository.withdraw(owner, cost, 'WEBSITE_PURCHASE');
    const website = await WebsitesRepository.createWebsite(owner, trimmedName, keywords || '', description || '');
    return sendOk(res, { website }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    if (err && err.code === 'INSUFFICIENT_FUNDS') {
      return sendError(res, { code: 'INSUFFICIENT_FUNDS', message: err.message }, 400, res.locals.requestId, res.locals.traceId);
    }
    return sendError(res, { code: 'INTERNAL_ERROR', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
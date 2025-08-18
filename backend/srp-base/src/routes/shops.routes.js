const express = require('express');
const shopsRepo = require('../repositories/shopsRepository');
const { sendOk, sendError } = require('../utils/respond');

/**
 * Routes for managing shops and their products.  Use these
 * endpoints to create shops, add products, list shops and
 * products.  Prices are in whole units (e.g. cents).  Stock
 * can be null for unlimited supply.
 */

const router = express.Router();

// GET /v1/shops - list all shops
router.get('/v1/shops', async (req, res) => {
  try {
    const shops = await shopsRepo.getAllShops();
    sendOk(res, { shops }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch shops' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/shops - create a new shop
router.post('/v1/shops', express.json(), async (req, res) => {
  const { name, description, location, type } = req.body || {};
  if (!name) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'name is required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const shop = await shopsRepo.createShop({ name, description, location, type });
    sendOk(res, { shop }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to create shop' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// GET /v1/shops/:shopId/products - list products for a shop
router.get('/v1/shops/:shopId/products', async (req, res) => {
  const shopId = Number(req.params.shopId);
  try {
    const products = await shopsRepo.getProducts(shopId);
    sendOk(res, { products }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to fetch products' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// POST /v1/shops/:shopId/products - create a product for a shop
router.post('/v1/shops/:shopId/products', express.json(), async (req, res) => {
  const shopId = Number(req.params.shopId);
  const { item, price, stock } = req.body || {};
  if (!item || price === undefined) {
    return sendError(res, { code: 'INVALID_INPUT', message: 'item and price are required' }, 400, res.locals.requestId, res.locals.traceId);
  }
  try {
    const product = await shopsRepo.createProduct({ shopId, item, price, stock });
    sendOk(res, { product }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'INTERNAL_ERROR', message: 'Failed to create product' }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
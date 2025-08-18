const db = require('./db');

/**
 * Repository for managing shops and the products sold in them.  Shops
 * represent physical or virtual storefronts within the game world.  Each
 * product references an item (string) and defines a price and stock.
 * Stock can be null to represent infinite supply.  Price is stored in
 * whole units (e.g. cents) to avoid floating point issues.
 */

async function getAllShops() {
  const [rows] = await db.query('SELECT id, name, description, location, type, created_at, updated_at FROM shops ORDER BY id');
  return rows.map(r => ({
    id: r.id,
    name: r.name,
    description: r.description,
    location: r.location ? JSON.parse(r.location) : null,
    type: r.type,
    createdAt: r.created_at,
    updatedAt: r.updated_at,
  }));
}

async function createShop({ name, description = null, location = null, type = null }) {
  const locJson = location ? JSON.stringify(location) : null;
  const [result] = await db.query(
    'INSERT INTO shops (name, description, location, type) VALUES (?, ?, ?, ?)',
    [name, description, locJson, type],
  );
  return getShop(result.insertId);
}

async function getShop(id) {
  const [rows] = await db.query('SELECT id, name, description, location, type, created_at, updated_at FROM shops WHERE id = ?', [id]);
  const r = rows[0];
  if (!r) return null;
  return {
    id: r.id,
    name: r.name,
    description: r.description,
    location: r.location ? JSON.parse(r.location) : null,
    type: r.type,
    createdAt: r.created_at,
    updatedAt: r.updated_at,
  };
}

async function getProducts(shopId) {
  const [rows] = await db.query(
    'SELECT id, shop_id, item, price, stock, created_at, updated_at FROM shop_products WHERE shop_id = ?',
    [shopId],
  );
  return rows.map(r => ({
    id: r.id,
    shopId: r.shop_id,
    item: r.item,
    price: Number(r.price),
    stock: r.stock,
    createdAt: r.created_at,
    updatedAt: r.updated_at,
  }));
}

async function createProduct({ shopId, item, price, stock = null }) {
  const [result] = await db.query(
    'INSERT INTO shop_products (shop_id, item, price, stock) VALUES (?, ?, ?, ?)',
    [shopId, item, price, stock],
  );
  const [rows] = await db.query(
    'SELECT id, shop_id, item, price, stock, created_at, updated_at FROM shop_products WHERE id = ?',
    [result.insertId],
  );
  const r = rows[0];
  return {
    id: r.id,
    shopId: r.shop_id,
    item: r.item,
    price: Number(r.price),
    stock: r.stock,
    createdAt: r.created_at,
    updatedAt: r.updated_at,
  };
}

module.exports = {
  getAllShops,
  createShop,
  getShop,
  getProducts,
  createProduct,
};
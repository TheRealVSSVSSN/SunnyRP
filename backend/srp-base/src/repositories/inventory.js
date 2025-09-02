import { query } from '../db/index.js';

export async function getInventory(characterId) {
  return query(
    `SELECT ci.item_id AS itemId, i.name AS itemName, ci.quantity
     FROM character_inventory ci
     JOIN items i ON ci.item_id = i.id
     WHERE ci.character_id = ?`,
    [characterId]
  );
}

export async function addItem(characterId, { itemId, quantity }) {
  await query(
    `INSERT INTO character_inventory (character_id, item_id, quantity)
     VALUES (?, ?, ?)
     ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity)`,
    [characterId, itemId, quantity]
  );
}

export async function removeItem(characterId, itemId) {
  await query(
    `DELETE FROM character_inventory WHERE character_id = ? AND item_id = ?`,
    [characterId, itemId]
  );
}

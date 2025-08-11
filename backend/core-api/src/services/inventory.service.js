import { getCharacterInventory, getInventory, addItem, removeItem } from '../repositories/inventory.repo.js';

export async function getCharInventory(charId) {
    return await getCharacterInventory(charId);
}

export async function addToInventory({ idemKey, container_type, container_id, item_key, quantity, slot, metadata, defaultMaxStack }) {
    return await addItem({ idemKey, container_type, container_id, item_key, quantity, slot, metadata, defaultMaxStack });
}

export async function removeFromInventory({ idemKey, container_type, container_id, item_key, quantity, slot }) {
    return await removeItem({ idemKey, container_type, container_id, item_key, quantity, slot });
}
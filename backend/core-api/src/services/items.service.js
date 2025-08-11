import { listItems } from '../repositories/items.repo.js';
export async function fetchItems() { return await listItems(); }
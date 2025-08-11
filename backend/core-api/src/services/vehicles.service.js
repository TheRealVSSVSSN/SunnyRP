import {
    listByChar, listByState, getById, createVehicle, storeVehicle, retrieveVehicle,
    updateState, transferTitle, markImpounded, deleteVehicleAdmin
} from '../repositories/vehicles.repo.js';
import { grantKey, revokeKey, hasKey, listKeys } from '../repositories/vehicleKeys.repo.js';

export async function getVehicles({ charId, state }) {
    if (charId) return await listByChar(charId);
    if (state) return await listByState(state);
    return [];
}

export async function registerVehicle(body) {
    const v = await createVehicle(body);
    // owner always has a key
    await grantKey({ vehicle_id: v.id, char_id: v.owner_char_id, granted_by: v.owner_char_id });
    return v;
}

export async function storeVehicleSvc(body) { return await storeVehicle(body); }
export async function retrieveVehicleSvc(body) { return await retrieveVehicle(body); }
export async function updateVehicleStateSvc(body) { return await updateState(body); }

export async function grantKeySvc(body) { return await grantKey(body); }
export async function revokeKeySvc(body) { return await revokeKey(body); }
export async function hasKeySvc(body) { return await hasKey(body); }
export async function listKeysSvc(id) { return await listKeys(id); }

export async function transferTitleSvc(body) { return await transferTitle(body); }
export async function impoundSvc(body) { return await markImpounded(body); }
export async function adminDeleteSvc(id) { return await deleteVehicleAdmin(id); }
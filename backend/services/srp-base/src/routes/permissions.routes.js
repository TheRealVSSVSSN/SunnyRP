// src/routes/permissions.routes.js
import { Router } from "express";
import { ok, fail } from "../utils/respond.js";

let rolesRepo = null;
async function loadRepo() {
    if (!rolesRepo) {
        try { rolesRepo = await import("../repositories/roles.repo.js"); }
        catch { rolesRepo = null; }
    }
}

const router = Router();

async function handleGet(req, res) {
    const raw = req.params.playerId;
    const playerId = Number(raw);
    if (!playerId || Number.isNaN(playerId)) {
        return fail(req, res, "INVALID_INPUT", "playerId must be a number");
    }

    await loadRepo();
    if (!rolesRepo || !rolesRepo.getScopesForUserId) {
        // Non-blocking fallback while DB comes up
        return ok(req, res, { scopes: ["player"] });
    }

    try {
        const scopes = await rolesRepo.getScopesForUserId(playerId);
        return ok(req, res, { scopes: Array.isArray(scopes) ? scopes : [] });
    } catch {
        return fail(req, res, "INTERNAL_ERROR", "Could not fetch permissions");
    }
}

// Back-compat (legacy path) AND v1 path
router.get("/permissions/:playerId", handleGet);
router.get("/v1/permissions/:playerId", handleGet);

export const permissionsRouter = router;
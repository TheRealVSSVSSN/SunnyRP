// src/routes/ping.routes.js
import { Router } from "express";
import { ok } from "../utils/respond.js";

export default function pingRoutes() {
    const r = Router();
    r.get("/v1/ping", (req, res) => {
        ok(req, res, {
            service: "srp-base",
            ts: Date.now(),
            env: process.env.NODE_ENV || "development",
        });
    });
    return r;
}
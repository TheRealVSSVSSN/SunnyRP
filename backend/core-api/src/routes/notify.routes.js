const express = require('express');
const router = express.Router();
const hmacVerify = require('../middleware/hmacVerify'); // game uses HMAC
const notify = require('../services/notify.service');

// Game server calls this with { channel, content?, embed? }
router.post('/emit', hmacVerify(), async (req, res) => {
    try {
        const result = await notify.emit(req.body || {});
        res.json(result);
    } catch (e) {
        res.status(400).json({ error: e.message });
    }
});

module.exports = router;
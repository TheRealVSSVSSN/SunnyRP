const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const {
  getAllNotes,
  createNote,
  deleteNote,
} = require('../repositories/notesRepository');

const router = express.Router();

// List all notes
router.get('/v1/notes', async (req, res) => {
  try {
    const notes = await getAllNotes();
    sendOk(res, { notes }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'NOTES_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Create a new note
router.post('/v1/notes', async (req, res) => {
  const { text, x, y, z } = req.body;
  if (!text || typeof text !== 'string') {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'text is required and must be a string' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  if (x === undefined || y === undefined || z === undefined) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'x, y, and z coordinates are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const note = await createNote({ text, x: Number(x), y: Number(y), z: Number(z) });
    sendOk(res, { note }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'NOTE_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Delete a note
router.delete('/v1/notes/:id', async (req, res) => {
  const { id } = req.params;
  const idNum = parseInt(id, 10);
  if (Number.isNaN(idNum)) {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'id must be a valid integer' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    await deleteNote(idNum);
    sendOk(res, {}, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'NOTE_DELETE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;
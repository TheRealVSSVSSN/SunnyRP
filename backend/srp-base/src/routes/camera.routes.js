const express = require('express');
const { sendOk, sendError } = require('../utils/respond');
const {
  listPhotosByCharacter,
  createPhoto,
  deletePhoto,
  updatePhoto,
} = require('../repositories/cameraRepository');
const websocket = require('../realtime/websocket');
const dispatcher = require('../hooks/dispatcher');

const router = express.Router();

// List photos for a character
router.get('/v1/camera/photos/:characterId', async (req, res) => {
  try {
    const { characterId } = req.params;
    const idNum = parseInt(characterId, 10);
    if (Number.isNaN(idNum)) {
      return sendError(
        res,
        { code: 'VALIDATION_ERROR', message: 'characterId must be a valid integer' },
        400,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    const photos = await listPhotosByCharacter(idNum);
    sendOk(res, { photos }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CAMERA_LIST_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Create a photo
router.post('/v1/camera/photos', async (req, res) => {
  const { characterId, imageUrl, description } = req.body || {};
  const idNum = parseInt(characterId, 10);
  if (Number.isNaN(idNum) || !imageUrl || typeof imageUrl !== 'string') {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'characterId and imageUrl are required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const photo = await createPhoto({ characterId: idNum, imageUrl, description });
    websocket.broadcast('camera', 'photo.created', { photo });
    dispatcher.dispatch('camera.photo.created', photo);
    sendOk(res, { photo }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CAMERA_CREATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Delete a photo
router.delete('/v1/camera/photos/:id', async (req, res) => {
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
    await deletePhoto(idNum);
    websocket.broadcast('camera', 'photo.deleted', { id: idNum });
    dispatcher.dispatch('camera.photo.deleted', { id: idNum });
    sendOk(res, {}, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CAMERA_DELETE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

// Update a photo description
router.patch('/v1/camera/photos/:id', async (req, res) => {
  const { id } = req.params;
  const idNum = parseInt(id, 10);
  const { description } = req.body || {};
  if (Number.isNaN(idNum) || typeof description !== 'string') {
    return sendError(
      res,
      { code: 'VALIDATION_ERROR', message: 'id must be an integer and description required' },
      400,
      res.locals.requestId,
      res.locals.traceId,
    );
  }
  try {
    const photo = await updatePhoto(idNum, { description });
    if (!photo) {
      return sendError(
        res,
        { code: 'NOT_FOUND', message: 'photo not found' },
        404,
        res.locals.requestId,
        res.locals.traceId,
      );
    }
    websocket.broadcast('camera', 'photo.updated', { photo });
    dispatcher.dispatch('camera.photo.updated', photo);
    sendOk(res, { photo }, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    sendError(res, { code: 'CAMERA_UPDATE_FAILED', message: err.message }, 500, res.locals.requestId, res.locals.traceId);
  }
});

module.exports = router;

const express = require('express');
const { sendOk } = require('../utils/respond');
const jobsRepo = require('../repositories/jobsRepository');

// Routes for job management.  These endpoints expose CRUD for
// job definitions and allow characters to be assigned to jobs and
// toggle duty status with optional grade tracking.  They do not
// enforce gameplay logic like paychecks or rank restrictions –
// that belongs in Lua or higher level services.
const router = express.Router();

// List all jobs
router.get('/v1/jobs', async (req, res, next) => {
  try {
    const jobs = await jobsRepo.listJobs();
    sendOk(res, jobs, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Create a new job
router.post('/v1/jobs', async (req, res, next) => {
  try {
    const { name, label, description } = req.body || {};
    const job = await jobsRepo.createJob({ name, label, description });
    sendOk(res, job, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Get a single job by ID
router.get('/v1/jobs/:id', async (req, res, next) => {
  try {
    const id = parseInt(req.params.id, 10);
    const job = await jobsRepo.getJob(id);
    sendOk(res, job, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Assign a job to a character.  If the assignment already exists it
// will be updated.  on_duty is set to false by default.
router.post('/v1/jobs/assign', async (req, res, next) => {
  try {
    const { characterId, jobId, grade } = req.body || {};
    const assignment = await jobsRepo.assignJob(
      parseInt(characterId, 10),
      parseInt(jobId, 10),
      grade !== undefined ? parseInt(grade, 10) : 0,
    );
    sendOk(res, assignment, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Toggle a character's duty status for a job.  Expects characterId,
// jobId and onDuty (boolean).  Creates the assignment if needed.
router.post('/v1/jobs/duty', async (req, res, next) => {
  try {
    const { characterId, jobId, onDuty } = req.body || {};
    const assignment = await jobsRepo.setDuty(
      parseInt(characterId, 10),
      parseInt(jobId, 10),
      Boolean(onDuty),
    );
    sendOk(res, assignment, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

// Get a character's job assignments
router.get('/v1/jobs/:characterId/assignments', async (req, res, next) => {
  try {
    const { characterId } = req.params;
    const assignments = await jobsRepo.getCharacterJobs(parseInt(characterId, 10));
    sendOk(res, assignments, res.locals.requestId, res.locals.traceId);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
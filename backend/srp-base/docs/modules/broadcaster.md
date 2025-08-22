# Broadcaster Module

The broadcaster module implements the server‑side logic of the
legacy `np-broadcaster` resource in the unified `srp‑base`
=======
original `np-broadcaster` resource in the unified `srp‑base`
backend.  In the original Lua resource, players trigger an
`attemptBroadcast` event to become a broadcaster.  The server
counts how many broadcasters are currently active and, if below a
hard-coded limit, assigns the broadcaster job using the job manager.

## Endpoints

### `POST /v1/broadcast/attempt`

Attempts to assign the `broadcaster` job to the specified player.
The request body must include:

```
{
  "playerId": "string"
}
```

If the player ID is missing, a `INVALID_INPUT` error is returned.

The server counts current assignments of the `broadcaster` job via
`jobsRepository.countPlayersForJob('broadcaster')`.  If the count
is greater than or equal to the configured maximum (default 5,
override with `MAX_BROADCASTERS` environment variable), the
request fails with a `LIMIT_REACHED` error.  Otherwise, the
module looks up the `broadcaster` job definition via
`jobsRepository.getJobByName('broadcaster')`.  If the job does not
exist, a `NOT_FOUND` error is returned.  On success, the module
calls `jobsRepository.assignJob(playerId, job.id)` to assign the
job (on duty remains false) and responds with the assignment.

#### Response (`200 OK`)

```
{
  "playerId": "<string>",
  "jobId": <number>,
  "onDuty": false,
  "hiredAt": "<ISO8601 timestamp>"
}
```

On error, the response follows the standard SRP error envelope
containing a code and message.

## Configuration

The maximum number of broadcasters is controlled by the
`MAX_BROADCASTERS` environment variable.  If unset, it defaults
to 5.  Set this variable in your environment or `.env` file to
change the limit without code changes.

## Notes

* The broadcaster job must be predefined in the `jobs` table with
  the name `broadcaster`.  If it does not exist, the endpoint will
  return a `NOT_FOUND` error.
* The module does not automatically set players on duty; it simply
  creates or updates the assignment with `on_duty = 0`.  Clients or
  higher‑level systems may call the jobs duty endpoint to toggle
  duty status.
* Rate limiting, authentication and idempotency policies are
  inherited from the global middleware in `src/app.js`.
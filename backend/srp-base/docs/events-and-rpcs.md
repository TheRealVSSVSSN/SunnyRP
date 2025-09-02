# Events and RPCs

## WebSocket Events
- Namespace: default
- Envelope fields: `id`, `type`, `source`, `subject`, `time`, `specversion`, `data`
- Built-in: `ping` -> `pong`
- `srp.system.time` -> server time tick honoring `TIMEZONE`
- `srp.scoreboard.update` -> player ping, name, or job update
- `srp.scoreboard.remove` -> player removed/timeout
- `srp.telemetry.error` -> error log created
- `srp.telemetry.rcon` -> RCON command logged
- `srp.telemetry.exec` -> remote code executed
- `srp.telemetry.restart.schedule` -> restart scheduled
- `srp.telemetry.restart` -> restart due
- `srp.telemetry.restart.cancel` -> restart cancelled
- `srp.telemetry.debug` -> debug message logged
- `srp.queue.update` -> queue membership changed
- `srp.scheduler.run` -> scheduler task triggered
- `srp.voice.join` -> character joined voice channel
- `srp.voice.leave` -> character left voice channel
- `srp.sessions.whitelist` -> whitelist entry added or removed
- `srp.sessions.hardcap` -> hardcap value changed
- `srp.sessions.cid` -> CID assigned
- `srp.sessions.hospitalize` -> character hospitalized
- `srp.sessions.discharge` -> character discharged
- `srp.jobs.primary` -> primary job set
- `srp.jobs.secondary.add` -> secondary job added
- `srp.jobs.secondary.remove` -> secondary job removed
- `srp.world.weather` -> weather changed
- `srp.world.zone.create` -> zone created
- `srp.world.zone.delete` -> zone deleted
- `srp.world.barrier.create` -> barrier created
- `srp.world.barrier.delete` -> barrier deleted
- `srp.world.coords` -> character coordinates saved
- `srp.world.infinity.entity` -> entity coordinates updated
- `srp.ux.chat` -> chat message broadcast
- `srp.ux.vote.start` -> vote started
- `srp.ux.vote.cast` -> vote cast
- `srp.ux.taskbar` -> task progress update
- `srp.ux.taskbarskill` -> skill meter update
- `srp.ux.taskbarthreat` -> threat meter update
- `srp.ux.tasknotify` -> task notification
- `srp.ux.notify` -> generic notification
- `srp.ux.broadcast` -> notification broadcast
- `srp.voice.broadcast` -> character broadcast state change
- `srp.sessions.spawn` -> character spawn logged

## Webhooks
- All WebSocket events are mirrored to registered endpoints.

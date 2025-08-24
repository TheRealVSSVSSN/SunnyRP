# Admin Operations

- Apply database migrations with:
  ```sh
  node src/bootstrap/migrate.js
  ```
- Ensure the `diamond_blackjack_hands` table exists after deploying this sprint.
- Ensure the `interact_sound_plays` table exists after deploying this sprint.
- Ensure the `doors` table exists to track door states.
- Manage the Node.js process with tools like `pm2` for restarts and monitoring.
- Ensure the `evidence_chain` and `character_selections` tables exist after deploying this sprint.
- Ensure the `zones` table exists for polygonal zone definitions.
- Ensure the `wise_audio_tracks` table exists for character audio tracks.

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
- Ensure the `wise_import_orders` table exists for vehicle import orders.
- Ensure the `wise_uc_profiles` table exists for undercover aliases.
- Ensure the `wise_wheels_spins` table exists for wheel spin history.
- Ensure the `assets` table exists for character asset records.
- Ensure the `clothes` table exists for character outfit records.
- Ensure the `apartments` and `apartment_residents` tables exist and include the `character_id` column after deploying this sprint.
- Ensure the `accounts` and `transactions` tables use `character_id` columns after deploying this sprint.
- Ensure the `base_event_logs` table exists for base event history.
- Ensure the `boatshop_boats` table exists for boat catalog data.

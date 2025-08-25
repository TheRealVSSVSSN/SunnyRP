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
- Ensure the `cron_jobs` table exists for scheduled tasks.
- Ensure the `base_event_logs` table exists for base event history.
- Ensure the `boatshop_boats` table exists for boat catalog data.
- Ensure the `camera_photos` table exists for stored photos.
- Ensure the `character_hud_preferences` table exists for HUD settings.
- Ensure the `carwash_transactions` and `vehicle_cleanliness` tables exist for carwash tracking.
- Ensure the `chat_messages` table exists for chat logging.
- Ensure the `queue_priorities` table exists for connection queue priority management.
- Ensure the `character_coords` table exists for saved coordinates.
- Ensure the `interiors` table exists for apartment interior layouts.
- Ensure the `character_emotes` table exists for favorite emotes.
- Ensure the `ems_records` and `ems_shift_logs` tables exist for EMS operations.
- Ensure the `taxi_rides` table exists for taxi dispatch.
- Ensure the `furniture` table exists for stored furniture placements.
- Ensure the `hospital_admissions` table exists for patient tracking.
- Ensure the `hardcap_config` and `hardcap_sessions` tables exist for player capacity tracking.
- Ensure the `heli_flights` table exists for helicopter flight logs.
- Ensure the `import_pack_orders` table includes `price` and `canceled_at` columns for import package tracking.
- Ensure the `character_peds` table exists for ped state tracking.
- Ensure the `jailbreak_attempts` table exists for jailbreak tracking.
- Ensure the `jobs` and `character_jobs` tables exist for job management.
- Ensure the `k9_units` table exists after applying migration 057.

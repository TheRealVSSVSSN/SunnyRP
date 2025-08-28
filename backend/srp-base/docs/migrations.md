# Migrations

| File | Description |
|---|---|
| 001_init.sql | Initial schema |
| 002_extended_services.sql | Extended services |
| 003_additional_tables.sql | Additional tables |
| 004_add_doors_error_weapons_shops.sql | Doors, error logging, weapons, shops |
| 005_add_gangs_garages_apartments_police.sql | Gangs, garages, apartments, police tables |
| 006_add_blips_crimeschool.sql | Blips and crime school |
| 009_add_driving_tests.sql | Driving tests table |
| 010_add_weed_plants.sql | Weed plants table |
| 011_add_websites.sql | Websites table |
| 012_add_notes.sql | Notes table |
| 015_add_player_ammo.sql | Player ammo table |
| 016_add_secondary_jobs.sql | Secondary jobs table |
| 017_add_vehicle_condition.sql | Vehicle condition columns |
| 018_add_contracts.sql | Contracts table |
| 019_add_tweets.sql | Tweets table |
| 020_add_bans.sql | Bans table |
| 021_add_diamond_blackjack.sql | Blackjack hand history table |
| 022_add_interact_sound.sql | Sound play history table |
| 023_add_evidence_chain.sql | Evidence custody chain table |
| 024_add_character_selections.sql | Track active character per account |
| 025_add_zones.sql | Zones table |
| 026_add_wise_audio.sql | Wise audio tracks table |
| 027_add_wise_imports.sql | Wise imports orders table |
| 028_add_wise_uc.sql | Wise UC profiles table |
| 029_add_wise_wheels.sql | Wise wheels spins table |
| 030_add_assets.sql | Assets table |
| 031_add_clothes.sql | Clothes table |
| 032_add_apartment_residents_character_fk.sql | Enforce character_id for apartment residents |
| 033_update_economy_character_scoping.sql | Rename player columns to character columns for accounts and transactions |
| 034_add_base_event_logs.sql | Base event logs table |
| 035_add_boatshop.sql | Boat shop catalog |
| 036_add_camera_photos.sql | Camera photos table |
| 037_add_character_hud_preferences.sql | HUD preferences table |
| 038_add_carwash.sql | Carwash transactions and vehicle cleanliness tables |
| 039_add_chat_messages.sql | Chat messages table |
| 040_add_queue_priorities.sql | Queue priority table |
| 041_add_character_coords.sql | Saved coordinate storage table |
| 042_add_cron_jobs.sql | Cron jobs table |
| 043_add_interiors.sql | Apartment interior layouts |
| 044_add_character_emotes.sql | Character emote favorites table |
| 045_add_ems_shift_logs.sql | EMS shift logs table |
| 046_add_taxi_rides.sql | Taxi ride request table |
| 047_add_furniture.sql | Furniture table |
| 048_add_hospital_admissions.sql | Hospital admissions table |
| 049_add_garage_vehicle_character.sql | Add character_id to garage_vehicles |
| 050_add_hardcap.sql | Hardcap configuration and session tables |
| 051_add_heli_flights.sql | Helicopter flight logging table |
| 052_add_import_pack_orders.sql | Import pack orders table |
| 053_add_import_pack_order_price_cancel.sql | Add price and canceled_at columns to import pack orders |
| 054_add_character_peds.sql | Ped state table |
| 055_add_jailbreak_attempts.sql | Jailbreak attempt logging table |
| 056_add_character_jobs.sql | Character job assignments table |
| 057_add_k9_units.sql | Police K9 unit table |
| 058_add_world_forecast.sql | Weather forecast schedule table |
| 059_add_diamond_casino.sql | Casino game and bet tables |
| 060_add_world_timecycle.sql | Timecycle override table |
| 061_add_dispatch_alert_index.sql | Index dispatch_alerts created_at |
| 062_add_zone_expiry.sql | Add expires_at to zones |
| 063_update_wise_import_orders.sql | Add updated_at column and status index to wise_import_orders |
| 064_add_wise_wheels_created_index.sql | Index wise_wheels_spins created_at column |
| 065_add_assets_created_index.sql | Index assets created_at column |
| 066_add_properties.sql | Unified properties table for housing and rentals |
| 067_add_invoices.sql | Invoices table for character billing |
| 068_add_ipls.sql | IPL state table |
| 069_add_camera_photos_created_index.sql | Index camera_photos created_at |
| 070_add_character_vehicle_status.sql | Vehicle HUD state table |
| 071_add_vehicle_cleanliness_dirt_index.sql | Index dirt_level for vehicle_cleanliness |
| 072_add_chat_messages_created_index.sql | Index chat_messages created_at column |
| 073_update_interiors_unique_key.sql | Ensure apartment interiors unique per character |
| 074_add_taxi_rides_status_created_index.sql | Index taxi_rides on status and created_at |
| 075_police_officers_character.sql | Rename police_officers player_id to character_id and add index |
| 076_add_garage_vehicle_retrieved_index.sql | Index garage_vehicles retrieved_at column |
| 077_add_hardcap_session_index.sql | Index hardcap_sessions disconnected_at & connected_at |
| 078_add_import_pack_expiry.sql | Add expires_at/expired_at columns and index to import_pack_orders |
| 079_add_jailbreak_started_index.sql | Index jailbreak_attempts started_at column |
| 080_add_debug.sql | Debug logs and markers tables |
| 081_add_recycling_runs.sql | Table for recycling job delivery records |
| 082_add_vehicle_control_states.sql | Vehicle siren/indicator state table |
| 083_add_ems_vehicle_spawns.sql | EMS vehicle spawn log table |

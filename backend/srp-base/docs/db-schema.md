# Database Schema
Added `world_forecast` table for weather scheduling. K9 migration renamed to 057_add_k9_units.sql.


## commands

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| name | VARCHAR(64) | Unique command name |
| description | TEXT | Optional description |
| restricted_police | TINYINT(1) | 1 if police-only |
| restricted_ems | TINYINT(1) | 1 if EMS-only |
| restricted_judge | TINYINT(1) | 1 if judge-only |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Update time |
| INDEX idx_commands_name | (name) |

## bans

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| player_id | VARCHAR(64) | Target player identifier |
| reason | VARCHAR(255) | Ban reason |
| until | DATETIME NULL | Expiration timestamp |
| created_at | TIMESTAMP | Creation time |
| INDEX idx_base_event_logs_type_created | (event_type, created_at) |
| INDEX idx_bans_player | (player_id) |

## unban_events

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| player_id | VARCHAR(64) | Unbanned player identifier |
| actor_id | VARCHAR(64) | Admin who unbanned |
| reason | VARCHAR(255) | Reason provided |
| created_at | TIMESTAMP | Creation time |
| INDEX idx_unban_player | (player_id) |
| INDEX idx_unban_created | (created_at) |

## diamond_casino_games

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| game_type | VARCHAR(32) | blackjack, slots, horse_racing, etc. |
| state | VARCHAR(16) | pending or resolved |
| metadata | JSON | Game-specific data |
| result | JSON | Resolution result |
| created_at | BIGINT | Epoch milliseconds |
| resolved_at | BIGINT | Null until resolved |

## diamond_casino_bets

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| game_id | INT | FK to diamond_casino_games.id |
| character_id | VARCHAR(64) | Betting character |
| bet_amount | INT | Wagered chips |
| bet_data | JSON | Bet details |
| result | JSON | Outcome data |
| payout | INT | Payout amount |
| created_at | BIGINT | Epoch milliseconds |
| resolved_at | BIGINT | Null until resolved |

## interact_sound_plays

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | VARCHAR(64) | Owning character |
| sound | VARCHAR(128) | Sound identifier |
| volume | FLOAT | Playback volume |
| played_at | BIGINT | Epoch milliseconds |

## character_vehicle_status

| Column | Type | Notes |
|---|---|---|
| character_id | INT | PK, FK to characters.id |
| seatbelt | TINYINT(1) | 1 if seatbelt engaged |
| harness | TINYINT(1) | 1 if harness engaged |
| nitrous | INT | Remaining nitrous amount |
| updated_at | DATETIME | Last update timestamp |

## vehicle_control_states

| Column | Type | Notes |
|---|---|---|
| plate | VARCHAR(8) | Primary key; vehicle plate |
| siren_muted | TINYINT(1) | 1 if default siren muted |
| lx_siren_state | TINYINT | Luxart siren state |
| powercall_state | TINYINT | Powercall state |
| air_manu_state | TINYINT | Airhorn/manual state |
| indicator_state | TINYINT | Indicator toggle state |
| updated_at | DATETIME | Last update timestamp |

## dispatch_alerts

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| code | VARCHAR(10) | Alert code |
| title | VARCHAR(255) | Short description |
| description | TEXT | Detailed info |
| sender | VARCHAR(255) | Originating unit |
| coords | JSON | Location data |
| status | ENUM('new','acknowledged') | Default 'new' |
| created_at | TIMESTAMP | Indexed by `idx_dispatch_alerts_created_at` |
| updated_at | TIMESTAMP | Auto updated |

## jobs

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| name | VARCHAR(64) | Unique job name |
| label | VARCHAR(100) | Display label |
| description | TEXT | Optional description |
| created_at | TIMESTAMP | Creation time |

## character_jobs

| Column | Type | Notes |
|---|---|---|
| character_id | BIGINT | FK to characters.id |
| job_id | INT | FK to jobs.id |
| grade | INT | Job grade or rank |
| on_duty | TINYINT(1) | 1 on duty, 0 off |
| hired_at | TIMESTAMP | Assignment time |

## doors

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| door_id | VARCHAR(100) | Unique door identifier |
| name | VARCHAR(255) | Optional label |
| state | TINYINT(1) | 1 locked, 0 unlocked |
| position | JSON | Coordinates metadata |
| heading | FLOAT | Orientation |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Update time |
| indexes | - | `idx_camera_photos_character_id` on `character_id`, `idx_camera_photos_created_at` on `created_at` |
## evidence_chain

| Column | Type | Notes |
|---|---|---|
| id | BIGINT AUTO_INCREMENT | Primary key |
| evidence_id | BIGINT | FK to evidence_items.id |
| handler_id | BIGINT | Character handling the evidence |
| action | VARCHAR(50) | Action description |
| notes | TEXT | Optional notes |
| created_at | TIMESTAMP | Entry timestamp |

## character_selections

| Column | Type | Notes |
|---|---|---|
| owner_hex | VARCHAR(64) | Player account, primary key |
| character_id | BIGINT | Selected character ID |
| selected_at | TIMESTAMP | Selection timestamp |

## zones

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| name | VARCHAR(50) | Zone name |
| type | VARCHAR(20) | Shape type |
| data | JSON | Coordinates and dimensions |
| created_by | BIGINT | Optional character ID |
| created_at | TIMESTAMP | Creation time |
| expires_at | TIMESTAMP | Optional expiration time |

## wise_audio_tracks

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | BIGINT | Owning character |
| label | VARCHAR(255) | Track label |
| url | VARCHAR(1024) | Audio URL |
| created_at | BIGINT | Epoch milliseconds |

## wise_import_orders

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | BIGINT | Owning character |
| model | VARCHAR(64) | Vehicle model identifier |
| status | VARCHAR(32) | Order status |
| created_at | BIGINT | Created timestamp (ms) |
| updated_at | BIGINT | Last status update timestamp (ms) |

## wise_uc_profiles

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | BIGINT | Owning character |
| alias | VARCHAR(100) | Undercover alias |
| active | TINYINT(1) | 1 active, 0 inactive |
| created_at | BIGINT | Epoch milliseconds |
| updated_at | BIGINT | Epoch milliseconds |

## wise_wheels_spins

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | BIGINT | Owning character |
| prize | VARCHAR(255) | Prize description |
| created_at | BIGINT | Epoch milliseconds |

Indexes:

* `idx_wise_wheels_character` on `character_id`
* `idx_wise_wheels_created` on `created_at`

## assets

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| owner_id | BIGINT | Character ID owning the asset |
| url | VARCHAR(1024) | Asset URL |
| type | VARCHAR(100) | MIME or category |
| name | VARCHAR(255) | Optional name |
| created_at | TIMESTAMP | Creation time |

Indexes:

* `idx_assets_owner` on `owner_id`
* `idx_assets_created_at` on `created_at`

## clothes

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | BIGINT | Owning character |
| slot | VARCHAR(50) | Outfit slot identifier |
| name | VARCHAR(100) | Optional outfit name |
| data | TEXT | JSON outfit data |
| created_at | TIMESTAMP | Creation time |

## debug_logs

| Column | Type | Notes |
|---|---|---|
| id | BIGINT AUTO_INCREMENT | Primary key |
| level | VARCHAR(16) | info, warn, error, trace |
| message | TEXT | Log text |
| context | JSON | Optional structured data |
| account_id | VARCHAR(64) | Optional account scope |
| character_id | BIGINT | Optional character scope |
| source | VARCHAR(32) | client/server/resource |
| created_at | TIMESTAMP | Indexed by `idx_debug_logs_created_at` |

## debug_markers

| Column | Type | Notes |
|---|---|---|
| id | BIGINT AUTO_INCREMENT | Primary key |
| type | VARCHAR(32) | text, line, marker, sphere, etc. |
| data | JSON | Marker payload (coords, color, text) |
| created_by | BIGINT | Optional character who created it |
| created_at | TIMESTAMP | Creation time |
| expires_at | TIMESTAMP | Null or expiry timestamp; indexed |

## apartments

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| name | VARCHAR(255) | Apartment name |
| location | JSON | Coordinates metadata |
| price | DECIMAL(10,2) | Purchase price |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Update time |

## accounts

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | VARCHAR(64) | Owning character |
| balance | BIGINT | Balance in cents |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Update time |

## transactions

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| from_character_id | VARCHAR(64) | Sender character |
| to_character_id | VARCHAR(64) | Receiver character |
| amount | BIGINT | Transfer amount |
| reason | VARCHAR(255) | Optional memo |
| created_at | TIMESTAMP | Creation time |

## invoices

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| from_character_id | VARCHAR(64) | Issuing character |
| to_character_id | VARCHAR(64) | Receiving character |
| amount | BIGINT | Amount in cents |
| reason | VARCHAR(255) | Optional memo |
| status | ENUM('pending','paid','cancelled') | Current state |
| due_at | TIMESTAMP | Optional due date |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Update time |

## interiors

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| apartment_id | INT | FK to apartments.id |
| character_id | BIGINT | Owner character |
| template | JSON | Serialized layout |
| updated_at | TIMESTAMP | Last update |

**Indexes**
- `uniq_apartment_character` UNIQUE (`apartment_id`, `character_id`)
- `idx_character` (`character_id`)

## carwash_transactions

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | BIGINT | Owning character |
| plate | VARCHAR(32) | Vehicle plate |
| location | VARCHAR(64) | Carwash location identifier |
| cost | INT | Price paid |
| washed_at | TIMESTAMP | Wash time |

## vehicle_cleanliness

| Column | Type | Notes |
|---|---|---|
| plate | VARCHAR(32) | Primary key |
| dirt_level | INT | 0 clean, higher is dirtier |
| updated_at | TIMESTAMP | Update time |

## apartment_residents

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| apartment_id | INT | FK to apartments.id |
| character_id | BIGINT | Resident character |
| assigned_at | TIMESTAMP | Assignment time |

## base_event_logs

| Column | Type | Notes |
|---|---|---|
| id | BIGINT AUTO_INCREMENT | Primary key |
| account_id | VARCHAR(64) | Owning account hex |
| character_id | BIGINT | Character ID |
| event_type | VARCHAR(50) | Event type identifier |
| metadata | JSON | Optional details |
| created_at | TIMESTAMP | Creation time |

Rows older than `BASE_EVENT_RETENTION_MS` are purged hourly by the `base-events-purge` scheduler.

## boatshop_boats

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| model | VARCHAR(100) | Boat model |
| price | INT | Purchase price |
| created_at | TIMESTAMP | Creation time |

## camera_photos

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | BIGINT | Owning character |
| image_url | VARCHAR(1024) | Image URL |
| description | VARCHAR(255) | Optional description |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Update time |

## character_hud_preferences

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | BIGINT | Owning character |
| speed_unit | ENUM('mph','kph') | Preferred speed units |
| show_fuel | TINYINT(1) | 1 show fuel gauge |
| hud_theme | VARCHAR(50) | Optional theme |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Update time |

## chat_messages

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | BIGINT | Owning character |
| channel | VARCHAR(32) | Message channel |
| message | TEXT | Message content |
| created_at | TIMESTAMP | Creation time |

**Indexes**: `idx_chat_character` on `character_id`, `idx_chat_messages_created_at` on `created_at`

## queue_priorities

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| account_id | INT | FK to accounts.id |
| priority | INT | Higher value = higher queue priority |
| reason | VARCHAR(255) | Optional note |
| expires_at | TIMESTAMP | Optional expiration |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Update time |

## cron_jobs
## character_coords

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| name | VARCHAR(100) | Unique job name |
| schedule | VARCHAR(100) | Cron schedule expression |
| payload | JSON | Optional payload |
| account_id | INT | Optional account scope |
| character_id | INT | Optional character scope |
| priority | INT | Job priority |
| next_run | DATETIME | Next scheduled execution |
| last_run | DATETIME | Last execution time |
| character_id | INT | FK to characters.id |
| name | VARCHAR(100) | Unique per character |
| x | FLOAT | X coordinate |
| y | FLOAT | Y coordinate |
| z | FLOAT | Z coordinate |
| heading | FLOAT | Optional heading |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Update time |

## character_emotes

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | INT | FK to characters.id |
| emote | VARCHAR(64) | Emote command name |
| created_at | TIMESTAMP | Creation time |

## ems_records

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| patient_id | VARCHAR(50) | Character ID of the patient |
| doctor_id | VARCHAR(50) | Character ID of the medic |
| treatment | TEXT | Treatment details |
| status | ENUM('open','closed') | Record status |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Update time |

## ems_shift_logs

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | BIGINT | FK to characters.id |
| start_time | TIMESTAMP | Shift start time |
| end_time | TIMESTAMP NULL | Shift end time |


## taxi_rides

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| passenger_character_id | INT | FK to characters.id |
| driver_character_id | INT | FK to characters.id |
| pickup_x | DOUBLE | Pickup X coordinate |
| pickup_y | DOUBLE | Pickup Y coordinate |
| pickup_z | DOUBLE | Pickup Z coordinate |
| dropoff_x | DOUBLE | Dropoff X coordinate |
| dropoff_y | DOUBLE | Dropoff Y coordinate |
| dropoff_z | DOUBLE | Dropoff Z coordinate |
| fare | INT | Fare amount |
| status | ENUM('requested','accepted','completed','cancelled') | Ride state |
| created_at | TIMESTAMP | Creation time |
| accepted_at | TIMESTAMP | Driver accepted time |
| completed_at | TIMESTAMP | Completion time |
| indexes | - | `idx_taxi_status_created_at` on `(status, created_at)` |

## furniture

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | INT | Owning character |
| item | VARCHAR(100) | Furniture item name |
| x | DOUBLE | X coordinate |
| y | DOUBLE | Y coordinate |
| z | DOUBLE | Z coordinate |
| heading | DOUBLE | Optional heading |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Update time (purged after `FURNITURE_RETENTION_MS`) |

## hospital_admissions

| Column | Type | Notes |
|---|---|---|
| id | BIGINT AUTO_INCREMENT | Primary key |
| character_id | BIGINT | Owning character |
| reason | VARCHAR(255) | Admission reason |
| bed | VARCHAR(50) | Assigned bed |
| admitted_at | TIMESTAMP | Admission time |
| discharged_at | TIMESTAMP | Discharge time |
| notes | TEXT | Additional notes |

Indexes: `idx_hospital_admissions_character` (character_id), `idx_hospital_admissions_active` (character_id, discharged_at)

## garages

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| name | VARCHAR(255) | Garage name |
| location | JSON | Optional coordinates |
| capacity | INT | Maximum vehicles |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Update time |

## garage_vehicles

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| garage_id | INT | FK to garages.id |
| vehicle_id | INT | FK to vehicles.id |
| character_id | BIGINT | Character storing the vehicle |
| stored_at | TIMESTAMP | Storage time |
| retrieved_at | TIMESTAMP | Retrieval time |
| indexes | - | `idx_garage_vehicles_character` on `character_id`, `idx_garage_vehicles_retrieved` on `retrieved_at` |

## hardcap_config

| Column | Type | Notes |
|---|---|---|
| id | TINYINT | Always 1 |
| max_players | INT | Maximum allowed concurrent players |
| reserved_slots | INT | Slots reserved for priority |
| updated_at | TIMESTAMP | Update time |

## hardcap_sessions

| Column | Type | Notes |
|---|---|---|
| id | BIGINT AUTO_INCREMENT | Primary key |
| account_id | BIGINT | FK to accounts.id |
| character_id | BIGINT | FK to characters.id |
| connected_at | TIMESTAMP | Connection time |
| disconnected_at | TIMESTAMP | Disconnection time; null if active |
| indexes | - | `idx_hardcap_sessions_disconnected_connected` on `(disconnected_at, connected_at)` |

## heli_flights

| Column | Type | Notes |
|---|---|---|
| id | BIGINT AUTO_INCREMENT | Primary key |
| character_id | BIGINT | FK to characters.id |
| purpose | VARCHAR(50) | Reason for flight |
| start_time | TIMESTAMP | Flight start time |
| end_time | TIMESTAMP | Flight end time; null if active |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Update time |

Index: `idx_heli_flights_character` on `character_id`

## import_pack_orders

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | BIGINT | FK to characters.id |
| package | VARCHAR(64) | Package identifier |
| price | DECIMAL(10,2) | Order cost |
| status | VARCHAR(32) | pending, delivered or canceled |
| created_at | BIGINT | Milliseconds timestamp |
| expires_at | BIGINT | Expiry timestamp |
| expired_at | BIGINT | Expired timestamp, null if not expired |
| delivered_at | BIGINT | Delivery timestamp, null if not delivered |
| canceled_at | BIGINT | Cancellation timestamp, null if not canceled |

Index `idx_import_pack_orders_status_expires` on `(status, expires_at)` accelerates expiry scans.

## character_peds

| Column | Type | Notes |
|---|---|---|
| character_id | BIGINT PRIMARY KEY | FK to characters.id |
| model | VARCHAR(60) | Ped model name |
| health | INT | Last known health |
| armor | INT | Last known armor |
| updated_at | TIMESTAMP | Update timestamp |


## jailbreak_attempts

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | BIGINT | FK to characters.id |
| prison | VARCHAR(50) | Prison identifier |
| status | ENUM('active','completed','failed') | Attempt state |
| started_at | TIMESTAMP | Start time |
| ended_at | TIMESTAMP | Completion time |
| success | TINYINT(1) | 1 success, 0 failure |
| idx_jailbreak_attempts_started_at | INDEX | Index on started_at for expiry scans |

## k9_units

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | BIGINT | FK to characters.id |
| name | VARCHAR(50) | Dog name |
| breed | VARCHAR(50) | Dog breed |
| active | TINYINT(1) | 1 active, 0 inactive |
| created_at | TIMESTAMP | Creation time |
| retired_at | TIMESTAMP | Retirement time |

## world_forecast

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| forecast | JSON | Array of weather steps |
| created_at | TIMESTAMP | Creation time |

## world_timecycle

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| preset | VARCHAR(64) | Active timecycle preset |
| expires_at | TIMESTAMP | Optional expiration time |
| created_at | TIMESTAMP | Creation time |
Retention of sound play logs is controlled by `INTERACT_SOUND_RETENTION_MS`; older rows are purged by a scheduled task.

## properties

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| type | ENUM(APARTMENT, GARAGE, HOTEL_ROOM) | Property type |
| name | VARCHAR(255) | Property label |
| location | JSON | Optional coordinates |
| price | INT | Purchase or rental price |
| owner_character_id | INT | FK to characters.id |
| expires_at | DATETIME | Lease expiration |
| created_at | DATETIME | Creation time |
| updated_at | DATETIME | Update time |

## ipl_states

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| name | VARCHAR(100) | Unique IPL name |
| enabled | TINYINT(1) | 1 when active |
| updated_at | TIMESTAMP | Last update timestamp |

## police_officers

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | INT | FK to characters.id |
| rank | VARCHAR(50) | Officer rank |
| on_duty | TINYINT(1) | 1 when on duty |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Last update |

## recycling_runs

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | INT | FK to characters.id |
| materials | INT | Amount of material delivered |
| created_at | TIMESTAMP | Creation time |
| INDEX idx_recycling_runs_character_created | (character_id, created_at) |

### ems_vehicle_spawns
Records EMS vehicle spawn requests.
- `id` INT PK
- `character_id` INT FK -> characters.id
- `vehicle_type` VARCHAR(50)
- `created_at` TIMESTAMP default CURRENT_TIMESTAMP
- Index `idx_ems_vehicle_spawns_character_id` on `character_id`

## minimap_blips

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| x | FLOAT | X coordinate |
| y | FLOAT | Y coordinate |
| z | FLOAT | Z coordinate |
| sprite | INT | Blip sprite id |
| color | INT | Blip color |
| label | VARCHAR(255) | Blip label |
| created_at | DATETIME | Creation time |
| updated_at | DATETIME | Update time |
| INDEX idx_minimap_blips_created | (created_at) |

## noclip_events

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| player_id | VARCHAR(64) | Target player identifier |
| actor_id | VARCHAR(64) | Admin/developer who toggled |
| enabled | TINYINT(1) | 1 when enabled |
| created_at | TIMESTAMP | Creation time |
| INDEX idx_noclip_player | (player_id) |
| INDEX idx_noclip_created | (created_at) |

## action_bar_slots

| Column | Type | Notes |
|---|---|---|
| character_id | INT | FK to characters(id) |
| slot | TINYINT | Slot number |
| item | VARCHAR(64) | Item name or null |
| PRIMARY KEY | (character_id, slot) |

### barriers

| Column | Type | Notes |
|---|---|---|
| id | INT | Primary key |
| model | VARCHAR(60) | Barrier model name |
| position | JSON | World coordinates and metadata |
| heading | FLOAT | Heading of the barrier |
| state | TINYINT(1) | 0 = closed, 1 = open |
| expires_at | DATETIME | Null when persistent |
| placed_by | INT | Character who placed the barrier |
| created_at | DATETIME | Creation timestamp |
| updated_at | DATETIME | Last update timestamp |

Indexes:
- `idx_barriers_expires_at` on `expires_at`
- `idx_barriers_placed_by` on `placed_by`

## mechanic_orders

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| vehicle_plate | VARCHAR(16) | Vehicle plate |
| character_id | INT | FK to characters.id |
| description | VARCHAR(255) | Optional description |
| status | ENUM('pending','completed') | Order state |
| created_at | TIMESTAMP | Creation time |
| completed_at | TIMESTAMP NULL | Completion time |
| INDEX idx_mechanic_orders_plate | (vehicle_plate) |
| INDEX idx_mechanic_orders_status | (status) |

## broadcast_messages

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | INT | FK to characters.id |
| message | VARCHAR(255) | Message text |
| created_at | TIMESTAMP | Creation time |
| INDEX idx_broadcast_messages_created_at | (created_at) |

## contracts

| Column | Type | Notes |
|---|---|---|
| id | BIGINT AUTO_INCREMENT | Primary key |
| sender_id | VARCHAR(64) | Sender character ID |
| receiver_id | VARCHAR(64) | Receiver character ID |
| amount | BIGINT | Amount in cents |
| info | TEXT | Optional description |
| paid | TINYINT(1) | 1 if funds transferred |
| accepted | TINYINT(1) NULL | 1 accepted, 0 declined |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Update time |
| INDEX idx_contracts_sender | (sender_id) |
| INDEX idx_contracts_receiver | (receiver_id) |
| INDEX idx_contracts_created_at | (created_at) |

## crime_school

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | INT | FK to characters.id |
| stage | VARCHAR(50) | Current progress stage |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Update time |
| INDEX idx_crime_school_character | (character_id) |

## dealer_offers

| Column | Type | Notes |
|---|---|---|
| id | BIGINT UNSIGNED AUTO_INCREMENT | Primary key |
| item | VARCHAR(100) | Item name |
| price | INT | Price in dollars |
| expires_at | DATETIME | Expiration time |
| created_at | DATETIME | Creation time |
| INDEX idx_dealer_offers_expires_at | (expires_at) | |

## dance_animations

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| name | VARCHAR(64) | Animation name |
| dict | VARCHAR(128) | Animation dictionary |
| animation | VARCHAR(128) | Animation clip |
| disabled | TINYINT(1) | 1 if disabled |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Update time |
| UNIQUE KEY unique_dance (name, dict, animation) |
| INDEX idx_dance_animations_disabled_updated_at (disabled, updated_at) |
## character_marked_bills

| Column | Type | Notes |
|---|---|---|
| character_id | BIGINT | Primary key, references `characters.id` |
| amount | INT | Marked bills balance |
| updated_at | TIMESTAMP | Auto-updated timestamp |

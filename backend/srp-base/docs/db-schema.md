# Database Schema

## diamond_blackjack_hands

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | VARCHAR(64) | Owning character |
| table_id | INT | Blackjack table identifier |
| bet | INT | Wagered chips |
| payout | INT | Net payout (can be negative) |
| dealer_hand | VARCHAR(64) | Dealer card representation |
| player_hand | VARCHAR(64) | Player card representation |
| played_at | BIGINT | Epoch milliseconds |

## interact_sound_plays

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | VARCHAR(64) | Owning character |
| sound | VARCHAR(128) | Sound identifier |
| volume | FLOAT | Playback volume |
| played_at | BIGINT | Epoch milliseconds |

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
| created_at | BIGINT | Epoch milliseconds |

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

## assets

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| owner_id | BIGINT | Character ID owning the asset |
| url | VARCHAR(1024) | Asset URL |
| type | VARCHAR(100) | MIME or category |
| name | VARCHAR(255) | Optional name |
| created_at | TIMESTAMP | Creation time |

## clothes

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | BIGINT | Owning character |
| slot | VARCHAR(50) | Outfit slot identifier |
| name | VARCHAR(100) | Optional outfit name |
| data | TEXT | JSON outfit data |
| created_at | TIMESTAMP | Creation time |

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

## interiors

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| apartment_id | INT | FK to apartments.id |
| character_id | BIGINT | Owner character |
| template | JSON | Serialized layout |
| updated_at | TIMESTAMP | Last update |

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
| updated_at | TIMESTAMP | Update time |

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

## import_pack_orders

| Column | Type | Notes |
|---|---|---|
| id | INT AUTO_INCREMENT | Primary key |
| character_id | BIGINT | FK to characters.id |
| package | VARCHAR(64) | Package identifier |
| price | DECIMAL(10,2) | Order cost |
| status | VARCHAR(32) | pending, delivered or canceled |
| created_at | BIGINT | Milliseconds timestamp |
| delivered_at | BIGINT | Delivery timestamp, null if not delivered |
| canceled_at | BIGINT | Cancellation timestamp, null if not canceled |

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

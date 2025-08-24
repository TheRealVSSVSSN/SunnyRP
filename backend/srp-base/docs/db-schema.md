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
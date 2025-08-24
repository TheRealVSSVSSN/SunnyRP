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

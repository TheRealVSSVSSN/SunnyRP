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

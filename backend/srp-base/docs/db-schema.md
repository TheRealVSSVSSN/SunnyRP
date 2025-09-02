# Database Schema

## accounts
- id PK
- username UNIQUE
- password_hash
- created_at

## characters
- id PK
- account_id FK -> accounts.id
- first_name
- last_name
- created_at
- deleted_at

## account_selected_character
- account_id PK FK -> accounts.id
- character_id FK -> characters.id

## idempotency_keys
- key PK
- expires_at (indexed)

## webhook_endpoints
- id PK
- url
- secret
- created_at

## auth_tokens
- token PK
- account_id FK -> accounts.id
- expires_at
## items
- id PK
- name UNIQUE

## character_inventory
- character_id PK FK -> characters.id
- item_id PK FK -> items.id
- quantity

## bank_accounts
- id PK
- character_id UNIQUE FK -> characters.id
- balance
- created_at

## bank_transactions
- id PK
- bank_account_id FK -> bank_accounts.id
- amount
- type
- description
- created_at

## roles
- id PK
- name UNIQUE
- description

## role_permissions
- role_id FK -> roles.id
- scope

## account_roles
- account_id FK -> accounts.id
- role_id FK -> roles.id

## scheduler_runs
- task_name PK
- last_run

## scoreboard_players
- character_id PK FK -> characters.id
- account_id FK -> accounts.id
- display_name
- job
- ping
- updated_at

## error_logs
- id PK
- service
- level
- message
- created_at (indexed)

## connection_queue
- account_id PK FK -> accounts.id
- priority
- enqueued_at (indexed)

## voice_channels
- channel_id PK
- character_id PK FK -> characters.id
- joined_at (indexed)

## users_whitelist
- account_id PK FK -> accounts.id
- power

## session_limits
- id PK
- max_players

## jobs
- name PK
- label

## character_jobs
- character_id FK -> characters.id
- job_name FK -> jobs.name
- grade
- is_secondary
- PRIMARY KEY(character_id, job_name, is_secondary)
- INDEX character_id

## weather_state
- id PK
- weather
- updated_at

## session_password
- id PK
- password_hash

## character_cids
- cid PK
- character_id UNIQUE FK -> characters.id

## hospitalizations
- character_id PK FK -> characters.id
- admitted_at

## world_zones
- id PK
- name
- data JSON

## world_barriers
- id PK
- zone_id FK -> world_zones.id
- data JSON

## chat_messages
- id PK
- character_id FK -> characters.id
- message
- created_at

## votes
- id PK
- question
- created_at
- ends_at

## vote_options
- id PK
- vote_id FK -> votes.id
- option_text
- count

## vote_responses
- vote_id FK -> votes.id
- character_id FK -> characters.id
- option_id FK -> vote_options.id
- PRIMARY KEY(vote_id, character_id)

## rcon_logs
- id PK
- command
- args
- created_at

## exec_logs
- id PK
- code
- output
- created_at

## restart_schedule
- id PK
- restart_at
- reason

## debug_logs
- id PK
- message
- created_at

## character_coords
- character_id PK FK -> characters.id
- x
- y
- z
- heading
- updated_at

## character_spawns
- id PK
- character_id FK -> characters.id
- x
- y
- z
- heading
- spawned_at

## voice_broadcast
- character_id PK FK -> characters.id
- active
- updated_at

## infinity_entities
- entity_id PK
- x
- y
- z
- heading
- updated_at

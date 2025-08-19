# Progress Ledger – SRP‑Base Node Backend

This ledger tracks our progress porting server behaviours from the
NoPixel resources repository into the unified `srp‑base` Node.js
backend.  For each resource processed, we record its index (based on
alphabetical ordering in the NoPixel `resources` directory), a brief
summary of its server responsibilities, our decision (Skip/Extend/Create),
and a reference to the patch or commit in this repository.  Only
server‑side logic is considered; purely client resources are skipped.

| Index | Resource | Summary of Server Responsibilities | Decision | Patch Reference |
|---|---|---|---|---|
| 1 | baseevents | Handles player connecting, spawning and dropping; registers players and records spawn positions. | Already implemented in initial sprint | — |
| 2 | coordsaver | Saves, lists and deletes coordinate presets; writes to `srp_coords` table. | Already implemented in initial sprint | — |
| 3 | PolyZone | Registers, removes and lists named zones; maintains an in‑memory zone registry. | Already implemented in initial sprint | — |
| 4 | np‑evidence | Receives `evidence:pooled`, `evidence:removal` and `evidence:clear` events; relays them to clients via corresponding events【457964279538678†L0-L15】. | Create — added evidence routes/events to forward these events. | See previous sprint | 
| 5 | np‑eblips | Receives `e-blips:updateBlips` with ped network ID, job and callsign; responds with `e-blips:addHandler` to the sender【423160286560117†L0-L8】. | Create — added blips routes/events to update client blips. | See previous sprint |
| 6 | np‑dispatch | Central dispatch: listens for `dispatch:svNotify` events with codes 10‑13A/B and others; builds recipient lists and blip data and broadcasts `dispatch:clNotify`; defines commands (`togglealerts`) and alert events【737463347219154†L0-L29】【737463347219154†L30-L111】. | Create — added dispatch routes and logic for notifications, toggles and alert handlers. | See previous sprint |
| 7 | np‑crimeschool | No server script; client‑side only. | Skip — nothing to port. | — |
| 8 | np‑commands | Defines chat command lists and job/whitelist checks; server code queries jobs and characters tables【440538558159676†L59-L77】. | Skip for now — command system requires full jobs/permissions subsystem; revisit later. | — |
| 9 | np‑ems | Client‑only; no server logic. | Skip — nothing to port. | — |
| 10 | np‑actionbar | Client hotbar UI; no server logic. | Skip — nothing to port. | — |
| 11 | np‑bennys | Handles `np-bennys:attemptPurchase` and `np-bennys:updateRepairCost`; deducts cash from players and updates repair cost【789232318723476†L0-L30】. | Create — implemented Bennys endpoints in previous sprint: purchase attempts and repair cost updates with transaction logging. | See previous sprint |
| 12 | np‑broadcaster | Registers `attemptBroadcast` event; counts active broadcasters and assigns the broadcaster job if below limit【123927081072201†L0-L12】. | Create — added `POST /v1/broadcast/attempt` endpoint that assigns the `broadcaster` job if fewer than `MAX_BROADCASTERS` players currently hold it, using `jobsRepository` helpers. | commit: added `src/routes/broadcaster.routes.js` and repository helpers |

| 13 | np‑errorlog | Registers an `error` server event that forwards error messages to a Discord webhook via HTTP【608897531749594†L0-L23】. | Skip — error logging is already handled by the unified error API in `srp‑base`, so no new backend logic is required. | — |
| 14 | LockDoors | Client script controlling door locks; no server code. | Skip — nothing to port. | — |
| 15 | np‑density | Listens for `np:peds:rogue` events and forwards them to clients to delete rogue peds【14920766739437†L0-L4】. | Skip — no persistent server state and no backend logic to port. | — |

| 16 | koilWeatherSync | Maintains the current weather and time via `kGetWeather`, `kTimeSync`, `kWeatherSync`, `weather:time`, `weather:setWeather` events and a `syncallweather` command【864410210965398†L23-L33】【864410210965398†L36-L40】. | Skip — our `world` endpoints already provide time/weather state via REST; FiveM event hooks are not needed in the external API. | — |
| 17 | mapmanager | Central resource that manages maps and gametypes using resource metadata and events like `onResourceStarting`, `onResourceStart`, `onResourceStop`【32727640578048†L6-L41】【32727640578048†L107-L167】. | Skip — purely affects internal resource loading and game type switching; not applicable to the Node API. | — |
| 18 | chat | Handles chat messages via `_chat:messageEntered`, `chat:init`, `chat:addMessage`, `chat:addTemplate`, command fallback and suggestions【147364517015620†L0-L23】【147364517015620†L41-L67】. | Skip — chat is a client-side feature with no persistence; no server endpoints required. | — |
| 19 | cron | Minimal cron scheduler that runs callbacks at specified hours and minutes using a timeout loop【438652072574188†L0-L48】. | Skip — Node.js runtime and existing scheduler libraries (e.g. cron) provide this functionality; no HTTP API required. | — |
| 20 | minimap | Contains only a client script to adjust the mini-map; no server logic. | Skip — nothing to port. | — |
| 21 | np‑admin | Provides a large set of admin and moderation functions: disconnecting players, noclip toggles, bringing players, cloaking, kicking, tracking player info, HUD debug toggles, and command execution【739259918442198†L8-L36】【739259918442198†L33-L39】. | Skip for this sprint — implementing a full admin system requires a deeper jobs/permissions integration beyond current scope; revisit in a dedicated sprint. | — |
| 22 | np‑barriers | Contains only a client script for placing barriers; no server logic. | Skip — nothing to port. | — |
| 23 | np‑base | Core framework providing blipmanager, commands, core modules, events, database, player state, inventory and other foundational logic; extremely large and integrated. | Defer — porting this will require breaking down modules and mapping them to our existing services; scheduled for future sprints. | — |
| 24 | np‑camera | Contains only a client script; no server logic to port. | Skip — nothing to port. | — |
| 25 | np‑cid | Registers a `np-cid:createID` event that generates a random identifier and triggers a client event to give an ID card【836458714788436†L0-L12】. | Skip — the ID card system would require an inventory implementation and is deferred for now. | — |
| 26 | np‑contracts | Handles contract creation and acceptance between players: on `server:contractsend` it inserts a row into contracts table and prompts the target; on `contract:accept` it checks the payer has enough cash, transfers funds and marks the contract paid【400719268596618†L10-L20】. | Create — added contracts API with endpoints to create, list, accept and decline contracts; implemented repository and migration. | this sprint |
| 27 | np‑dances | Only includes a client script implementing dance emotes; no server logic. | Skip — nothing to port. | — |
| 28 | np‑dealer | Contains only a client script for vendor UI; no server code. | Skip — nothing to port. | — |
| 29 | np‑dirtymoney | Registers events to attempt dirty money drops, modify dirty money and convert it to clean cash【414013350686833†L0-L15】. | Skip — dirty money management will be handled in a dedicated economy sprint. | — |

| 30 | np‑driftschool | Handles `np-driftschool:takemoney` event to deduct cash for drift school participation【761714451400029†L0-L11】. | Create — added `/v1/driftschool/pay` endpoint that withdraws a specified amount from a player's account using the economy repository. | this sprint |
| 31 | np‑driving‑instructor | Provides driving test submission, history lookup, report retrieval and instructor vehicle actions; persists test results to `driving_tests` table【393162189931023†L0-L45】. | Create — implemented driving test APIs (`/v1/driving-tests` POST/GET) and `/v1/driving-tests/{id}` GET; added repository and migration. | this sprint |
| 32 | np‑drugdeliveries | Manages drug deliveries and chop shop via `oxydelivery:server`, `drugdelivery:server`, `delivery:status`, and chop shop list refresh timers【896869969423342†L0-L93】. | Skip — delivery and chop shop mechanics require in-game logic and will be handled in a dedicated jobs/vehicles sprint. | — |
| 33 | np‑firedepartment | Handles saw door and particle events; registers events `Saw:SyncDoorFall`, `Saw:StartParticles`, `Saw:SyncStopParticles` and relays them to clients【349291604510523†L0-L13】. | Skip — no persistent state; client effects only. | — |
| 34 | np‑fish | Contains only client scripts; no server logic. | Skip — nothing to port. | — |
| 35 | np‑furniture | Furniture placement/decor UI; client only. | Skip — nothing to port. | — |
| 36 | np‑fx | Client visual effects; no server script. | Skip — nothing to port. | — |
| 37 | np‑gangs | Implements weed farming via events `weed:createplant`, `weed:killplant`, `weed:UpdateWeedGrowth`, `weed:requestTable`; persists to a `weed_plants` table【366444498392161†L9-L33】. | Create — added weed plants repository, routes and migration to support CRUD operations on weed plants. | this sprint |
| 38 | np‑gangweapons | Simple shop event checks player cash and sells gang weapons【403321870441425†L1-L4】. | Skip — gang weapons shop depends on inventory and job systems; deferred. | — |
| 39 | np‑golf | No server scripts; resource removed. | Skip — nothing to port. | — |
| 40 | np‑gunmeta | Contains only metadata files (no Lua). | Skip — nothing to port. | — |
| 41 | np‑gunmetaDLC | Same as `np‑gunmeta`; metadata only. | Skip — nothing to port. | — |
| 42 | np‑gunmetas | Same as above; metadata only. | Skip — nothing to port. | — |
| 43 | np‑gurgle | Provides `website:new` event to purchase websites; charges $500, inserts row into `websites` table and broadcasts list【73746484563419†L0-L48】. | Create — implemented websites API with endpoints to list and create websites, including payment and persistence. | this sprint |
| 44 | np‑gym | Contains only client scripts for gym activities. | Skip — nothing to port. | — |
| 45 | np‑heatmap | Contains only client scripts. | Skip — nothing to port. | — |
| 46 | np‑hospitalization | Updates `hospital_patients` table via events `stress:illnesslevel` and `stress:illnesslevel:new`; controls triage state via `doctor:enableTriage` and `doctor:disableTriage`【491902441918069†L0-L37】. | Defer — implementing patient management requires an EMS module; scheduled for a dedicated sprint. | — |
| 47 | np‑hunting | Contains only client scripts for hunting minigame. | Skip — nothing to port. | — |

**Legend:** *Skip* – no action taken because equivalent functionality already exists or the resource is client‑side. *Extend* – partially implemented; only missing behaviour added. *Create* – new module/endpoints created to port behaviour.
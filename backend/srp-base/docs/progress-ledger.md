# Progress Ledger – SRP‑Base Node Backend

This ledger tracks our progress porting server behaviours from the
legacy resources repository into the unified `srp‑base` Node.js
backend.  For each resource processed, we record its index (based on
alphabetical ordering in the legacy `resources` directory), a brief
summary of its server responsibilities, our decision (Skip/Extend/Create),
and a reference to the patch or commit in this repository.  Only
server‑side logic is considered; purely client resources are skipped.
| Index | Resource | Summary of Server Responsibilities | Decision | Patch Reference |
|---|---|---|---|---|
| 1 | baseevents | Handles player connecting, spawning and dropping; registers players and records spawn positions. | Already implemented in initial sprint | — |
| 2 | coordsaver | Saves, lists and deletes coordinate presets; writes to `srp_coords` table. | Already implemented in initial sprint | — |
| 3 | PolyZone | Registers, removes and lists named zones; maintains an in‑memory zone registry. | Already implemented in initial sprint | — |
| 4 | np‑evidence | Receives `evidence:pooled`, `evidence:removal` and `evidence:clear` events; relays them to clients via corresponding events【457964279538678†L0-L15】. | Create — added evidence routes/events to forward these events. Extend — documented evidence API in OpenAPI and module docs. | this sprint |
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
| 48 | np‑infinity | Broadcasts players' coordinates to clients via events; no persistent state【569396379702026†L0-L12】. | Skip — nothing to port. | — |
| 49 | np‑interior | Contains only client scripts that manage interiors【894325454073906†L0-L55】. | Skip — nothing to port. | — |
| 50 | np‑inventory | Comprehensive inventory system implemented in Lua; our inventory microservice already covers these features【108768342973504†L0-L131】. | Skip — no additional backend needed. | — |
| 51 | np‑jewelrob | Registers `jewel:hasrobbed` and `jewel:request` events; no database persistence【564860878882183†L0-L35】. | Skip — nothing to port. | — |
| 52 | np‑jobmanager | Manages job whitelisting and assignments, counting active job holders【769332134670781†L0-L43】. | Defer — job/permissions system will be handled in a dedicated sprint. | — |
| 53 | np‑keypad | Contains only client code for keypad puzzles【237659149565814†L0-L81】. | Skip — nothing to port. | — |
| 54 | np‑keys | Simple event to send keys to a player【53794332482796†L0-L3】. | Skip — in-game event only; no persistence. | — |
| 55 | np‑lockpicking | Client-only lockpicking mini-game【680002010711533†L56-L76】. | Skip — nothing to port. | — |
| 56 | np‑lootsystem | Awards random items on `loot:useItem`; no persistent state【827029519194534†L0-L66】. | Skip — will be revisited when inventory mechanics are expanded. | — |
| 57 | np‑login | Contains only a `np-login:disconnectPlayer` event that drops players【57298370178638†L0-L4】. | Skip — no backend needed. | — |
| 58 | np‑lost | Contains only a client script; no server code. | Skip — nothing to port. | — |
| 59 | np‑memorial | Contains only client logic for memorial interactions. | Skip — nothing to port. | — |
| 60 | np‑menu | UI resource with client-only menu code and configuration. | Skip — nothing to port. | — |
| 61 | np‑news | Registers `NewsStandCheckFinish` server event to relay parameters to clients【675594937447961†L0-L4】. | Skip — simple event relay with no persistence. | — |
| 62 | np‑newsJob | Registers `light:addNews` and `news:removeLight` events to broadcast light updates【361323525276692†L0-L19】. | Skip — no persistent state to port. | — |
| 63 | np‑notepad | Maintains `serverNotes` array and events to add, remove and list notes【136491508201320†L0-L19】. | Create — added notes API with endpoints to create, list and delete notes; persists notes in database. | this sprint |
| 64 | np‑oBinoculars | Contains only client script. | Skip — no server logic to port. | — |
| 65 | np‑oCam | Client‑only camera overlay; no server logic. | Skip — nothing to port. | — |
| 66 | np‑oGasStations | Client/UI for gas stations; no server script. | Skip — nothing to port. | — |
| 67 | np‑oHideFrames | Client‑side hide frames utility. | Skip — nothing to port. | — |
| 68 | np‑oPlayerNumbers | Client script to display player IDs above heads. | Skip — no backend needed. | — |
| 69 | np‑oRecoil | Client script to adjust weapon recoil. | Skip — no server component. | — |
| 70 | np‑oStress | Client script adjusting stress mechanics. | Skip — no server component. | — |
| 71 | np‑oVehicleMod | Handles `vehicleMod:changePlate`, `vehicleMod:getHarness`, `vehicleMod:applyHarness`, `vehicleMod:updateHarness` and forwards carhud events【562190696785774†L0-L90】. | Extend — added vehicle harness and plate change endpoints (`GET/PATCH /v1/vehicles/harness/{plate}`, `POST /v1/vehicles/plate-change`); harness durability stored in vehicles table and new migration added. | this sprint |
| 72 | np‑particles | Registers `particle:StartParticleAtLocation` and `particle:StopParticle` events to broadcast to all clients【867960581482973†L0-L11】. | Skip — client effects only; no persistence. | — |
| 73 | np‑prison | Contains only stream files; no server script. | Skip — nothing to port. | — |
| 74 | np‑propattach | Client utility to attach props; no server script. | Skip — nothing to port. | — |
| 75 | np‑rehab | Adds `/rehab` command that triggers a client rehab event for EMS/judge jobs【501607415487925†L0-L17】. | Skip — no persistent state; event forwarding only. | — |
| 76 | np‑restart | Schedules restart notifications via chat messages at fixed times【998733077849360†L0-L121】. | Skip — server restarts are managed externally; no API needed. | — |
| 77 | np‑robbery | Complex heist logic managing power state, doors, markers and loot. | Defer — will be tackled in a dedicated heists sprint due to scope. | — |
| 78 | np‑scoreboard | Handles AddPlayer, AddAllPlayers and RemovePlayer events for scoreboard display【201703089677931†L0-L84】. | Skip — no persistence; scoreboard is client UI. | — |
| 79 | np‑secondaryjobs | Provides `secondary:NewJobServer` and `secondary:NewJobServerWipe` events to insert/delete from `secondary_jobs` table【649885668358986†L0-L35】. | Create — added secondary jobs API with endpoints to assign and remove secondary jobs and list a player's jobs; new migration and repository added. | this sprint |
| 80 | np‑securityheists | Tracks a list of recent heist licenses to prevent duplicate robberies; no database or state beyond runtime memory. | Skip — simple event gating without persistence; no backend API required. | — |
| 81 | np‑sirens | Only client scripts controlling siren sounds. | Skip — no server logic to port. | — |
| 82 | np‑spikes | Broadcasts `addSpikes` and `removeSpikes` events to all clients【644264532347613†L0-L9】. | Skip — event relay only; no persistence. | — |
| 83 | np‑stash | Defines stash house configurations and writes state to disk【217965367344869†L0-L48】【172428215327821†L0-L8】. | Skip — uses file I/O; not ported to the database. | — |
| 84 | np‑stashhouse | Contains only stream assets; no server script. | Skip — nothing to port. | — |
| 85 | np‑stripclub | Client‑side only; no server logic. | Skip — nothing to port. | — |
| 86 | np‑stripperbitches | Client‑side only; no server logic. | Skip — nothing to port. | — |
| 87 | np‑taskbar | Progress bar UI implemented on the client. | Skip — nothing to port. | — |
| 88 | np‑taskbarskill | Skill check mini‑game implemented on the client. | Skip — nothing to port. | — |
| 89 | np‑taskbarthreat | Threat gauge mini‑game implemented on the client. | Skip — nothing to port. | — |
| 90 | np‑tasknotify | Client notifications; no server logic. | Skip — nothing to port. | — |
| 91 | np‑taximeter | Registers meter events and fares【147099589493415†L0-L17】; uses in‑game events only. | Skip — no persistence; no API needed. | — |
| 92 | np‑thermite | Forwards `thermite:StartFireAtLocation` and `thermite:StopFires` events to clients【564208794634241†L0-L10】. | Skip — effects only; no backend state. | — |
| 93 | np‑tow | Contains only metadata; no server script【296072965027253†L0-L107】. | Skip — nothing to port. | — |
| 94 | np‑tuner | Forwards modification events to clients【993976871895598†L0-L4】. | Skip — no persistence. | — |
| 95 | np‑tunershop | Includes only client code and vehicle metadata. | Skip — nothing to port. | — |
| 96 | np‑vanillaCarTweak | Contains only vehicle metadata files【731581791128896†L0-L57】. | Skip — nothing to port. | — |
| 97 | np‑voice | Sets voice convars and forwards voice state events【10705249783831†L11-L52】. | Skip — voice system is handled by FiveM; no backend API required. | — |
| 98 | np‑votesystem | Implements mayoral pay, hot spot randomisation and gang coordinates updates with complex DB interactions【121521488790210†L35-L168】. | Defer — full port requires multiple subsystems; will be addressed in a dedicated sprint. | — |
| 99 | np‑warrants | Contains only client and HTML files; no server logic. | Skip — nothing to port. | — |
| 100 | np‑weapons | Stores ammunition counts via events `np-weapons:getAmmo` and `np-weapons:updateAmmo`, persisting ammo in the characters_weapons table【735206341651753†L6-L44】. | Create — added player ammunition API with new table, repository and endpoints to get and update ammo counts. | this sprint |
| 101 | np‑webpages | Server file contains no logic; websites are handled in a separate module. | Skip — nothing to port. | — |
| 102 | np‑whitelist | Loads whitelists and job priority queues for the connection queue【360360555555541†L14-L107】. | Defer — requires integration with connection queue and job/permissions system. | — |
| 103 | np‑xhair | Client‑side crosshair overlay. | Skip — nothing to port. | — |
| 104 | nui_blocker | Detects devtools and kicks players via event and webhook【499166097351950†L0-L26】. | Skip — simple moderation event; no backend state. | — |
| 105 | outlawalert | Defines an RGB colour table; no events or persistence【895876963551968†L0-L120】. | Skip — nothing to port. | — |
| 106 | pNotify | Client notification library; no server logic. | Skip — nothing to port. | — |
| 107 | pPassword | Connection password handler with adaptive card UI. | Skip — handled by resource; no API needed. | — |
| 108 | ped | Streamed pedestrian models and metadata. | Skip — assets only. | — |
| 109 | phone | Handles tweets, contacts and calls via MySQL tables. | Create — added phone tweets API. | this sprint |
| 110 | police | Police utilities interacting with characters and jobs tables. | Skip — covered by existing police routes. | — |
| 111 | policegarage | Spawns police vehicles using events only. | Skip — nothing to port. | — |
| 112 | radio | Voice radio controls; no persistence. | Skip — nothing to port. | — |
| 113 | ragdoll | Toggles ragdoll state for players. | Skip — client effect only. | — |
| 114 | raid_carmenu | Vehicle menu UI. | Skip — client-only. | — |
| 115 | raid_cars | Vehicle asset definitions. | Skip — assets only. | — |
| 116 | raid_clothes | Clothing asset definitions. | Skip — assets only. | — |
| 117 | rconlog | Logs RCON commands to file. | Skip — handled externally. | — |
| 118 | runcode | Admin utility to execute code. | Skip — out of scope. | — |
| 119 | sessionmanager | Manages player sessions internally. | Skip — FiveM core feature. | — |
| 120 | shops | Shop configuration and events. | Skip — existing shops API covers this. | — |
| 121 | spawnmanager | Core spawn logic for FiveM. | Skip — engine feature. | — |
| 122 | stereo | Client boombox audio. | Skip — nothing to port. | — |
| 123 | storage | Client inventory storage; no server script. | Skip — nothing to port. | — |
| 124 | tf-pointing | Client pointing emote. | Skip — nothing to port. | — |
| 125 | towtruckjob | Tow job payouts and vehicle spawning; updates delivery_job table. | Defer — requires jobs subsystem. | — |
| 126 | trains | Simple train request event. | Skip — event relay only. | — |
| 127 | truckerjob | Delivery jobs using `delivery_job` table. | Defer — needs jobs subsystem. | — |
| 128 | uitest | UI testing resource. | Skip — nothing to port. | — |
| 129 | veh | Vehicle condition queries on `characters_cars` table. | Skip — existing vehicles API covers condition. | — |
| 130 | veh_shop | Vehicle dealership and financing. | Defer — complex feature for future sprint. | — |
| 131 | veh_shop_imports | Import dealership logic. | Defer — part of vehicle shop system. | — |
| 132 | warmenu | Menu library; client-only. | Skip — nothing to port. | — |
| 133 | webpack | Build tool configuration. | Skip — not gameplay code. | — |
| 134 | wk_wrs | Radar UI client scripts. | Skip — nothing to port. | — |
| 135 | yarn | Packaging utility for development. | Skip — not a runtime resource. | — |
| 136 | openapi-spec | Fixed missing path parameter for `/v1/characters/{id}` and added 4xx responses & operationIds to phone tweets. | Extend | openapi/api.yaml |
| 137 | np-admin (ban endpoint) | Adds ban API persisting player bans with reason and optional expiry. | Create — implemented admin ban repository, route and migration. | this sprint |
| 138 | openapi-spec (evidence) | Added schemas for evidence items to satisfy specification references. | Extend | openapi/api.yaml |

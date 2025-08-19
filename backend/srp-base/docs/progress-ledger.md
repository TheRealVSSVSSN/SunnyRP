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

**Legend:** *Skip* – no action taken because equivalent functionality already exists or the resource is client‑side. *Extend* – partially implemented; only missing behaviour added. *Create* – new module/endpoints created to port behaviour.
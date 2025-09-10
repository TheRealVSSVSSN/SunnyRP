# fsn_boatshop Documentation

## Overview
Provides a lightweight boat showroom at the Los Santos Marina. Players can purchase or rent boats while employees may adjust stock and pricing via chat commands.

## File Summary
- **fxmanifest.lua** – Resource manifest targeting the `cerulean` build and Lua 5.4.
- **config.lua** – Shared configuration defining showroom slots and boat catalogue.
- **cl_boatshop.lua** – Client logic for spawning showroom boats, handling purchases, rentals and rental returns.
- **sv_boatshop.lua** – Server logic maintaining showroom state and processing employee commands.

## Commands
| Command | Description |
|---------|-------------|
| `/comm <0-30>` | Set commission percentage for the nearest showroom slot. |
| `/color1 <0-159>` | Change the primary color of the nearest showroom boat. |
| `/color2 <0-159>` | Change the secondary color of the nearest showroom boat. |
| `/setboat <slot> <model>` | Replace the boat at a specific slot with a model from the catalogue. |

## Events
| Event | Direction | Purpose |
|-------|-----------|---------|
| `fsn_boatshop:floor:Request` | Client → Server | Request current showroom state. |
| `fsn_boatshop:floor:Update` | Server → Client | Send full showroom state. |
| `fsn_boatshop:floor:Updateboat` | Server → Client | Update a single showroom slot. |
| `fsn_boatshop:floor:commission` | Client ↔ Server | Update commission percentage. |
| `fsn_boatshop:floor:color:One` | Client ↔ Server | Update primary color. |
| `fsn_boatshop:floor:color:Two` | Client ↔ Server | Update secondary color. |
| `fsn_boatshop:floor:ChangeBoat` | Client → Server | Replace boat model at a slot. |

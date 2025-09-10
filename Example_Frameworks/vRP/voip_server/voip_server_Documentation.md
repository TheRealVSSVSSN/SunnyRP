# voip_server Documentation

## Overview
Node.js service that relays voice packets between players using WebSocket signalling and WebRTC data channels.

## Table of Contents
- [config.js](#configjs)
- [main.js](#mainjs)

## config.js
- Exports immutable configuration for network ports and optional STUN servers.
- `ports.websocket` specifies the TCP port for WebSocket signalling.
- `ports.webrtc_range` defines the UDP port range allocated per WebRTC connection.
- `iceServers` lists external STUN servers to assist IP discovery when needed.

## main.js
- Launches a WebSocket server and tracks players in a `Map` keyed by identifier.
- For each connection:
  - Creates an `RTCPeerConnection` with the configured port range and STUN settings.
  - Negotiates a reliable data channel to ferry encoded voice packets.
  - Processes identification, connect, and disconnect messages to manage channel membership.
  - Relays incoming packets to peers sharing at least one active channel.
  - Removes channel references for all peers when a player disconnects to avoid stale links.
- Employs modern ES6 syntax (`const`/`let`, arrow functions) and centralized error handling.

## Conclusion
The `voip_server` resource offers a lightweight voice relay that integrates with vRP's audio module, providing performant and clean peer communication.

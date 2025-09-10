"use strict";

const cfg = require("./config.js");

const WebSocket = require("ws");
const wrtc = require("wrtc");

// create websocket server
const wss = new WebSocket.Server({ port: cfg.ports.websocket });
const players = new Map(); // map of id => {ws, peer, dchannel, channels}

// return true if player 1 and player 2 are connected by at least one channel
const checkConnected = (p1, p2, channels) => {
  for (const channelId of channels) {
    if (p1.channels[channelId] && p2.channels[channelId] && p1.channels[channelId][p2.id] && p2.channels[channelId][p1.id]) {
      return true;
    }
  }
  return false;
};

const errorHandler = e => {
  console.log("error", e);
};

console.log("Server started.");
console.log("config = ", cfg);

wss.on("connection", (ws, req) => {
  console.log("connection from " + req.socket.remoteAddress);

  // create peer
  const peer = new wrtc.RTCPeerConnection({ iceServers: cfg.iceServers, portRange: { min: cfg.ports.webrtc_range[0], max: cfg.ports.webrtc_range[1] } });

  peer.onicecandidate = e => {
    try {
      ws.send(JSON.stringify({ act: "candidate", data: e.candidate }));
    } catch (err) { errorHandler(err); }
  };

  // create channel
  const dchannel = peer.createDataChannel("voip", {
    ordered: false,
    negotiated: true,
    maxRetransmits: 0,
    id: 0
  });

  dchannel.binaryType = "arraybuffer";

  dchannel.onopen = () => {
    console.log("UDP channel ready for " + req.socket.remoteAddress);
  };

  dchannel.onmessage = e => {
    const player = ws.player;
    const buffer = e.data;

    if (player) { // identified
      // read packet
      // header
      const view = new DataView(buffer);
      const nchannels = view.getUint8(0);
      const channels = new Uint8Array(buffer, 1, nchannels);

      // build out packet
      const outData = new Uint8Array(4 + buffer.byteLength);
      const outView = new DataView(outData.buffer);
      outView.setInt32(0, player.id); // write player id
      outData.set(new Uint8Array(buffer), 4); // write packet data

      // send to channel connected players
      for (const [, outPlayer] of players) {
        if (outPlayer.dchannel.readyState === "open" && checkConnected(player, outPlayer, channels)) {
          try {
            outPlayer.dchannel.send(outData.buffer);
          } catch (err) { errorHandler(err); }
        }
      }
    }
  };

  ws.on("message", data => {
    data = JSON.parse(data);

    if (data.act === "answer")
      peer.setRemoteDescription(data.data).catch(errorHandler);
    else if (data.act === "candidate" && data.data != null)
      peer.addIceCandidate(data.data).catch(errorHandler);
    else if (data.act === "identification" && data.id != null) {
      if (!players.has(data.id)) {
        const player = { ws: ws, peer: peer, dchannel: dchannel, id: data.id, channels: {} };
        players.set(data.id, player);
        ws.player = player;
        console.log("identification for " + req.socket.remoteAddress + " player id " + data.id);
      }
    }
    else if (data.act === "connect" && data.channel != null && data.player != null) {
      const player = ws.player;
      if (player) {
        let channel = player.channels[data.channel];
        if (!channel) { // create channel
          channel = {};
          player.channels[data.channel] = channel;
        }

        channel[data.player] = true;
      }
    }
    else if (data.act === "disconnect" && data.channel != null && data.player != null) {
      const player = ws.player;
      if (player) {
        const channel = player.channels[data.channel];
        if (channel) {
          delete channel[data.player]; // remove player

          if (Object.keys(channel).length === 0) // empty, remove channel
            delete player.channels[data.channel];
        }
      }
    }
  });

  ws.on("close", () => {
    peer.close();
    const player = ws.player;
    if (player) {
      players.delete(player.id);
      for (const [, other] of players) {
        for (const channelId of Object.keys(other.channels)) {
          const channel = other.channels[channelId];
          if (channel[player.id]) {
            delete channel[player.id];
            if (Object.keys(channel).length === 0) {
              delete other.channels[channelId];
            }
          }
        }
      }
    }
    console.log("disconnection of " + req.socket.remoteAddress);
  });

  peer.createOffer().then(offer => {
    peer.setLocalDescription(offer).catch(errorHandler);
    try {
      ws.send(JSON.stringify({ act: "offer", data: offer }));
    } catch (err) { errorHandler(err); }
  }).catch(errorHandler);
});

const protobuf = require("@citizenfx/protobufjs");

const MAX_SLOTS = 32;
const players = new Map();
let slotsUsed = 0;

/**
 * Assign the first free slot index.
 * @returns {number} slot index or -1 if none available
 */
function assignSlotId() {
  for (let i = 0; i < MAX_SLOTS; i++) {
    const mask = 1 << i;
    if ((slotsUsed & mask) === 0) {
      slotsUsed |= mask;
      return i;
    }
  }

  return -1;
}

/**
 * Release a previously assigned slot.
 * @param {number} slot
 */
function releaseSlot(slot) {
  if (slot >= 0 && slot < MAX_SLOTS) {
    slotsUsed &= ~(1 << slot);
  }
}

let hostIndex = -1;
const isOneSync = GetConvar("onesync", "off") !== "off";

protobuf.load(`${GetResourcePath(GetCurrentResourceName())}/rline.proto`, (err, root) => {
  if (err) {
    console.log(err);
    return;
  }

  const RpcMessage = root.lookupType("rline.RpcMessage");
  const RpcResponseMessage = root.lookupType("rline.RpcResponseMessage");
  const InitSessionResponse = root.lookupType("rline.InitSessionResponse");
  const InitPlayer2_Parameters = root.lookupType("rline.InitPlayer2_Parameters");
  const InitPlayerResult = root.lookupType("rline.InitPlayerResult");
  const GetRestrictionsResult = root.lookupType("rline.GetRestrictionsResult");
  const QueueForSession_Seamless_Parameters = root.lookupType("rline.QueueForSession_Seamless_Parameters");
  const QueueForSessionResult = root.lookupType("rline.QueueForSessionResult");
  const QueueEntered_Parameters = root.lookupType("rline.QueueEntered_Parameters");
  const TransitionReady_PlayerQueue_Parameters = root.lookupType("rline.TransitionReady_PlayerQueue_Parameters");
  const TransitionToSession_Parameters = root.lookupType("rline.TransitionToSession_Parameters");
  const TransitionToSessionResult = root.lookupType("rline.TransitionToSessionResult");
  const scmds_Parameters = root.lookupType("rline.scmds_Parameters");

  const toArrayBuffer = (buf) => buf.buffer.slice(buf.byteOffset, buf.byteOffset + buf.byteLength);

  const emitMsg = (target, data) => {
    emitNet("__cfx_internal:pbRlScSession", target, toArrayBuffer(data));
  };

  const emitSessionCmds = (target, cmd, cmdname, msg) => {
    emitMsg(
      target,
      RpcMessage.encode({
        Header: {
          MethodName: "scmds",
        },
        Content: scmds_Parameters.encode({
          sid: {
            value: {
              a: 2,
              b: 2,
            },
          },
          ncmds: 1,
          cmds: [
            {
              cmd,
              cmdname,
              [cmdname]: msg,
            },
          ],
        }).finish(),
      }).finish()
    );
  };

  const emitAddPlayer = (target, msg) => emitSessionCmds(target, 2, "AddPlayer", msg);
  const emitRemovePlayer = (target, msg) => emitSessionCmds(target, 3, "RemovePlayer", msg);
  const emitHostChanged = (target, msg) => emitSessionCmds(target, 5, "HostChanged", msg);

  onNet("playerDropped", () => {
    if (isOneSync) {
      return;
    }

    try {
      const src = source;
      const oData = players.get(src);
      players.delete(src);

      if (oData && hostIndex === oData.slot) {
        const remaining = Array.from(players.values()).filter((p) => p.slot > -1);
        hostIndex = remaining.length > 0 ? remaining[0].slot | 0 : -1;

        for (const [id] of players) {
          emitHostChanged(id, {
            index: hostIndex,
          });
        }
      }

      if (!oData) {
        return;
      }

      releaseSlot(oData.slot);

      for (const [id] of players) {
        emitRemovePlayer(id, {
          id: oData.id,
        });
      }
    } catch (e) {
      console.log(e);
      console.log(e.stack);
    }
  });

  const makeResponse = (type, data) => ({
    Header: {},
    Container: {
      Content: type.encode(data).finish(),
    },
  });

  const handlers = {
    async InitSession() {
      return makeResponse(InitSessionResponse, {
        sesid: Buffer.alloc(16),
      });
    },

    async InitPlayer2(source, data) {
      const req = InitPlayer2_Parameters.decode(data);

      if (!isOneSync) {
        players.set(source, {
          gh: req.gh,
          peerAddress: req.peerAddress,
          discriminator: req.discriminator,
          slot: -1,
        });
      }

      return makeResponse(InitPlayerResult, { code: 0 });
    },

    async GetRestrictions() {
      return makeResponse(GetRestrictionsResult, { data: {} });
    },

    async ConfirmSessionEntered() {
      return {};
    },

    async TransitionToSession(source, data) {
      TransitionToSession_Parameters.decode(data);

      return makeResponse(TransitionToSessionResult, {
        code: 1, // in this message, 1 is success
      });
    },

    async QueueForSession_Seamless(source, data) {
      const req = QueueForSession_Seamless_Parameters.decode(data);

      if (!isOneSync) {
        const pdata = players.get(source);
        if (pdata) {
          pdata.req = req.requestId;
          pdata.id = req.requestId.requestor;
          pdata.slot = assignSlotId();
        }
      }

      setTimeout(() => {
        emitMsg(
          source,
          RpcMessage.encode({
            Header: {
              MethodName: "QueueEntered",
            },
            Content: QueueEntered_Parameters.encode({
              queueGroup: 69,
              requestId: req.requestId,
              optionFlags: req.optionFlags,
            }).finish(),
          }).finish()
        );

        if (isOneSync) {
          hostIndex = 16;
        } else if (hostIndex === -1) {
          hostIndex = players.get(source).slot | 0;
        }

        emitMsg(
          source,
          RpcMessage.encode({
            Header: {
              MethodName: "TransitionReady_PlayerQueue",
            },
            Content: TransitionReady_PlayerQueue_Parameters.encode({
              serverUri: {
                url: "",
              },
              requestId: req.requestId,
              id: {
                value: {
                  a: 2,
                  b: 0,
                },
              },
              serverSandbox: 0xD656C677,
              sessionType: 3,
              transferId: {
                value: {
                  a: 2,
                  b: 2,
                },
              },
            }).finish(),
          }).finish()
        );

        setTimeout(() => {
          const pdata = players.get(source);

          emitSessionCmds(source, 0, "EnterSession", {
            index: isOneSync ? 16 : pdata.slot | 0,
            hindex: hostIndex,
            sessionFlags: 0,
            mode: 0,
            size: isOneSync
              ? 0
              : Array.from(players.values()).filter((p) => p.id).length,
            teamIndex: 0,
            transitionId: {
              value: {
                a: 2,
                b: 0,
              },
            },
            sessionManagerType: 0,
            slotCount: MAX_SLOTS,
          });
        }, 50);

        if (!isOneSync) {
          setTimeout(() => {
            const meData = players.get(source);

            const aboutMe = {
              id: meData.id,
              gh: meData.gh,
              addr: meData.peerAddress,
              index: meData.slot | 0,
            };

            for (const [id, data] of players) {
              if (id === source || !data.id) continue;

              emitAddPlayer(source, {
                id: data.id,
                gh: data.gh,
                addr: data.peerAddress,
                index: data.slot | 0,
              });

              emitAddPlayer(id, aboutMe);
            }
          }, 150);
        }
      }, 250);

      return makeResponse(QueueForSessionResult, { code: 1 });
    },
  };

  const handleMessage = async (source, method, data) => {
    if (handlers[method]) {
      return handlers[method](source, data);
    }

    return {};
  };

  onNet("__cfx_internal:pbRlScSession", async (data) => {
    const s = source;

    try {
      const message = RpcMessage.decode(new Uint8Array(data));
      const response = await handleMessage(s, message.Header.MethodName, message.Content);

      if (!response || !response.Header) {
        return;
      }

      response.Header.RequestId = message.Header.RequestId;

      emitMsg(s, RpcResponseMessage.encode(response).finish());
    } catch (e) {
      console.log(e);
      console.log(e.stack);
    }
  });
});


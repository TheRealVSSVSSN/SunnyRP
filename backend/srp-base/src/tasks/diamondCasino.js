const repo = require('../repositories/diamondCasinoRepository');
const dispatcher = require('../hooks/dispatcher');

async function resolvePending(wss) {
  const cutoff = Date.now() - 30000;
  const games = await repo.listPendingGames(cutoff);
  for (const game of games) {
    const result = { outcome: 'resolved' };
    await repo.resolveGame(game.id, result);
    if (wss) {
      wss.broadcast('casino', 'gameResolved', { gameId: game.id, result });
    }
    dispatcher.dispatch('casino.gameResolved', { gameId: game.id, result });
  }
}

module.exports = { resolvePending };

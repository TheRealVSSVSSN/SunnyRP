const os = require('os');

/**
 * Gather basic server diagnostics for debugging purposes.
 * @returns {Promise<{uptime:number,memory:number,timestamp:string,loadavg:number[]}>>}
 */
async function getSystemInfo() {
  return {
    uptime: process.uptime(),
    memory: process.memoryUsage().rss,
    timestamp: new Date().toISOString(),
    loadavg: os.loadavg(),
  };
}

module.exports = {
  getSystemInfo,
};

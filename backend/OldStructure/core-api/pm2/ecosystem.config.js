/**
 * SunnyRP Core API — PM2 ecosystem
 * Runs: API (cluster) + Webhooks retry worker (fork)
 * Logs go to repo-root /logs to keep them outside the backend folder.
 */
module.exports = {
  apps: [
    {
      name: 'sunny-core-api',
      cwd: './',                           // backend/core-api
      script: 'src/server.js',
      exec_mode: 'cluster',
      instances: 'max',                    // use all CPU cores
      watch: false,
      autorestart: true,
      max_memory_restart: '512M',
      // graceful-ish settings
      listen_timeout: 8000,
      kill_timeout: 5000,
      // helpful backoff if it crashes repeatedly
      exp_backoff_restart_delay: 200,
      // Add PM2 timestamps in logs
      time: true,
      merge_logs: true,
      out_file: '../../logs/core-api-out.log',
      error_file: '../../logs/core-api-err.log',
      env: {
        NODE_ENV: 'production',
        PORT: process.env.PORT || 3100,
        // GAME_API_TOKEN should be set in your environment or .env (loaded by your app)
        // MYSQL_* vars are read by knexfile/env loader you already have
      },
      env_development: {
        NODE_ENV: 'development',
      },
    },
    {
      name: 'sunny-webhooks-worker',
      cwd: './',                           // backend/core-api
      script: 'src/workers/webhooks.worker.js',
      exec_mode: 'fork',                   // single worker is fine; queue is small
      instances: 1,
      watch: false,
      autorestart: true,
      max_memory_restart: '256M',
      exp_backoff_restart_delay: 200,
      time: true,
      merge_logs: true,
      out_file: '../../logs/webhooks-out.log',
      error_file: '../../logs/webhooks-err.log',
      env: {
        NODE_ENV: 'production',
      },
      env_development: {
        NODE_ENV: 'development',
      },
    },
  ],
};
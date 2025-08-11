module.exports = {
    apps: [
        {
            name: 'sunny-core-api',
            script: './src/server.js',
            exec_mode: 'cluster',
            instances: 'max',                 // one per CPU (auto)
            node_args: '--max-old-space-size=512',
            env: { NODE_ENV: 'production' },

            // resilience
            kill_timeout: 5000,
            listen_timeout: 8000,
            exp_backoff_restart_delay: 200,
            autorestart: true,
            watch: false,
            max_memory_restart: '512M',

            // logs
            time: true,
            merge_logs: true,
            log_date_format: 'MM-DD-YYYY HH:mm:ss',
            out_file: './logs/core-api.out.log',
            error_file: './logs/core-api.err.log'
        },

        // Dedicated outbox worker (single instance)
        {
            name: 'sunny-outbox-worker',
            script: './src/workers/outbox.worker.js',
            exec_mode: 'fork',
            instances: 1,
            env: { NODE_ENV: 'production' },

            kill_timeout: 5000,
            autorestart: true,
            watch: false,
            max_memory_restart: '256M',

            time: true,
            merge_logs: true,
            log_date_format: 'MM-DD-YYYY HH:mm:ss',
            out_file: './logs/outbox.out.log',
            error_file: './logs/outbox.err.log'
        }
    ]
};
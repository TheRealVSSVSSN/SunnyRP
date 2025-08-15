module.exports = {
    apps: [
        {
            name: 'srp-base',
            script: 'src/server.js',
            cwd: __dirname + '/..',
            instances: 1,
            exec_mode: 'fork',
            watch: false,
            env: {
                NODE_ENV: 'production'
            }
        },
        {
            name: 'srp-base-worker',
            script: 'src/workers/outbox.worker.js',
            cwd: __dirname + '/..',
            instances: 1,
            exec_mode: 'fork',
            watch: false,
            env: {
                NODE_ENV: 'production'
            }
        }
    ]
};
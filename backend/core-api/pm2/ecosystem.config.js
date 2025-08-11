module.exports = {
    apps: [{
        name: "sunny-core-api",
        script: "src/server.js",
        instances: "max",
        exec_mode: "cluster",
        env: {
            NODE_ENV: "production"
        },
        kill_timeout: 5000,
        time: true,
        max_memory_restart: "512M",
        out_file: "logs/out.log",
        error_file: "logs/error.log",
        merge_logs: true
    }]
}
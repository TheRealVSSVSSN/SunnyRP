import { config } from './src/config/index.js';
export default {
    client: 'mysql2',
    connection: {
        host: config.db.host,
        port: config.db.port,
        user: config.db.user,
        password: config.db.password,
        database: config.db.name
    },
    migrations: {
        directory: './migrations',
        tableName: 'knex_migrations'
    }
};
export async function up(knex) {
    // users (supersedes Phase A 'players' naming for new features)
    await knex.schema.createTable('users', (t) => {
        t.increments('id').primary();
        t.string('primary_identifier', 128).notNullable().index();
        t.string('last_ip', 64).nullable();
        t.datetime('first_seen_at').notNullable().defaultTo(knex.fn.now());
        t.datetime('last_seen_at').notNullable().defaultTo(knex.fn.now());
        t.timestamps(true, true);
    });

    await knex.schema.createTable('user_identifiers', (t) => {
        t.increments('id').primary();
        t.integer('user_id').unsigned().notNullable().references('id').inTable('users').onDelete('CASCADE');
        t.enum('type', ['license', 'steam', 'discord', 'fivem', 'xbl', 'live', 'ip']).notNullable().index();
        t.string('value', 128).notNullable().index();
        t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
        t.unique(['type', 'value']);
    });

    // roles & scopes
    await knex.schema.createTable('roles', (t) => {
        t.increments('id').primary();
        t.string('name', 64).notNullable().unique();
        t.string('description', 255).nullable();
        t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
    });

    await knex.schema.createTable('role_scopes', (t) => {
        t.increments('id').primary();
        t.integer('role_id').unsigned().notNullable().references('id').inTable('roles').onDelete('CASCADE');
        t.string('scope', 128).notNullable().index();
        t.unique(['role_id', 'scope']);
    });

    await knex.schema.createTable('user_roles', (t) => {
        t.increments('id').primary();
        t.integer('user_id').unsigned().notNullable().references('id').inTable('users').onDelete('CASCADE');
        t.integer('role_id').unsigned().notNullable().references('id').inTable('roles').onDelete('CASCADE');
        t.unique(['user_id', 'role_id']);
    });

    // overrides (per-user allow/deny)
    await knex.schema.createTable('overrides', (t) => {
        t.increments('id').primary();
        t.integer('user_id').unsigned().notNullable().references('id').inTable('users').onDelete('CASCADE');
        t.string('scope', 128).notNullable();
        t.boolean('allow').notNullable().defaultTo(true); // false => explicit deny
        t.unique(['user_id', 'scope']);
    });

    // bans
    await knex.schema.createTable('bans', (t) => {
        t.increments('id').primary();
        t.integer('user_id').unsigned().notNullable().references('id').inTable('users').onDelete('CASCADE');
        t.string('reason', 255).notNullable();
        t.datetime('expires_at').nullable(); // null => permanent
        t.integer('actor_id').unsigned().nullable(); // admin
        t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
        t.index(['user_id']);
    });

    // audit log (system/admin actions)
    await knex.schema.createTable('audit', (t) => {
        t.increments('id').primary();
        t.datetime('ts').notNullable().defaultTo(knex.fn.now());
        t.enum('actor_type', ['system', 'player', 'admin']).notNullable().defaultTo('system');
        t.integer('actor_id').nullable();
        t.string('action', 64).notNullable();
        t.integer('user_id').nullable();
        t.json('meta').nullable();
        t.index(['user_id', 'action']);
    });

    // seed base roles/scopes
    const adminId = await knex('roles').insert({ name: 'admin', description: 'Full admin' }).returning('id');
    const modId = await knex('roles').insert({ name: 'moderator', description: 'Moderation staff' }).returning('id');
    const adminRoleId = Array.isArray(adminId) ? (adminId[0].id || adminId[0]) : adminId;
    const modRoleId = Array.isArray(modId) ? (modId[0].id || modId[0]) : modId;

    await knex('role_scopes').insert([
        { role_id: adminRoleId, scope: 'srp.*' },
        { role_id: modRoleId, scope: 'srp.moderation.*' },
        { role_id: modRoleId, scope: 'srp.admin.kick' },
        { role_id: adminRoleId, scope: 'srp.admin.ban' },
        { role_id: adminRoleId, scope: 'srp.permissions.grant' },
    ]);
}

export async function down(knex) {
    await knex.schema.dropTableIfExists('audit');
    await knex.schema.dropTableIfExists('bans');
    await knex.schema.dropTableIfExists('overrides');
    await knex.schema.dropTableIfExists('user_roles');
    await knex.schema.dropTableIfExists('role_scopes');
    await knex.schema.dropTableIfExists('roles');
    await knex.schema.dropTableIfExists('user_identifiers');
    await knex.schema.dropTableIfExists('users');
}
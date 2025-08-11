export async function up(knex) {
    const hasVehicles = await knex.schema.hasTable('vehicles');
    if (!hasVehicles) {
        await knex.schema.createTable('vehicles', (t) => {
            t.increments('id').primary();
            t.integer('owner_char_id').notNullable().index();
            t.string('vin', 64).notNullable().unique();
            t.string('plate', 16).notNullable().unique();
            t.string('model', 64).notNullable();          // e.g. "sultan", model name or hash string
            t.string('display_name', 64).nullable();
            t.string('state', 16).notNullable().defaultTo('stored'); // stored|world|impounded|destroyed|junked
            t.string('garage_id', 64).nullable();
            t.json('mods').nullable();                    // colors, extras, tuning
            t.json('condition').nullable();               // engine, body, fuel, dirt, tires/doors/windows
            t.json('last_position').nullable();           // {x,y,z,heading,bucket}
            t.boolean('active').notNullable().defaultTo(false); // currently spawned in world
            t.string('active_entity', 64).nullable();     // server-side tracking token
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
            t.datetime('updated_at').notNullable().defaultTo(knex.fn.now());
            t.index(['owner_char_id']);
            t.index(['state']);
        });
    }

    const hasKeys = await knex.schema.hasTable('vehicle_keys');
    if (!hasKeys) {
        await knex.schema.createTable('vehicle_keys', (t) => {
            t.increments('id').primary();
            t.integer('vehicle_id').notNullable().index();
            t.integer('char_id').notNullable().index();
            t.integer('granted_by').nullable();
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
            t.unique(['vehicle_id', 'char_id']);
        });
    }

    const hasImp = await knex.schema.hasTable('impounds');
    if (!hasImp) {
        await knex.schema.createTable('impounds', (t) => {
            t.increments('id').primary();
            t.integer('vehicle_id').notNullable().index();
            t.string('yard_id', 64).notNullable();
            t.string('reason', 128).nullable();
            t.float('fee').notNullable().defaultTo(0);
            t.boolean('released').notNullable().defaultTo(false);
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
            t.datetime('released_at').nullable();
        });
    }
}

export async function down(knex) {
    await knex.schema.dropTableIfExists('impounds');
    await knex.schema.dropTableIfExists('vehicle_keys');
    await knex.schema.dropTableIfExists('vehicles');
}
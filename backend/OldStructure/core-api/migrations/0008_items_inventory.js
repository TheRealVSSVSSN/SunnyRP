export async function up(knex) {
    const hasItems = await knex.schema.hasTable('items');
    if (!hasItems) {
        await knex.schema.createTable('items', (t) => {
            t.increments('id').primary();
            t.string('key', 64).notNullable().unique();    // e.g., water, bread, WEAPON_PISTOL
            t.string('label', 96).notNullable();
            t.string('type', 24).notNullable().defaultTo('generic'); // generic|consumable|weapon|key|component
            t.boolean('stackable').notNullable().defaultTo(true);
            t.integer('max_stack').nullable();
            t.float('weight').notNullable().defaultTo(0);
            t.json('meta_schema').nullable();
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
        });
    }

    const hasInv = await knex.schema.hasTable('inventory');
    if (!hasInv) {
        await knex.schema.createTable('inventory', (t) => {
            t.increments('id').primary();
            t.string('container_type', 32).notNullable();  // char|vehicle_glovebox|vehicle_trunk|vehicle_floor|stash|property_closet|property_drawer|safe|ground
            t.string('container_id', 96).notNullable();    // e.g., charId, plate/VIN, stashId, propertyId, dropId
            t.integer('slot').notNullable().defaultTo(0);  // 0 means no slot (free), >0 for hotbar/grid
            t.string('item_key', 64).notNullable().index();
            t.integer('quantity').notNullable().defaultTo(1);
            t.json('metadata').nullable();                 // e.g., weapon serial, ammo, quality
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
            t.datetime('updated_at').notNullable().defaultTo(knex.fn.now());
            t.unique(['container_type', 'container_id', 'slot']); // one stack per slot
            t.index(['container_type', 'container_id']);
            t.foreign('item_key').references('items.key').onDelete('CASCADE');
        });
    }

    // Minimal idempotency key log (generic). This keeps writes exactly-once.
    const hasIdem = await knex.schema.hasTable('idempotency_keys');
    if (!hasIdem) {
        await knex.schema.createTable('idempotency_keys', (t) => {
            t.string('id', 128).primary(); // X-Idempotency-Key
            t.string('scope', 64).notNullable(); // 'inventory:add' | 'inventory:remove'
            t.json('request_hash').notNullable();
            t.json('response_cache').nullable();
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
        });
    }

    // Seed a couple items
    await knex('items').insert([
        { key: 'water', label: 'Water Bottle', type: 'consumable', stackable: true, max_stack: 10, weight: 0.5 },
        { key: 'bread', label: 'Bread', type: 'consumable', stackable: true, max_stack: 10, weight: 0.5 },
        { key: 'WEAPON_PISTOL', label: 'Pistol', type: 'weapon', stackable: false, max_stack: 1, weight: 2.0, meta_schema: JSON.stringify({ ammo: 'number', serial: 'string' }) },
    ]).onConflict('key').ignore();
}

export async function down(knex) {
    await knex.schema.dropTableIfExists('idempotency_keys');
    await knex.schema.dropTableIfExists('inventory');
    await knex.schema.dropTableIfExists('items');
}
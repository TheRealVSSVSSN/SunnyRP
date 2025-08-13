export async function up(knex) {
    if (!(await knex.schema.hasTable('interiors'))) {
        await knex.schema.createTable('interiors', (t) => {
            t.increments('id').primary();
            t.string('code', 32).notNullable().unique();    // apt_small, house_l, etc.
            t.string('label', 64).notNullable();
            t.json('entry_offset').notNullable().defaultTo(JSON.stringify({ x: 0, y: 0, z: 0, h: 0 }));
            t.json('exit_coords').notNullable();            // world coords inside shell
            t.json('stash_coords').nullable();              // inside coords for stash marker
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
        });
        // seed a single interior for Phase M DoD
        await knex('interiors').insert({
            code: 'apt_small',
            label: 'Small Apartment',
            entry_offset: JSON.stringify({ x: 0.0, y: 0.0, z: 0.0, h: 0.0 }),
            exit_coords: JSON.stringify({ x: 346.62, y: -1012.52, z: -99.2, h: 0.0 }),
            stash_coords: JSON.stringify({ x: 352.90, y: -999.00, z: -99.2 })
        });
    }

    if (!(await knex.schema.hasTable('properties'))) {
        await knex.schema.createTable('properties', (t) => {
            t.increments('id').primary();
            t.string('slug', 64).notNullable().unique();    // e.g., srp_apt_001
            t.integer('interior_id').notNullable().references('id').inTable('interiors');
            t.json('world_entry').notNullable();            // {x,y,z,h} exterior door
            t.bigInteger('price_cents').notNullable().defaultTo(0);
            t.bigInteger('rent_cents').notNullable().defaultTo(0);
            t.boolean('for_sale').notNullable().defaultTo(true);
            t.boolean('for_rent').notNullable().defaultTo(false);
            t.integer('owner_char_id').nullable().index();
            t.boolean('locked').notNullable().defaultTo(true);
            t.string('stash_key', 96).nullable().unique();  // link to inventory container key
            t.json('metadata').nullable();
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
            t.datetime('updated_at').notNullable().defaultTo(knex.fn.now());
        });
    }

    if (!(await knex.schema.hasTable('property_access'))) {
        await knex.schema.createTable('property_access', (t) => {
            t.increments('id').primary();
            t.integer('property_id').notNullable().references('id').inTable('properties').onDelete('CASCADE');
            t.integer('char_id').notNullable().index();
            t.string('access_type', 16).notNullable().defaultTo('key'); // owner|co|key|rent
            t.datetime('expires_at').nullable();
            t.unique(['property_id', 'char_id']);
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
        });
    }

    if (!(await knex.schema.hasTable('leases'))) {
        await knex.schema.createTable('leases', (t) => {
            t.increments('id').primary();
            t.integer('property_id').notNullable().references('id').inTable('properties').onDelete('CASCADE');
            t.integer('char_id').notNullable().index();
            t.bigInteger('rent_cents').notNullable().defaultTo(0);
            t.string('period', 16).notNullable().defaultTo('weekly');
            t.datetime('next_due_at').notNullable().defaultTo(knex.fn.now());
            t.boolean('active').notNullable().defaultTo(true);
            t.unique(['property_id', 'char_id']);
        });
    }
}

export async function down(knex) {
    await knex.schema.dropTableIfExists('leases');
    await knex.schema.dropTableIfExists('property_access');
    await knex.schema.dropTableIfExists('properties');
    await knex.schema.dropTableIfExists('interiors');
}
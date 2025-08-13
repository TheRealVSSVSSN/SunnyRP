export async function up(knex) {
    if (!(await knex.schema.hasTable('phones'))) {
        await knex.schema.createTable('phones', (t) => {
            t.increments('id').primary();
            t.integer('char_id').notNullable().index();
            t.string('number', 16).notNullable().unique();     // E164-lite digits only: 10 digits
            t.string('area', 8).notNullable();
            t.string('imei', 32).nullable().unique();
            t.boolean('active').notNullable().defaultTo(true);
            t.boolean('locked').notNullable().defaultTo(false);
            t.string('pin_hash', 96).nullable();
            t.string('theme', 32).nullable();
            t.string('wallpaper', 128).nullable();
            t.string('plan', 32).nullable();                   // basic|plus|unlimited
            t.json('metadata').nullable();
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
            t.datetime('updated_at').notNullable().defaultTo(knex.fn.now());
        });
    }

    if (!(await knex.schema.hasTable('messages'))) {
        await knex.schema.createTable('messages', (t) => {
            t.increments('id').primary();
            t.string('from_number', 16).notNullable().index();
            t.string('to_number', 16).notNullable().index();
            t.text('text').notNullable();
            t.string('status', 16).notNullable().defaultTo('sent'); // sent|delivered|read
            t.string('idempotency_key', 64).nullable().index();
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
        });
        await knex.schema.alterTable('messages', (t) => {
            t.index(['to_number', 'created_at']);
            t.index(['from_number', 'created_at']);
        });
    }

    if (!(await knex.schema.hasTable('contacts'))) {
        await knex.schema.createTable('contacts', (t) => {
            t.increments('id').primary();
            t.integer('phone_id').notNullable().references('id').inTable('phones').onDelete('CASCADE');
            t.string('name', 64).notNullable();
            t.string('number', 16).notNullable();
            t.boolean('favorite').notNullable().defaultTo(false);
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
            t.unique(['phone_id', 'number']);
        });
    }

    if (!(await knex.schema.hasTable('ads'))) {
        await knex.schema.createTable('ads', (t) => {
            t.increments('id').primary();
            t.integer('char_id').notNullable().index();
            t.string('phone_number', 16).nullable().index();
            t.string('title', 80).notNullable();
            t.text('body').notNullable();
            t.boolean('active').notNullable().defaultTo(true);
            t.boolean('approved').notNullable().defaultTo(true); // moderation hook for later
            t.datetime('expires_at').nullable();
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
        });
        await knex.schema.alterTable('ads', (t) => t.index(['active', 'approved', 'created_at']));
    }
}

export async function down(knex) {
    await knex.schema.dropTableIfExists('ads');
    await knex.schema.dropTableIfExists('contacts');
    await knex.schema.dropTableIfExists('messages');
    await knex.schema.dropTableIfExists('phones');
}
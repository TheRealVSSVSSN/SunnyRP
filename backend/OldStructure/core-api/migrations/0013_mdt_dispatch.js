export async function up(knex) {
    // Core MDT tables
    if (!(await knex.schema.hasTable('reports'))) {
        await knex.schema.createTable('reports', (t) => {
            t.increments('id').primary();
            t.string('type', 24).notNullable(); // incident | citation | arrest | warrant | ems
            t.integer('author_char_id').notNullable().index();
            t.integer('author_user_id').notNullable().index();
            t.string('title', 128).notNullable();
            t.text('body').notNullable();
            t.json('metadata').nullable();      // tags, involved IDs, evidence refs
            t.boolean('sealed').notNullable().defaultTo(false);
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
            t.datetime('updated_at').notNullable().defaultTo(knex.fn.now());
        });
    }
    if (!(await knex.schema.hasTable('citations'))) {
        await knex.schema.createTable('citations', (t) => {
            t.increments('id').primary();
            t.integer('report_id').notNullable().unique().references('id').inTable('reports').onDelete('CASCADE');
            t.integer('suspect_char_id').notNullable().index();
            t.bigInteger('fine_cents').notNullable().defaultTo(0);
            t.json('charges').notNullable().defaultTo(JSON.stringify([])); // [{code, label, fine_cents}]
        });
    }
    if (!(await knex.schema.hasTable('arrests'))) {
        await knex.schema.createTable('arrests', (t) => {
            t.increments('id').primary();
            t.integer('report_id').notNullable().unique().references('id').inTable('reports').onDelete('CASCADE');
            t.integer('suspect_char_id').notNullable().index();
            t.integer('sentence_minutes').notNullable().defaultTo(0);
            t.json('charges').notNullable().defaultTo(JSON.stringify([]));
        });
    }
    if (!(await knex.schema.hasTable('warrants'))) {
        await knex.schema.createTable('warrants', (t) => {
            t.increments('id').primary();
            t.integer('report_id').notNullable().unique().references('id').inTable('reports').onDelete('CASCADE');
            t.integer('target_char_id').notNullable().index();
            t.boolean('active').notNullable().defaultTo(true);
            t.datetime('issued_at').notNullable().defaultTo(knex.fn.now());
            t.datetime('expires_at').nullable();
        });
    }
    if (!(await knex.schema.hasTable('evidence'))) {
        await knex.schema.createTable('evidence', (t) => {
            t.increments('id').primary();
            t.integer('report_id').notNullable().index().references('id').inTable('reports').onDelete('CASCADE');
            t.string('type', 24).notNullable(); // photo | item | dna | note
            t.string('label', 128).notNullable();
            t.json('data').nullable();          // storage pointer or metadata
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
        });
    }

    // Dispatch tables
    if (!(await knex.schema.hasTable('dispatch_calls'))) {
        await knex.schema.createTable('dispatch_calls', (t) => {
            t.increments('id').primary();
            t.string('kind', 16).notNullable();         // 911 | 311 | ems
            t.string('summary', 256).notNullable();
            t.integer('caller_char_id').nullable().index();
            t.integer('caller_user_id').nullable().index();
            t.json('location').nullable();              // {x,y,z,street}
            t.json('metadata').nullable();              // e.g., phone, plate
            t.string('status', 16).notNullable().defaultTo('open'); // open|active|cleared|cancelled
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
            t.datetime('updated_at').notNullable().defaultTo(knex.fn.now());
        });
    }
    if (!(await knex.schema.hasTable('dispatch_units'))) {
        await knex.schema.createTable('dispatch_units', (t) => {
            t.increments('id').primary();
            t.integer('call_id').notNullable().references('id').inTable('dispatch_calls').onDelete('CASCADE');
            t.integer('unit_char_id').notNullable().index();
            t.string('unit_job', 16).notNullable();     // police|ems|doj
            t.string('status', 16).notNullable().defaultTo('attached'); // attached|onscene|cleared
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
            t.unique(['call_id', 'unit_char_id']);
        });
    }
}

export async function down(knex) {
    await knex.schema.dropTableIfExists('dispatch_units');
    await knex.schema.dropTableIfExists('dispatch_calls');
    await knex.schema.dropTableIfExists('evidence');
    await knex.schema.dropTableIfExists('warrants');
    await knex.schema.dropTableIfExists('arrests');
    await knex.schema.dropTableIfExists('citations');
    await knex.schema.dropTableIfExists('reports');
}
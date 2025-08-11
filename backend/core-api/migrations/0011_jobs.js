export async function up(knex) {
    if (!(await knex.schema.hasTable('job_defs'))) {
        await knex.schema.createTable('job_defs', (t) => {
            t.increments('id').primary();
            t.string('code', 32).notNullable().unique();   // e.g., police, ems, sanitation, fastfood
            t.string('label', 64).notNullable();
            t.string('category', 16).notNullable().defaultTo('civ'); // civ|whitelist
            t.bigInteger('hourly_cents').notNullable().defaultTo(0); // default hourly for grade 0
            t.integer('default_grade').notNullable().defaultTo(0);
            t.boolean('duty_required').notNullable().defaultTo(true);
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
            t.datetime('updated_at').notNullable().defaultTo(knex.fn.now());
        });
    }
    if (!(await knex.schema.hasTable('job_grades'))) {
        await knex.schema.createTable('job_grades', (t) => {
            t.increments('id').primary();
            t.integer('job_def_id').notNullable().index();
            t.integer('grade').notNullable().defaultTo(0); // 0..n
            t.string('label', 64).notNullable();
            t.bigInteger('hourly_cents_override').nullable(); // if null -> use def.hourly_cents
            t.json('permissions').nullable(); // array of scope strings
            t.unique(['job_def_id', 'grade']);
        });
    }
    if (!(await knex.schema.hasTable('jobs'))) {
        await knex.schema.createTable('jobs', (t) => {
            t.increments('id').primary();
            t.integer('char_id').notNullable().unique().index(); // one active job per character
            t.integer('job_def_id').notNullable().index();
            t.integer('grade').notNullable().defaultTo(0);
            t.boolean('on_duty').notNullable().defaultTo(false);
            t.datetime('hired_at').notNullable().defaultTo(knex.fn.now());
            t.datetime('last_duty_at').nullable();
            t.datetime('fired_at').nullable();
        });
    }

    // Seed a few core definitions/grades if empty
    const defs = await knex('job_defs');
    if (defs.length === 0) {
        const ids = await knex('job_defs').insert([
            { code: 'unemployed', label: 'Unemployed', category: 'civ', hourly_cents: 0, default_grade: 0, duty_required: false },
            { code: 'sanitation', label: 'Sanitation', category: 'civ', hourly_cents: 1800, default_grade: 0, duty_required: true },
            { code: 'fastfood', label: 'Fast Food', category: 'civ', hourly_cents: 2000, default_grade: 0, duty_required: true },
            { code: 'taxi', label: 'Taxi', category: 'civ', hourly_cents: 1800, default_grade: 0, duty_required: true },
            { code: 'police', label: 'Police', category: 'whitelist', hourly_cents: 4200, default_grade: 0, duty_required: true },
            { code: 'ems', label: 'EMS', category: 'whitelist', hourly_cents: 4000, default_grade: 0, duty_required: true },
        ]).returning('id');

        const defMap = Object.fromEntries((await knex('job_defs').select('id', 'code')).map(r => [r.code, r.id]));
        await knex('job_grades').insert([
            { job_def_id: defMap.police, grade: 0, label: 'Officer', hourly_cents_override: 4200, permissions: JSON.stringify(['police.base']) },
            { job_def_id: defMap.police, grade: 1, label: 'Corporal', hourly_cents_override: 4600, permissions: JSON.stringify(['police.base', 'police.supervisor']) },
            { job_def_id: defMap.police, grade: 2, label: 'Sergeant', hourly_cents_override: 5000, permissions: JSON.stringify(['police.base', 'police.supervisor', 'police.command']) },

            { job_def_id: defMap.ems, grade: 0, label: 'EMT', hourly_cents_override: 4000, permissions: JSON.stringify(['ems.base']) },
            { job_def_id: defMap.ems, grade: 1, label: 'Paramedic', hourly_cents_override: 4400, permissions: JSON.stringify(['ems.base', 'ems.advanced']) },
        ]);
    }
}

export async function down(knex) {
    await knex.schema.dropTableIfExists('jobs');
    await knex.schema.dropTableIfExists('job_grades');
    await knex.schema.dropTableIfExists('job_defs');
}
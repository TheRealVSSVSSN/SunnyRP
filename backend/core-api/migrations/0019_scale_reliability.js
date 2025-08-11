export async function up(knex) {
    if (!(await knex.schema.hasTable('outbox_events'))) {
        await knex.schema.createTable('outbox_events', (t) => {
            t.increments('id').primary();
            t.string('type', 64).notNullable();               // e.g. 'notify.staff', 'webhook.audit'
            t.json('payload').notNullable();
            t.string('status', 16).notNullable().defaultTo('pending'); // pending|processing|done|dead
            t.integer('attempts').notNullable().defaultTo(0);
            t.datetime('next_run_at').notNullable().defaultTo(knex.fn.now());
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
            t.datetime('updated_at').notNullable().defaultTo(knex.fn.now());
            t.string('worker_id', 64).nullable();
            t.text('last_error').nullable();
        });
        await knex.schema.alterTable('outbox_events', (t) => {
            t.index(['status', 'next_run_at']);
        });
    }
}
export async function down(knex) {
    await knex.schema.dropTableIfExists('outbox_events');
}
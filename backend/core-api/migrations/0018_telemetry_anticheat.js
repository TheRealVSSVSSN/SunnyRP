export async function up(knex) {
  if (!(await knex.schema.hasTable('telemetry_events'))) {
    await knex.schema.createTable('telemetry_events', (t) => {
      t.increments('id').primary();
      t.integer('user_id').nullable().index();
      t.integer('char_id').nullable().index();
      t.string('type', 48).notNullable();           // movement|anomaly|economy|inventory|custom
      t.string('subcategory', 48).nullable();       // e.g., speed, teleport
      t.integer('severity').notNullable().defaultTo(0); // 0=info,1=low,2=med,3=high
      t.json('payload').nullable();
      t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
    });
    await knex.schema.alterTable('telemetry_events', (t) => t.index(['type', 'created_at']));
  }

  if (!(await knex.schema.hasTable('alerts'))) {
    await knex.schema.createTable('alerts', (t) => {
      t.increments('id').primary();
      t.string('kind', 48).notNullable();           // anomaly|system|staff
      t.integer('severity').notNullable().defaultTo(1);
      t.text('message').notNullable();
      t.json('meta').nullable();
      t.boolean('ack').notNullable().defaultTo(false);
      t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
    });
    await knex.schema.alterTable('alerts', (t) => t.index(['ack','created_at']));
  }
}

export async function down(knex) {
  await knex.schema.dropTableIfExists('alerts');
  await knex.schema.dropTableIfExists('telemetry_events');
}
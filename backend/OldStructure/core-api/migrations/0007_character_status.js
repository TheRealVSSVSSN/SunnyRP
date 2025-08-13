export async function up(knex) {
    const exists = await knex.schema.hasTable('character_status');
    if (!exists) {
        await knex.schema.createTable('character_status', (t) => {
            t.integer('character_id').primary();                 // fk characters.id (created in Phase C)
            t.float('hunger').notNullable().defaultTo(100);
            t.float('thirst').notNullable().defaultTo(100);
            t.float('stress').notNullable().defaultTo(0);
            t.float('temperature').notNullable().defaultTo(50);  // 0=cold .. 100=hot
            t.float('wetness').notNullable().defaultTo(0);       // 0=dry .. 100=soaked
            t.float('drug').notNullable().defaultTo(0);          // 0..100
            t.float('alcohol').notNullable().defaultTo(0);       // 0..100
            t.datetime('updated_at').notNullable().defaultTo(knex.fn.now());
        });
    }
}
export async function down(knex) {
    await knex.schema.dropTableIfExists('character_status');
}
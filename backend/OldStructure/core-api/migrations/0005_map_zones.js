export async function up(knex) {
    const exists = await knex.schema.hasTable('map_zones');
    if (!exists) {
        await knex.schema.createTable('map_zones', (t) => {
            t.increments('id').primary();
            t.string('name', 64).notNullable().unique();
            t.enum('type', ['circle', 'poly']).notNullable();
            t.json('data').notNullable();     // { center:{x,y,z?}, radius } OR { points:[{x,y,z?}...], minZ?, maxZ? }
            t.json('blip').nullable();        // { sprite, color, scale, text, coords }
            t.integer('created_by').nullable().index(); // user id
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
        });
    }
}
export async function down(knex) {
    await knex.schema.dropTableIfExists('map_zones');
}
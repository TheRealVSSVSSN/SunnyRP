export async function up(knex) {
    const exists = await knex.schema.hasTable('chat_log');
    if (!exists) {
        await knex.schema.createTable('chat_log', (t) => {
            t.increments('id').primary();
            t.integer('user_id').notNullable().index();
            t.integer('character_id').nullable().index();
            t.string('channel', 16).notNullable().index(); // local|me|do|ooc|staff
            t.text('message').notNullable();               // sanitized (stored)
            t.json('position').nullable();                 // {x,y,z,heading}
            t.integer('routing_bucket').nullable();
            t.integer('src').nullable();                   // server player source (for forensics)
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
        });
    }
}
export async function down(knex) {
    await knex.schema.dropTableIfExists('chat_log');
}
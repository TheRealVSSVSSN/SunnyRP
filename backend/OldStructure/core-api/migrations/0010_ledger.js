export async function up(knex) {
    const hasLedger = await knex.schema.hasTable('ledger');
    if (!hasLedger) {
        await knex.schema.createTable('ledger', (t) => {
            t.increments('id').primary();
            t.string('transfer_id', 64).notNullable().index();     // logical op
            t.string('idem_key', 128).nullable().index();          // X-Idempotency-Key echo
            t.string('kind', 32).notNullable().defaultTo('transfer'); // transfer|payroll|tax|purchase
            // accounts
            t.string('from_type', 16).notNullable(); // char|gov|biz
            t.string('from_ref', 64).nullable();     // charId or code (e.g., 'state:pit')
            t.string('from_pocket', 16).nullable();  // cash|bank|null
            t.string('to_type', 16).notNullable();
            t.string('to_ref', 64).nullable();
            t.string('to_pocket', 16).nullable();
            // money
            t.bigInteger('amount_cents').notNullable(); // signed? we keep positive and infer by direction
            t.string('currency', 8).notNullable().defaultTo('USD');
            t.json('meta').nullable();                // memo, tax breakdown, job_code, etc.
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
        });
        await knex.schema.alterTable('ledger', (t) => t.index(['from_type', 'from_ref']));
        await knex.schema.alterTable('ledger', (t) => t.index(['to_type', 'to_ref']));
    }

    // Ensure accounts table exists (Phase C should have created it, but we harden here)
    const hasAccounts = await knex.schema.hasTable('accounts');
    if (!hasAccounts) {
        await knex.schema.createTable('accounts', (t) => {
            t.increments('id').primary();
            t.integer('char_id').notNullable().unique().index();
            t.bigInteger('cash_cents').notNullable().defaultTo(0);
            t.bigInteger('bank_cents').notNullable().defaultTo(0);
            t.datetime('updated_at').notNullable().defaultTo(knex.fn.now());
        });
    } else {
        const cols = await knex('information_schema.columns')
            .select('column_name')
            .where({ table_name: 'accounts' });
        const have = Object.fromEntries(cols.map(c => [c.column_name, true]));
        if (!have['cash_cents']) await knex.schema.alterTable('accounts', t => t.bigInteger('cash_cents').notNullable().defaultTo(0));
        if (!have['bank_cents']) await knex.schema.alterTable('accounts', t => t.bigInteger('bank_cents').notNullable().defaultTo(0));
    }

    // Idempotency table was added in Phase G; create if missing
    const hasIdem = await knex.schema.hasTable('idempotency_keys');
    if (!hasIdem) {
        await knex.schema.createTable('idempotency_keys', (t) => {
            t.increments('id').primary();
            t.string('scope', 64).notNullable().index();
            t.string('key', 128).notNullable().unique();
            t.json('response').nullable();
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
        });
    }
}
export async function down(knex) {
    await knex.schema.dropTableIfExists('ledger');
    // do not drop accounts/idempotency
}
export async function up(knex) {
    if (!(await knex.schema.hasTable('businesses'))) {
        await knex.schema.createTable('businesses', (t) => {
            t.increments('id').primary();
            t.string('slug', 64).notNullable().unique();  // e.g., 247_vanilla_1
            t.string('label', 96).notNullable();
            t.string('type', 24).notNullable();           // 247|clothing|gas|food|weapons|bank
            t.boolean('npc_owned').notNullable().defaultTo(true);
            t.integer('owner_char_id').nullable().index();
            t.boolean('open').notNullable().defaultTo(true);
            t.decimal('tax_rate', 5, 2).nullable();       // override default %, null=use global
            t.string('account_id', 64).nullable();        // economy account (Phase H)
            t.json('metadata').nullable();                // {coords:{x,y,z}, registerCount, ...}
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
            t.datetime('updated_at').notNullable().defaultTo(knex.fn.now());
        });

        // seed one 24/7 for DoD
        await knex('businesses').insert({
            slug: '247_vanilla_1',
            label: '24/7 — Strawberry',
            type: '247',
            npc_owned: true,
            open: true,
            tax_rate: 8.50,
            account_id: 'biz:247_vanilla_1',
            metadata: JSON.stringify({ coords: { x: 25.7, y: -1347.3, z: 29.5 } })
        });
    }

    if (!(await knex.schema.hasTable('business_items'))) {
        await knex.schema.createTable('business_items', (t) => {
            t.increments('id').primary();
            t.integer('business_id').notNullable().references('id').inTable('businesses').onDelete('CASCADE');
            t.string('item_code', 64).notNullable();           // matches Phase G items.code
            t.bigInteger('price_cents').notNullable();
            t.integer('stock_qty').nullable();                 // null => infinite (NPC shop)
            t.boolean('enabled').notNullable().defaultTo(true);
            t.unique(['business_id', 'item_code']);
        });

        // seed a minimal 24/7 catalog
        const biz = await knex('businesses').where({ slug: '247_vanilla_1' }).first();
        if (biz) {
            await knex('business_items').insert([
                { business_id: biz.id, item_code: 'water', price_cents: 150, stock_qty: null },
                { business_id: biz.id, item_code: 'sandwich', price_cents: 450, stock_qty: null },
                { business_id: biz.id, item_code: 'repairkit', price_cents: 12500, stock_qty: 10 },
                { business_id: biz.id, item_code: 'phone', price_cents: 25000, stock_qty: 5 }
            ]);
        }
    }

    if (!(await knex.schema.hasTable('business_employees'))) {
        await knex.schema.createTable('business_employees', (t) => {
            t.increments('id').primary();
            t.integer('business_id').notNullable().references('id').inTable('businesses').onDelete('CASCADE');
            t.integer('char_id').notNullable().index();
            t.string('role', 16).notNullable().defaultTo('cashier'); // boss|manager|cashier
            t.boolean('active').notNullable().defaultTo(true);
            t.datetime('hired_at').notNullable().defaultTo(knex.fn.now());
            t.unique(['business_id', 'char_id']);
        });
    }

    if (!(await knex.schema.hasTable('transactions'))) {
        await knex.schema.createTable('transactions', (t) => {
            t.increments('id').primary();
            t.integer('business_id').nullable().index();
            t.integer('char_id').nullable().index();     // buyer or actor
            t.string('kind', 24).notNullable();          // sale|restock|wage|tax|adjust
            t.bigInteger('amount_cents').notNullable();  // positive for credit to business, negative for debit
            t.string('idempotency_key', 64).nullable().index();
            t.json('lines').nullable();                  // [{code,qty,price_cents}]
            t.json('meta').nullable();
            t.datetime('created_at').notNullable().defaultTo(knex.fn.now());
        });
        await knex.schema.alterTable('transactions', (t) => t.index(['business_id', 'created_at']));
    }
}

export async function down(knex) {
    await knex.schema.dropTableIfExists('transactions');
    await knex.schema.dropTableIfExists('business_employees');
    await knex.schema.dropTableIfExists('business_items');
    await knex.schema.dropTableIfExists('businesses');
}
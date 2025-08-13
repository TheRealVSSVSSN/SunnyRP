// Minimal server-side loot tables; later you can DB-ify these.
const TABLES = {
    // cash registers at 24/7
    'register_247': [
        { code: 'cash_dirty', qty: [50, 120], weight: 70 },   // $0.50-$1.20 as item cents? We'll use count == cents here for simplicity
        { code: 'water', qty: [1, 2], weight: 18 },
        { code: 'sandwich', qty: [1, 1], weight: 12 }
    ],
    'safe_small': [
        { code: 'cash_dirty', qty: [500, 1200], weight: 80 },
        { code: 'markedbills', qty: [1, 2], weight: 15 },
        { code: 'lockpick', qty: [1, 1], weight: 5 }
    ]
};

function randInt(min, max) { return Math.floor(Math.random() * (max - min + 1)) + min; }
function pickWeighted(list) {
    const total = list.reduce((a, b) => a + b.weight, 0);
    let r = Math.random() * total;
    for (const it of list) { r -= it.weight; if (r <= 0) return it; }
    return list[list.length - 1];
}
export async function roll(body) {
    const table = String(body.table || '');
    const rolls = Math.max(1, Math.min(5, Number(body.rolls || 1)));
    const t = TABLES[table];
    if (!t) { const e = new Error('TABLE_NOT_FOUND'); e.statusCode = 404; throw e; }
    const out = [];
    for (let i = 0; i < rolls; i++) {
        const it = pickWeighted(t);
        const qty = Array.isArray(it.qty) ? randInt(it.qty[0], it.qty[1]) : Number(it.qty || 1);
        out.push({ code: it.code, qty });
    }
    return { table, items: out };
}
const el = (id) => document.getElementById(id);
const groups = {
    vitals: el('grp-vitals'),
    status: el('grp-status'),
    identity: el('grp-identity'),
    voice: el('grp-voice'),
};

const bars = {
    health: el('bar-health'), armor: el('bar-armor'),
    hunger: el('bar-hunger'), thirst: el('bar-thirst'), stress: el('bar-stress'),
    temp: el('bar-temp'), wet: el('bar-wet'),
};
const labels = {
    health: el('lbl-health'), armor: el('lbl-armor'),
    hunger: el('lbl-hunger'), thirst: el('lbl-thirst'), stress: el('lbl-stress'),
    temp: el('lbl-temp'), wet: el('lbl-wet'),
};

const chips = {
    hot: el('chip-hot'), cold: el('chip-cold'),
    wet: el('chip-wet'), dry: el('chip-dry'),
    high: el('chip-high'), drunk: el('chip-drunk'),
};

const idFields = {
    cash: el('id-cash'), bank: el('id-bank'),
    job: el('id-job'), duty: el('id-duty'),
};

const mic = el('voice-mic');
const vmode = el('voice-mode');

function clamp01(v) { return Math.max(0, Math.min(100, v)); }
function $formatMoney(n) { return '$' + (Math.round(Number(n) || 0)).toLocaleString(); }

function setBar(name, value) {
    const pct = clamp01(value) / 100;
    if (bars[name]) bars[name].style.transform = `scaleX(${pct})`;
    if (labels[name]) labels[name].textContent = Math.round(clamp01(value));
}

function setChipActive(chipEl, on) { if (!chipEl) return; chipEl.classList.toggle('active', !!on); }

function updateIdentity(p) {
    if (p.cash != null) idFields.cash.textContent = $formatMoney(p.cash);
    if (p.bank != null) idFields.bank.textContent = $formatMoney(p.bank);
    if (p.job != null) idFields.job.textContent = String(p.job);
    if (p.duty != null) idFields.duty.textContent = p.duty ? 'On' : 'Off';
}

function updateStatus(s) {
    if (!s) return;
    if (s.hunger != null) setBar('hunger', s.hunger);
    if (s.thirst != null) setBar('thirst', s.thirst);
    if (s.stress != null) setBar('stress', s.stress);
    if (s.temperature != null) setBar('temp', s.temperature);
    if (s.wetness != null) setBar('wet', s.wetness);
    if (s.drug != null) setChipActive(chips.high, s.drug >= 30);
    if (s.alcohol != null) setChipActive(chips.drunk, s.alcohol >= 30);

    // derive hot/cold/wet/dry chips
    const temp = s.temperature != null ? s.temperature : Number(labels.temp.textContent || 50);
    setChipActive(chips.hot, temp >= 70);
    setChipActive(chips.cold, temp <= 30);

    const wet = s.wetness != null ? s.wetness : Number(labels.wet.textContent || 0);
    setChipActive(chips.wet, wet >= 50);
    setChipActive(chips.dry, wet <= 10);
}

function updateVitals(v) {
    if (v.health != null) setBar('health', (Number(v.health) || 0) / 2.0); // GTA health ~ 200 → %
    if (v.armor != null) setBar('armor', Number(v.armor) || 0);
}

function updateVoice(v) {
    if (v.talking != null) mic.classList.toggle('talking', !!v.talking);
}

function setVoiceMode(m) {
    vmode.textContent = (m === 'whisper') ? 'W' : (m === 'shout') ? 'S' : 'N';
    vmode.classList.remove('whisper', 'normal', 'shout');
    vmode.classList.add(m === 'whisper' ? 'whisper' : m === 'shout' ? 'shout' : 'normal');
}

function setVisibleAll(show) {
    Object.values(groups).forEach(g => g.classList.toggle('hidden', !show));
}
function setGroup(group, show) {
    const g = groups[group]; if (!g) return;
    g.classList.toggle('hidden', !show);
}
function setItem(item, show) {
    // items map to DOM IDs if you want per-item control; example:
    const map = {
        health: 'bar-health', armor: 'bar-armor',
        hunger: 'bar-hunger', thirst: 'bar-thirst', stress: 'bar-stress',
        temp: 'bar-temp', wet: 'bar-wet',
        cash: 'id-cash', bank: 'id-bank', job: 'id-job', duty: 'id-duty',
        voice: 'grp-voice'
    };
    const node = document.getElementById(map[item]);
    if (!node) return;
    const box = node.closest('.bar') || node.closest('.field') || node;
    box.classList.toggle('hidden', !show);
}

window.addEventListener('message', (e) => {
    const a = e.data?.action, p = e.data?.payload || {};
    if (a === 'hud:update') {
        if (p.identity) updateIdentity(p.identity);
        if (p.status) updateStatus(p.status);
        if (p.vitals) updateVitals(p.vitals);
        if (p.voice) updateVoice(p.voice);
    } else if (a === 'visible:init') {
        Object.entries(p).forEach(([k, v]) => setGroup(k, !!v));
    } else if (a === 'visible:all') {
        setVisibleAll(!!p);
    } else if (a === 'visible:group') {
        setGroup(p.group, !!p.show);
    } else if (a === 'visible:item') {
        setItem(p.item, !!p.show);
    } else if (a === 'voice:mode') {
        setVoiceMode(p);
    }
});

// Initialize defaults
setBar('health', 100); setBar('armor', 0);
setBar('hunger', 100); setBar('thirst', 100); setBar('stress', 0);
setBar('temp', 50); setBar('wet', 0);
setVoiceMode('normal');
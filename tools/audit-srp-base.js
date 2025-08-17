#!/usr/bin/env node
/**
 * SunnyRP Phase 1 Audit — srp-base (files, NUI, DB direct usage, event naming)
 * Outputs: tools/audit-output/srp-base-report.json + srp-base-report.md
 *
 * Scans:
 *  - resources/[sunnyrp]/sunnyrp-base/**/ /*
 * - backend / services / base - api/**/ /*
 *
 * Matches Phase 1 scope from the plan:
 * - include all files present & loaded
    * - identify redundancies(DB in Lua vs service)
        * - naming / structure consistency(SRP.*, event prefixes)
            * - version sync / interface expectations
                */
import fs from "fs/promises";
import path from "path";
import fg from "fast-glob";

const ROOT = process.cwd();
const BASE_RES = "resources";
const BASE_RES_NAME_CANDIDATES = [
    "[sunnyrp]/sunnyrp-base",
    "[sunnyrp]/sunnyrp_base",
    "sunnyrp/sunnyrp-base",
    "sunnyrp/srp-base",
];
const SERVICE_PATHS = [
    "backend/services/base-api",
    "backend/services/srp-base",
    "backend/services/base",
];

// Simple helpers
const exists = async (p) => !!(await fs.stat(p).catch(() => null));
const read = async (p) => (await fs.readFile(p)).toString("utf8");
const outDir = path.join(ROOT, "tools/audit-output");
await fs.mkdir(outDir, { recursive: true });

function uniq(arr) { return [...new Set(arr)]; }

function regexScan(text, regex, group = 0) {
    const hits = [];
    for (const m of text.matchAll(regex)) {
        hits.push(group ? m[group] : m[0]);
    }
    return hits;
}

// Patterns
const PATTERNS = {
    nui: /\b(SendNUIMessage|RegisterNUICallback|SetNuiFocus)\b/g,
    uiPage: /\bui_page\s+["'][^"']+["']/g,
    directDb: /\b(ghmattimysql|exports\.ghmattimysql|MySQL\.|oxmysql)\b/g,
    http: /\b(PerformHttpRequestAwait|PerformHttpRequest)\b/g,
    srpGlobal: /\bSRP\.[A-Za-z_][A-Za-z0-9_]*\b/g,
    registerNetEvent: /RegisterNetEvent\(["']([^"']+)["']\)/g,
    triggerEventClient: /TriggerClientEvent\(["']([^"']+)["']/g,
    triggerEventServer: /TriggerServerEvent\(["']([^"']+)["']/g,
    fxmanifestUi: /^ui_page\s+/m,
};

// Expected files in srp-base (Phase 1 “include all files”)
const MUST_HAVE = [
    "fxmanifest.lua",
    "config.lua",
    "shared/utils.lua",
    "shared/state.lua",
    "server",
    "client",
];

const EVENT_PREFIX = "srp-base:"; // naming consistency

async function locateBaseResource() {
    for (const candidate of BASE_RES_NAME_CANDIDATES) {
        const p = path.join(ROOT, BASE_RES, candidate);
        if (await exists(p)) return { dir: p, label: candidate };
    }
    throw new Error(`Could not find srp-base under ${BASE_RES}/[sunnyrp]/...`);
}

async function locateService() {
    for (const p of SERVICE_PATHS) {
        const full = path.join(ROOT, p);
        if (await exists(full)) return { dir: full, label: p };
    }
    // Service might not exist yet in repo; Phase 1 still runs
    return null;
}

async function scanLuaTree(dir) {
    const files = await fg(["**/*.{lua,xml,meta,yml,json,js,ts,html,css}", "!node_modules/**"], { cwd: dir, dot: true });
    const byFile = [];
    const collectedEvents = { registered: [], trigClient: [], trigServer: [] };
    let foundUiPageFxmanifest = false;

    for (const rel of files) {
        const full = path.join(dir, rel);
        const text = await read(full);
        const ext = path.extname(rel).toLowerCase();

        const nui = regexScan(text, PATTERNS.nui);
        const uiPage = regexScan(text, PATTERNS.uiPage);
        const directDb = regexScan(text, PATTERNS.directDb);
        const http = regexScan(text, PATTERNS.http);
        const srpGlobal = uniq(regexScan(text, PATTERNS.srpGlobal).map(s => s.slice(4)));
        const regEv = uniq(regexScan(text, PATTERNS.registerNetEvent, 1));
        const tce = uniq(regexScan(text, PATTERNS.triggerEventClient, 1));
        const tse = uniq(regexScan(text, PATTERNS.triggerEventServer, 1));

        if (ext === ".lua" || ext === ".xml") {
            if (PATTERNS.fxmanifestUi.test(text)) foundUiPageFxmanifest = true;
        }

        collectedEvents.registered.push(...regEv);
        collectedEvents.trigClient.push(...tce);
        collectedEvents.trigServer.push(...tse);

        byFile.push({
            file: rel,
            nuiCalls: nui,
            uiPageEntries: uiPage,
            directDbCalls: directDb,
            httpCalls: http,
            srpGlobalUses: srpGlobal,
        });
    }

    // Naming consistency: anything that starts with our prefix vs not
    const allEvents = uniq([
        ...collectedEvents.registered,
        ...collectedEvents.trigClient,
        ...collectedEvents.trigServer,
    ]);

    const prefixed = allEvents.filter(e => e.startsWith(EVENT_PREFIX));
    const nonPrefixed = allEvents.filter(e => !e.startsWith(EVENT_PREFIX) && e.includes(":"));

    return {
        files,
        byFile,
        events: {
            all: allEvents.sort(),
            prefixed: prefixed.sort(),
            nonPrefixed: nonPrefixed.sort(),
            registered: uniq(collectedEvents.registered).sort(),
            trigClient: uniq(collectedEvents.trigClient).sort(),
            trigServer: uniq(collectedEvents.trigServer).sort(),
        },
        foundUiPageFxmanifest,
    };
}

async function ensureMustHave(dir) {
    const results = [];
    for (const m of MUST_HAVE) {
        results.push({ path: m, present: await exists(path.join(dir, m)) });
    }
    return results;
}

async function scanServiceTree(dir) {
    if (!dir) return null;
    const files = await fg(["**/*.{js,ts,json,yml}", "!node_modules/**"], { cwd: dir, dot: true });
    const endpoints = [];
    for (const rel of files) {
        const full = path.join(dir, rel);
        const text = await read(full);
        // naive route pattern sniff (express-like)
        const hit = regexScan(text, /\b(app|router)\.(get|post|put|delete)\(\s*["'](\/v1\/[a-z0-9/_:-]+)["']/gi, 3);
        if (hit.length) endpoints.push({ file: rel, routes: uniq(hit).sort() });
    }
    return { files, endpoints };
}

function summarizeFindings(baseScan, mustHave, serviceScan) {
    const missing = mustHave.filter(x => !x.present).map(x => x.path);
    const nuiHits = baseScan.byFile.filter(f => f.nuiCalls.length || f.uiPageEntries.length);
    const dbHits = baseScan.byFile.filter(f => f.directDbCalls.length);
    const httpHits = baseScan.byFile.filter(f => f.httpCalls.length);
    const hasNuiInFxmanifest = baseScan.foundUiPageFxmanifest;

    // Events that look like base-domain but not properly prefixed
    const inconsistentEvents = baseScan.events.nonPrefixed
        .filter(e => e.includes("base")); // heuristic

    return {
        mustHave: { missing, present: mustHave.filter(x => x.present).map(x => x.path) },
        nui: {
            hasNuiInFxmanifest,
            files: nuiHits.map(f => ({ file: f.file, nuiCalls: f.nuiCalls, uiPageEntries: f.uiPageEntries }))
        },
        directDb: {
            files: dbHits.map(f => ({ file: f.file, directDbCalls: f.directDbCalls }))
        },
        httpCalls: {
            files: httpHits.map(f => ({ file: f.file, httpCalls: f.httpCalls }))
        },
        srpGlobalModules: uniq(baseScan.byFile.flatMap(f => f.srpGlobalUses)).sort(),
        events: baseScan.events,
        service: serviceScan ? {
            routeFiles: serviceScan.endpoints,
            routeList: uniq(serviceScan.endpoints.flatMap(e => e.routes)).sort(),
        } : null
    };
}

function mdReport(summary, baseDir, serviceDir) {
    const md = [];
    md.push(`# SunnyRP Phase 1 Audit Report`);
    md.push(`- Base resource: \`${baseDir}\``);
    md.push(`- Service (if found): \`${serviceDir ?? "not found"}\``);
    md.push(``);
    md.push(`## Required Files`);
    md.push(`- Present: ${summary.mustHave.present.map(p => "`" + p + "`").join(", ") || "_none_"} `);
    md.push(`- Missing: ${summary.mustHave.missing.length ? summary.mustHave.missing.join(", ") : "_none_"} `);
    md.push(``);
    md.push(`## NUI (should be removed from base later)`);
    md.push(`- fxmanifest has ui_page: **${summary.nui.hasNuiInFxmanifest ? "YES" : "NO"}**`);
    summary.nui.files.forEach(f => {
        md.push(`  - \`${f.file}\`: nuiCalls=[${f.nuiCalls.join(", ")}] ui_page=[${f.uiPageEntries.join(", ")}]`);
    });
    md.push(``);
    md.push(`## Direct DB usage in Lua (must be routed to service in later phases)`);
    summary.directDb.files.forEach(f => {
        md.push(`  - \`${f.file}\`: ${f.directDbCalls.join(", ")}`);
    });
    if (summary.directDb.files.length === 0) md.push(`  - _none detected_`);
    md.push(``);
    md.push(`## HTTP usage in Lua (good sign for service calls)`);
    summary.httpCalls.files.forEach(f => md.push(`  - \`${f.file}\`: ${f.httpCalls.join(", ")}`));
    if (summary.httpCalls.files.length === 0) md.push(`  - _none detected_`);
    md.push(``);
    md.push(`## SRP.* modules referenced`);
    md.push(`\`${summary.srpGlobalModules.join("`, `") || "_none_"}\``);
    md.push(``);
    md.push(`## Event naming`);
    md.push(`- All events: ${summary.events.all.length}`);
    md.push(`- Prefixed with \`${EVENT_PREFIX}\`: ${summary.events.prefixed.length}`);
    md.push(`- Non-prefixed (potential inconsistencies): ${summary.events.nonPrefixed.length}`);
    if (summary.events.nonPrefixed.length) {
        md.push(`  - ${summary.events.nonPrefixed.join(", ")}`);
    }
    if (summary.service) {
        md.push(``);
        md.push(`## Detected service routes (for version sync)`);
        summary.service.routeFiles.forEach(rf => {
            md.push(`- \`${rf.file}\`:`);
            rf.routes.forEach(rt => md.push(`  - ${rt}`));
        });
    }
    md.push(``);
    md.push(`---`);
    md.push(`_Phase-1 items come from the Base Integration Plan’s Audit & Cleanup and consistency sections._`);
    return md.join("\n");
}

const main = async () => {
    const base = await locateBaseResource();
    const baseScan = await scanLuaTree(base.dir);
    const mustHave = await ensureMustHave(base.dir);
    const service = await locateService();
    const serviceScan = service ? await scanServiceTree(service.dir) : null;

    const summary = summarizeFindings(baseScan, mustHave, serviceScan);

    const jsonOut = path.join(outDir, "srp-base-report.json");
    const mdOut = path.join(outDir, "srp-base-report.md");
    await fs.writeFile(jsonOut, JSON.stringify(summary, null, 2));
    await fs.writeFile(mdOut, mdReport(summary, base.label, service?.label));

    // Write Phase 1 checklist stub for the repo (so it can be tracked in git)
    const checklistTpl = await read(path.join("tools", "templates", "PHASE1-CHECKLIST.md"));
    const checklistOut = path.join(outDir, "PHASE1-CHECKLIST.md");
    await fs.writeFile(checklistOut, checklistTpl);

    console.log(`✔ srp-base audit complete.`);
    console.log(`  - ${path.relative(ROOT, jsonOut)}`);
    console.log(`  - ${path.relative(ROOT, mdOut)}`);
    console.log(`  - ${path.relative(ROOT, checklistOut)}`);
};

main().catch((e) => {
    console.error(e);
    process.exit(1);
});
const path = require('path');
const fs = require('fs');
const child_process = require('child_process');

const initCwd = process.cwd();
const trimOutput = (data) => `[yarn]\t${data.toString().trimEnd()}`;

let buildingInProgress = false;
let currentBuildingModule = '';
const buildQueue = [];

function runQueue() {
        if (buildingInProgress || buildQueue.length === 0) {
                return;
        }

        const { resourceName, cb } = buildQueue.shift();
        buildingInProgress = true;
        currentBuildingModule = resourceName;

        runYarn(resourceName)
                .then(() => cb(true))
                .catch((err) => cb(false, err.message || 'yarn failed!'))
                .finally(() => {
                        buildingInProgress = false;
                        currentBuildingModule = '';
                        runQueue();
                });
}

function runYarn(resourceName) {
        return new Promise((resolve, reject) => {
                const proc = child_process.fork(
                        require.resolve('./yarn_cli.js'),
                        ['install', '--ignore-scripts', '--cache-folder', path.join(initCwd, 'cache', 'yarn-cache'), '--mutex', 'file:' + path.join(initCwd, 'cache', 'yarn-mutex')],
                        {
                                cwd: path.resolve(GetResourcePath(resourceName)),
                                stdio: 'pipe',
                        }
                );

                proc.stdout.on('data', (data) => console.log(trimOutput(data)));
                proc.stderr.on('data', (data) => console.error(trimOutput(data)));
                proc.on('error', reject);
                proc.on('exit', (code, signal) => {
                        if (code !== 0 || signal) {
                                return reject(new Error('yarn failed'));
                        }

                        const resourcePath = GetResourcePath(resourceName);
                        const yarnLock = path.resolve(resourcePath, '.yarn.installed');
                        fs.writeFile(yarnLock, '', (err) => {
                                if (err) {
                                        return reject(err);
                                }
                                resolve();
                        });
                });
        });
}

const yarnBuildTask = {
        shouldBuild(resourceName) {
                try {
                        const resourcePath = GetResourcePath(resourceName);
                        const packageJson = path.resolve(resourcePath, 'package.json');
                        if (!fs.existsSync(packageJson)) {
                                return false;
                        }

                        const yarnLock = path.resolve(resourcePath, '.yarn.installed');
                        const packageStat = fs.statSync(packageJson);

                        try {
                                const yarnStat = fs.statSync(yarnLock);
                                return packageStat.mtimeMs > yarnStat.mtimeMs;
                        } catch (e) {
                                // yarn not yet installed
                                return true;
                        }
                } catch (e) {
                        console.error(`[yarn]\tfailed to determine build status for ${resourceName}:`, e);
                }

                return false;
        },

        build(resourceName, cb) {
                buildQueue.push({ resourceName, cb });
                runQueue();
        },
};

RegisterResourceBuildTaskFactory('yarn', () => yarnBuildTask);

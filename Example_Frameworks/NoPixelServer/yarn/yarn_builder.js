const path = require('path');
const { promises: fs } = require('fs');
const { fork } = require('child_process');

class YarnBuildTask {
  constructor() {
    this.building = false;
  }

  async shouldBuild(resourceName) {
    try {
      const resourcePath = GetResourcePath(resourceName);
      const packageJson = path.join(resourcePath, 'package.json');
      const yarnLock = path.join(resourcePath, 'yarn.lock');

      const pkgStat = await fs.stat(packageJson);
      try {
        const lockStat = await fs.stat(yarnLock);
        return pkgStat.mtimeMs > lockStat.mtimeMs;
      } catch {
        // yarn.lock missing - need to install
        return true;
      }
    } catch (err) {
      console.error(`yarn build check failed for ${resourceName}:`, err);
      return false;
    }
  }

  async build(resourceName, cb) {
    try {
      while (this.building) {
        console.log(`yarn is busy by another process: we are waiting to compile ${resourceName}`);
        await delay(3000);
      }
      this.building = true;

      await new Promise((resolve, reject) => {
        const child = fork(require.resolve('./yarn_cli.js'), ['install', '--ignore-scripts'], {
          cwd: path.resolve(GetResourcePath(resourceName)),
        });

        child.on('exit', (code, signal) => {
          if (code !== 0 || signal) {
            reject(new Error('yarn failed'));
          } else {
            resolve();
          }
        });
      });

      const yarnLock = path.join(GetResourcePath(resourceName), 'yarn.lock');
      const now = new Date();
      try {
        await fs.utimes(yarnLock, now, now);
      } catch (err) {
        console.warn(`failed to update yarn.lock mtime for ${resourceName}:`, err);
      }

      cb(true);
    } catch (err) {
      console.error(err);
      cb(false, err.message || 'yarn failed');
    } finally {
      this.building = false;
    }
  }
}

function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

RegisterResourceBuildTaskFactory('yarn', () => new YarnBuildTask());


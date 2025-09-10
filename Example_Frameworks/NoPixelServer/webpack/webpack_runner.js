const { parentPort, workerData } = require('worker_threads');
const webpack = require('webpack');
const path = require('path');
const fs = require('fs');

function getStat(filePath) {
    try {
        const stat = fs.statSync(filePath);
        return stat
            ? {
                  mtime: stat.mtimeMs,
                  size: stat.size,
                  inode: stat.ino,
              }
            : null;
    } catch {
        return null;
    }
}

class SaveStatePlugin {
    constructor(inp) {
        this.cache = [];
        this.cachePath = inp.cachePath;
    }

    apply(compiler) {
        compiler.hooks.afterCompile.tap('SaveStatePlugin', (compilation) => {
            for (const file of compilation.fileDependencies) {
                this.cache.push({ name: file, stats: getStat(file) });
            }
        });

        compiler.hooks.done.tap('SaveStatePlugin', async (stats) => {
            if (stats.hasErrors()) {
                return;
            }

            try {
                await fs.promises.writeFile(this.cachePath, JSON.stringify(this.cache));
            } catch {
                // ignore write errors
            }
        });
    }
}

const { configPath, resourcePath, cachePath } = workerData;
const config = require(configPath);

config.context = resourcePath;

if (config.output && config.output.path) {
    config.output.path = path.resolve(resourcePath, config.output.path);
}

config.plugins = config.plugins || [];
config.plugins.push(new SaveStatePlugin({ cachePath }));

webpack(config, (err, stats) => {
    if (err) {
        parentPort.postMessage({ error: err.stack || err });
        return;
    }

    if (stats.hasErrors()) {
        parentPort.postMessage({ errors: stats.toJson().errors });
        return;
    }

    parentPort.postMessage({});
});


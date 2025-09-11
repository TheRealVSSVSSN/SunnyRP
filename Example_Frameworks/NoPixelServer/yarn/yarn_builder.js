"use strict";

const path = require("node:path");
const fs = require("node:fs");
const { fork } = require("node:child_process");

let buildingInProgress = false;
let currentBuildingModule = "";

const yarnBuildTask = {
  shouldBuild(resourceName) {
    try {
      const resourcePath = GetResourcePath(resourceName);
      const packageJson = path.resolve(resourcePath, "package.json");
      if (!fs.existsSync(packageJson)) return false;

      const yarnLock = path.resolve(resourcePath, "yarn.lock");
      if (!fs.existsSync(yarnLock)) return true;

      const packageStat = fs.statSync(packageJson);
      const yarnStat = fs.statSync(yarnLock);
      return packageStat.mtimeMs > yarnStat.mtimeMs;
    } catch (e) {
      return false;
    }
  },

  build(resourceName, cb) {
    const run = async () => {
      while (buildingInProgress) {
        console.log(
          `yarn build for ${currentBuildingModule} in progress; waiting to build ${resourceName}`
        );
        await wait(3000);
      }

      buildingInProgress = true;
      currentBuildingModule = resourceName;

      try {
        await new Promise((resolve, reject) => {
          const child = fork(
            require.resolve("./yarn_cli.js"),
            ["install", "--ignore-scripts"],
            { cwd: path.resolve(GetResourcePath(resourceName)) }
          );

          child.on("error", reject);
          child.on("exit", (code, signal) => {
            if (code !== 0 || signal) {
              reject(
                new Error(
                  `yarn failed with code ${code}${signal ? ` and signal ${signal}` : ""}`
                )
              );
            } else {
              resolve();
            }
          });
        });

        const yarnLock = path.resolve(
          GetResourcePath(resourceName),
          "yarn.lock"
        );
        try {
          fs.utimesSync(yarnLock, new Date(), new Date());
        } catch {
          // ignore missing yarn.lock
        }

        cb(true);
      } catch (err) {
        cb(false, err.message);
      } finally {
        buildingInProgress = false;
        currentBuildingModule = "";
      }
    };

    run().catch((err) => console.error(err));
  },
};

const wait = (ms) => new Promise((res) => setTimeout(res, ms));

RegisterResourceBuildTaskFactory("yarn", () => yarnBuildTask);


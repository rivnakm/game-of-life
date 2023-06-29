#!/usr/bin/env zx

import fs from "fs";

import { spinner } from "zx/experimental";
import "zx/globals";

import average from "average";
import { stringify } from "csv-stringify/sync";
import { table } from "table";
import { colors } from "chalk";

$.verbose = false;
process.env.TIMEFORMAT = "%R";
let base_dir = await $`pwd`;
base_dir = base_dir.stdout.trim();

let iterations = argv.iterations || argv.i || 5;

class Language {
    setEnv() {
        for (var e in this.env) {
            process.env[e] = this.env[e];
        }
    }

    clearEnv() {
        for (var e in this.env) {
            process.env[e] = null;
        }
    }

    async build() {
        if (this.willRun()) {
            cd(this.dir);
            for (var cmd of this.buildCmds) {
                await spinner(
                    `Building ${this.properName} ...`,
                    () => $`${cmd}`
                );
            }
            console.log(
                `    Building ${this.properName} A ` + chalk.green("DONE")
            );
            cd(base_dir);

            cd("test")
            cd(this.dir);
            for (var cmd of this.buildCmds) {
                await spinner(
                    `Building ${this.properName} ...`,
                    () => $`${cmd}`
                );
            }
            console.log(
                `    Building ${this.properName} B ` + chalk.green("DONE")
            );
            cd(base_dir);
        }
    }

    async run() {
        if (this.willRun()) {
            cd(this.dir);
            if (this.old_results == null) {
                this.old_results = [];
            }
            for (var i = 1; i <= iterations; i++) {
                this.old_results.push(
                    await time(
                        this.runCmd,
                        `Running ${this.properName} A (${i}/${iterations}) ...`
                    )
                );
            }
            console.log(
                `    Running ${this.properName} ` + chalk.green("DONE")
            );
            cd(base_dir);

            cd("test");
            cd(this.dir);
            if (this.new_results == null) {
                this.new_results = [];
            }
            for (var i = 1; i <= iterations; i++) {
                this.new_results.push(
                    await time(
                        this.runCmd,
                        `Running ${this.properName} B (${i}/${iterations}) ...`
                    )
                );
            }
            console.log(
                `    Running ${this.properName} ` + chalk.green("DONE")
            );
            cd(base_dir);
        }
    }

    async clean() {
        if (this.willRun()) {
            cd(this.dir);
            for (var cmd of this.cleanCmds) {
                await spinner(
                    `Cleaning up ${this.properName} ...`,
                    () => $`${cmd}`
                );
            }
            console.log(
                `    Cleaning up ${this.properName} A ` + chalk.green("DONE")
            );
            cd(base_dir);

            cd("test")
            cd(this.dir);
            for (var cmd of this.cleanCmds) {
                await spinner(
                    `Cleaning up ${this.properName} ...`,
                    () => $`${cmd}`
                );
            }
            console.log(
                `    Cleaning up ${this.properName} B ` + chalk.green("DONE")
            );
            cd(base_dir);
        }
    }

    willRun() {
        if (argv.languages) {
            if (argv.languages === "all") {
                return true;
            } else if (argv.languages.split(",").includes(this.shortName)) {
                return true;
            } else {
                return false;
            }
        } else {
            return this.enabled;
        }
    }
}

async function time(cmd, message) {
    let time = await spinner(message, () => $`time ${cmd} > /dev/null`);
    return parseFloat(time.stderr.trim());
}

let languages = JSON.parse(
    fs.readFileSync("benchmark_setup.json")
).languages.map((l) => Object.setPrototypeOf(l, Language.prototype));

await $`git clone --branch=community https://github.com/mrivnak/game-of-life test`

for (var language of languages) {
    if (language.willRun()) {
        console.log(chalk.cyan(`\n${language.properName}`) + ":");
    }

    language.setEnv();
    if (language.buildCmds.length > 0) {
        await language.build();
    }

    await language.run();

    if (language.cleanCmds.length > 0) {
        await language.clean();
    }
    language.clearEnv();
}

await $`rm -rf test`

// Print results
console.log();
const averages = [];
for (var language of languages) {
    if (language.willRun()) {
        let old_result = average(language.old_results);
        let new_result = average(language.new_results);
        let pct_increase = ((new_result - old_result) / old_result) * 100 * -1
        pct_increase = pct_increase > 0 ? chalk.green(pct_increase.toFixed(0) + "%") : chalk.red(pct_increase.toFixed(0) + "%")
        averages.push([language.properName, old_result.toFixed(3), new_result.toFixed(3), pct_increase]);
    }
}

averages.sort((a, b) => {
    if (Number(a[1]) < Number(b[1])) {
        return -1;
    }
    if (Number(a[1]) > Number(b[1])) {
        return 1;
    }
    return 0;
});

averages.unshift(["language", "avg time A (s)", "avg time B (s)", "% faster"]);
console.log(`500 generations (average of ${iterations})`);
console.log(table(averages));

#!/usr/bin/env zx

import fs from "fs";

import { spinner } from "zx/experimental";
import "zx/globals";

import average from "average";
import { stringify } from "csv-stringify/sync";
import { table } from "table";

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
                `    Building ${this.properName} ` + chalk.green("DONE")
            );
            cd(base_dir);
        }
    }

    async run() {
        if (this.willRun()) {
            cd(this.dir);
            if (this.results == null) {
                this.results = [];
            }
            for (var i = 1; i <= iterations; i++) {
                this.results.push(
                    await time(
                        this.runCmd,
                        `Running ${this.properName} (${i}/${iterations}) ...`
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
                `    Cleaning up ${this.properName} ` + chalk.green("DONE")
            );
            cd(base_dir);
        }
    }

    willRun() {
        if (argv.languages) {
            if (argv.languages === "all") {
                return true;
            }
            else if (argv.languages.split(",").includes(this.shortName)) {
                return true;
            }
            else {
                return false;
            }
        } else {
            return this.enabled;
        }
    }
}

async function getVersion(cmd, regex) {
    const output = await $`${cmd}`
    const re = new RegExp(regex);
    const toSearch = output.stdout + output.stderr;
    const match = toSearch.match(re);
    return match !== null ? match[1] : "???";
}

async function time(cmd, message) {
    let time = await spinner(message, () => $`time ${cmd} > /dev/null`);
    return parseFloat(time.stderr.trim());
}

let languages = JSON.parse(fs.readFileSync('benchmark_setup.json')).languages.map(l => Object.setPrototypeOf(l, Language.prototype));

for (var language of languages) {
    if (language.willRun()) {
        console.log(chalk.cyan(`\n${language.properName}`) + ":");

        let version = await getVersion(language.version.cmd, language.version.regex);
        let program = language.version.cmd[0];
        console.log(chalk.magenta(`    ${program} v${version}`))
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

// Print results
console.log();
const averages = [];
for (var language of languages) {
    if (language.willRun()) {
        let result = average(language.results);
        averages.push([language.properName, result.toFixed(3)]);
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

averages.unshift(["language", "avg time (s)"]);
console.log(`500 generations (average of ${iterations})`);
console.log(table(averages));

const output = stringify(averages);
fs.writeFile("benchmark_results.csv", output, (err) => {
    if (err) {
        console.error(err);
    }
    // file written successfully
});

#!/usr/bin/env zx

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
    constructor(
        properName,
        shortName,
        pwd,
        env,
        buildCmd,
        runCmd,
        cleanCmd,
        enabled
    ) {
        this.properName = properName;
        this.shortName = shortName;
        this.pwd = pwd;
        this.env = env;
        this.buildCmd = buildCmd;
        this.runCmd = runCmd;
        this.cleanCmd = cleanCmd;
        this.enabled = enabled;
    }

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
            cd(this.pwd);
            for (var cmd of this.buildCmd) {
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
            cd(this.pwd);
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
            cd(this.pwd);
            for (var cmd of this.cleanCmd) {
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

async function time(cmd, message) {
    let time = await spinner(message, () => $`time ${cmd} > /dev/null`);
    return parseFloat(time.stderr.trim());
}

let languages = [
    new Language(
        "Ada",
        "ada",
        "ada",
        {},
        [["gnatmake", "-O3", "src/game_of_life.adb"]],
        "./game_of_life",
        ["gnatclean"],
        true
    ),
    new Language(
        "Bash",
        "bash",
        "bash",
        {},
        [],
        ["bash", "./game_of_life.sh"],
        [],
        false
    ),
    new Language(
        "C",
        "c",
        "c",
        { CFLAGS: "-O3" },
        ["make"],
        "./game_of_life",
        [["make", "clean"]],
        true
    ),
    new Language(
        "C++",
        "cpp",
        "cpp",
        {},
        [
            ["meson", "setup", "build"],
            ["meson", "setup", "--reconfigure", "build"],
            ["meson", "configure", "-Dbuildtype=release", "build"],
            ["ninja", "-C", "build"],
        ],
        "./build/game_of_life",
        [["ninja", "-C", "build", "clean"]],
        true
    ),
    new Language(
        "C#",
        "csharp",
        "csharp",
        {},
        [["dotnet", "build", "--configuration", "Release"]],
        "./bin/Release/net7.0/GameOfLife",
        [["dotnet", "clean"]],
        true
    ),
    new Language(
        "Dart",
        "dart",
        "dart",
        {},
        [
            ["dart", "pub", "get"],
            ["dart", "compile", "exe", "bin/game_of_life.dart"],
        ],
        "./bin/game_of_life.exe",
        [["rm", "-f", "./bin/game_of_life.exe"]],
        true
    ),
    new Language(
        "F#",
        "fsharp",
        "fsharp",
        {},
        [["dotnet", "build", "--configuration", "Release"]],
        "./bin/Release/net7.0/GameOfLife",
        [["dotnet", "clean"]],
        true
    ),
    new Language(
        "Go",
        "go",
        "go",
        {},
        [["go", "build", "-ldflags=-s"]],
        "./game_of_life",
        [["rm", "-f", "./game_of_life"]],
        true
    ),
    new Language(
        "Java",
        "java",
        "java",
        {},
        [["./gradlew", "build"]],
        ["java", "-classpath", "app/build/classes/java/main", "gameoflife.App"],
        [["./gradlew", "clean"]],
        true
    ),
    new Language(
        "Julia",
        "julia",
        "julia",
        {},
        [],
        ["julia", "./gameoflife.jl"],
        [],
        true
    ),
    new Language(
        "Lua",
        "lua",
        "lua",
        {},
        [],
        ["lua", "./game_of_life.lua"],
        [],
        true
    ),
    new Language(
        "Nim",
        "nim",
        "nim",
        {},
        [["nim", "compile", "-d:release", "GameOfLife.nim"]],
        "./GameOfLife",
        [["rm", "-f", "./GameOfLife"]],
        true
    ),
    new Language(
        "Perl",
        "perl",
        "perl",
        {},
        [],
        ["perl", "./GameOfLife.pl"],
        [],
        true
    ),
    new Language(
        "PowerShell",
        "powershell",
        "powershell",
        {},
        [],
        ["pwsh", "./Game-Of-Life.ps1"],
        [],
        false
    ),
    new Language(
        "Python",
        "python",
        "python",
        {},
        [],
        ["python", "./game_of_life.py"],
        [],
        true
    ),
    new Language(
        "Ruby",
        "ruby",
        "ruby",
        {},
        [],
        ["ruby", "./GameOfLife.rb"],
        [],
        true
    ),
    new Language(
        "Rust",
        "rust",
        "rust",
        {},
        [["cargo", "build", "--release"]],
        "./target/release/game_of_life",
        [["cargo", "clean"]],
        true
    ),
    new Language(
        "TypeScript",
        "typescript",
        "typescript",
        {},
        [
            ["yarn", "install"],
            ["yarn", "run", "build"],
        ],
        ["node", "build/src/main.js"],
        [["yarn", "run", "clean"]],
        true
    ),
    new Language(
        "Visual Basic",
        "vb",
        "vb",
        {},
        [["dotnet", "build", "--configuration", "Release"]],
        "./bin/Release/net7.0/GameOfLife",
        [["dotnet", "clean"]],
        true
    ),
    new Language(
        "Zig",
        "zig",
        "zig",
        {},
        [["zig", "build", "-Doptimize=ReleaseFast"]],
        "./zig-out/bin/game_of_life",
        [["rm", "-rf", "zig-out", "zig-cache"]],
        true
    ),
];

for (var language of languages) {
    if (language.willRun()) {
        console.log(chalk.cyan(`\n${language.properName}`) + ":");
    }

    language.setEnv();
    if (language.buildCmd.length > 0) {
        await language.build();
    }

    await language.run();

    if (language.cleanCmd.length > 0) {
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

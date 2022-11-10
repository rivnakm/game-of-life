#!/usr/bin/env zx

import "zx/globals";
import { spinner } from "zx/experimental";

import average from "average";
import { stringify } from "csv-stringify/sync";
import { table } from "table";

$.verbose = false;
process.env.TIMEFORMAT = "%R";
let base_dir = await $`pwd`;
base_dir = base_dir.stdout.trim();

async function time(cmd, message) {
    let time = await spinner(message, () => $`time ${cmd} > /dev/null`);
    return parseFloat(time.stderr.trim());
}

let iterations = argv.iterations || argv.i || 5;
let generations = argv.generations || argv.g || 500;
let size = argv.size || argv.s || "100x50";

let result = size.match(/(\d+)x(\d+)/);
let width = result[1];
let height = result[2];

let languages;
if (argv.languages || argv.l) {
    languages = (argv.languages || argv.l).split(",");
} else {
    languages = ["c", "cpp", "csharp", "python", "rust", "typescript"];
}

// Build
console.log(chalk.blue("Building"));
// C
if (languages.includes("c")) {
    cd("c");
    await spinner(
        "Building C ...",
        () =>
            $`CFLAGS="-O2 -pipe" make`
    );
    console.log("    Building C " + chalk.green("DONE"));
    cd(base_dir);
}
// C++
if (languages.includes("cpp")) {
    cd("cpp");
    await spinner(
        "Building C++ ...",
        () =>
            $`meson setup build; meson configure -Dbuildtype=release build; pushd build; ninja; popd`
    );
    console.log("    Building C++ " + chalk.green("DONE"));
    cd(base_dir);
}
// C#
if (languages.includes("csharp")) {
    cd("csharp");
    await spinner(
        "Building C# ...",
        () => $`dotnet build --configuration Release`
    );
    console.log("    Building C# " + chalk.green("DONE"));
    cd(base_dir);
}

// Rust
if (languages.includes("rust")) {
    cd("rust");
    await spinner("Building Rust ...", () => $`cargo build --release`);
    console.log("    Building Rust " + chalk.green("DONE"));
    cd(base_dir);
}

// TypeScript
if (languages.includes("typescript")) {
    cd("typescript");
    await spinner("Building TypeScript ...", () => $`yarn run build`);
    console.log("    Building TypeScript " + chalk.green("DONE"));
    cd(base_dir);
}

// Run Benchmark
const results = new Object();
for (let i = 0; i < iterations; i++) {
    console.log(chalk.blue(`\nPass (${i + 1}/${iterations})`));

    // C
    if (languages.includes("c")) {
        if (i === 0) {
            results["c"] = [];
        }
        results["c"].push(
            await time(
                [
                    "./c/game_of_life",
                    "-g",
                    generations,
                    "-h",
                    height,
                    "-w",
                    width
                ],
                "Running C ..."
            )
        );
        console.log("    Running C " + chalk.green("DONE"));
    }
    
    // C++
    if (languages.includes("cpp")) {
        if (i === 0) {
            results["cpp"] = [];
        }
        results["cpp"].push(
            await time(
                [
                    "./cpp/build/game_of_life",
                    "--generations",
                    generations,
                    "--size",
                    size,
                ],
                "Running C++ ..."
            )
        );
        console.log("    Running C++ " + chalk.green("DONE"));
    }

    // C#
    if (languages.includes("csharp")) {
        if (i === 0) {
            results["csharp"] = [];
        }
        results["csharp"].push(
            await time(
                [
                    "./csharp/bin/Release/net6.0/GameOfLife",
                    "--generations",
                    generations,
                    "--size",
                    size,
                ],
                "Running C# ..."
            )
        );
        console.log("    Running C# " + chalk.green("DONE"));
    }

    // Python
    if (languages.includes("python")) {
        if (i === 0) {
            results["python"] = [];
        }
        results["python"].push(
            await time(
                [
                    "python",
                    "python/game_of_life.py",
                    "--generations",
                    generations,
                    "--size",
                    size,
                ],
                "Running Python ..."
            )
        );
        console.log("    Running Python " + chalk.green("DONE"));
    }

    // Rust
    if (languages.includes("rust")) {
        if (i === 0) {
            results["rust"] = [];
        }
        results["rust"].push(
            await time(
                [
                    "rust/target/release/game_of_life",
                    "--generations",
                    generations,
                    "--size",
                    size,
                ],
                "Running Rust ..."
            )
        );
        console.log("    Running Rust " + chalk.green("DONE"));
    }

    // Typescript
    if (languages.includes("typescript")) {
        if (i === 0) {
            results["typescript"] = [];
        }
        results["typescript"].push(
            await time(
                [
                    "node",
                    "typescript/build/src/main.js",
                    "--generations",
                    generations,
                    "--size",
                    size,
                ],
                "Running TypeScript ..."
            )
        );
        console.log("    Running TypeScript " + chalk.green("DONE"));
    }
}

// Clean

if (argv.noclean === undefined) {
    console.log(chalk.blue("\nCleaning up"));
    // C
    if (languages.includes("c")) {
        cd("c");
        await spinner("Cleaning up C ...", () => $`make clean`);
        console.log("    Cleaning up C " + chalk.green("DONE"));
        cd(base_dir);
    }
    // C++
    if (languages.includes("cpp")) {
        cd("cpp/build");
        await spinner("Cleaning up C++ ...", () => $`ninja clean`);
        console.log("    Cleaning up C++ " + chalk.green("DONE"));
        cd(base_dir);
    }
    // C#
    if (languages.includes("csharp")) {
        cd("csharp");
        await spinner("Cleaning up C# ...", () => $`dotnet clean`);
        console.log("    Cleaning up C# " + chalk.green("DONE"));
        cd(base_dir);
    }

    // Rust
    if (languages.includes("rust")) {
        cd("rust");
        await spinner("Cleaning up Rust ...", () => $`cargo clean`);
        console.log("    Cleaning up Rust " + chalk.green("DONE"));
        cd(base_dir);
    }

    // TypeScript
    if (languages.includes("typescript")) {
        cd("typescript");
        await spinner("Cleaning up TypeScript ...", () => $`yarn run clean`);
        console.log("    Cleaning up TypeScript " + chalk.green("DONE"));
        cd(base_dir);
    }
}

// Print results
console.log();
const averages = [];
for (const [key, value] of Object.entries(results)) {
    let result = average(value);
    averages.push([key, result.toFixed(3)]);
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
console.log(`${generations} generations (average of ${iterations})`);
console.log(table(averages));

const output = stringify(averages);
fs.writeFile("benchmark_results.csv", output, (err) => {
    if (err) {
        console.error(err);
    }
    // file written successfully
});

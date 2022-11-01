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
let generations = argv.generation || argv.g || 500;
let size = argv.size || argv.s || "100x50";

// Build
console.log(chalk.blue("Building"));
// C#
cd("csharp");
await spinner("Building C# ...", () => $`dotnet build --configuration Release`);
console.log("    Building C# " + chalk.green("DONE"));
cd(base_dir);

// Rust
cd("rust");
await spinner("Building Rust ...", () => $`cargo build --release`);
console.log("    Building Rust " + chalk.green("DONE"));
cd(base_dir);

// Run Benchmark
const results = new Object();
for (let i = 0; i < iterations; i++) {
    console.log(chalk.blue(`\nPass (${i + 1}/${iterations})`));

    // C#
    if (i === 0) {
        results["csharp"] = [];
    }
    results["csharp"].push(
        await time(
            [
                "./csharp/bin/Release/net6.0/GameOfLife",
                "--iterations",
                generations,
                "--size",
                size,
            ],
            "Running C# ..."
        )
    );
    console.log("    Running C# " + chalk.green("DONE"));

    // Python
    if (i === 0) {
        results["python"] = [];
    }
    results["python"].push(
        await time(
            [
                "python",
                "python/game_of_life.py",
                "--iterations",
                generations,
                "--size",
                size,
            ],
            "Running Python ..."
        )
    );
    console.log("    Running Python " + chalk.green("DONE"));

    // Rust
    if (i === 0) {
        results["rust"] = [];
    }
    results["rust"].push(
        await time(
            [
                "rust/target/release/game_of_life",
                "--iterations",
                generations,
                "--size",
                size,
            ],
            "Running Rust ..."
        )
    );
    console.log("    Running Rust " + chalk.green("DONE"));
}

// Clean
console.log(chalk.blue("\nCleaning up"));
// C#
cd("csharp");
await spinner("Cleaning up C# ...", () => $`dotnet clean`);
console.log("    Cleaning up C# " + chalk.green("DONE"));
cd(base_dir);

// Rust
cd("rust");
await spinner("Cleaning up Rust ...", () => $`cargo clean`);
console.log("    Cleaning up Rust " + chalk.green("DONE"));
cd(base_dir);

// Print results
console.log();
const averages = [["language", "avg time (s)"]];
for (const [key, value] of Object.entries(results)) {
    let result = average(value);
    averages.push([key, result.toPrecision(3)]);
}
console.log(`${generations} generations (average of ${iterations})`);
console.log(table(averages));

const output = stringify(averages);
fs.writeFile("benchmark_results.csv", output, (err) => {
    if (err) {
        console.error(err);
    }
    // file written successfully
});

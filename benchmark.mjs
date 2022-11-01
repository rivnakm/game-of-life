#!/usr/bin/env zx

import "zx/globals";
import { spinner } from "zx/experimental";

import average from "average";
import { stringify } from "csv-stringify/sync";
import { table } from "table";

$.verbose = true;
process.env.TIMEFORMAT = "%R";
let base_dir = await $`pwd`;
base_dir = base_dir.stdout.trim();

async function time(cmd, message) {
    let time = await spinner(message, () => $`time ${cmd} > /dev/null`);
    return parseFloat(time.stderr.trim());
}

let iterations = argv.iterations || argv.i || 2;
let generations = argv.generation || argv.g || 100;
let size = argv.size || argv.s || "100x50";

// Build
cd("csharp");
await spinner("Building C# ...", () => $`dotnet build --configuration Release`);
cd(base_dir);

// Run Benchmark
const results = new Object();
for (let i = 0; i < iterations; i++) {
    console.log(`Running pass ${i + 1} of ${iterations}`);

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
}

const averages = [["language", "avg time (s)"]];
for (const [key, value] of Object.entries(results)) {
    let result = average(value);
    averages.push([key, result.toPrecision(3)]);
}
console.log(table(averages));

const output = stringify(averages);
fs.writeFile("benchmark_results.csv", output, (err) => {
    if (err) {
        console.error(err);
    }
    // file written successfully
});

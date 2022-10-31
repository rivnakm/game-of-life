#!/usr/bin/env zx

import "zx/globals";
import { spinner } from "zx/experimental";


import average from "average";
import { stringify } from "csv-stringify/sync";

$.verbose = true;
process.env.TIMEFORMAT = "%R";

async function time(cmd, message) {
  let time = await spinner(message, () =>$`time ${cmd} > /dev/null`);
  return parseFloat(time.stderr.trim());
}

let iterations = argv.iterations || argv.i || 2;
let generations = argv.generation || argv.g || 100;
let size = argv.size || argv.s || "100x50";

// Build

// Run Benchmark
const results = new Object();
for (let i = 0; i < iterations; i++) {
  console.log(`Running pass ${i + 1} of ${iterations}`);

  if (i === 0) {
    results["python"] = [];
  }
  results["python"].push(
    await time([
      "python",
      "python/game_of_life.py",
      "--iterations",
      generations,
      "--size",
      size,
    ], "Running Python...")
  );
}

console.log(results);
const averages = [{ language: "language", time: "time" }];
for (const [key, value] of Object.entries(results)) {
  let result = average(value)
  averages.push({ language: key, time: result });
}
console.log(averages);

const output = stringify(averages);


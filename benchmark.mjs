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

async function time(cmd, message) {
    let time = await spinner(message, () => $`time ${cmd} > /dev/null`);
    return parseFloat(time.stderr.trim());
}

let iterations = argv.iterations || argv.i || 5;

let languages;
if (argv.languages || argv.l) {
    languages = (argv.languages || argv.l).split(",");
} else {
    languages = [
        "c",
        "cpp",
        "csharp",
        "dart",
        "go",
        "java",
        "lua",
        "nim",
        "perl",
        "python",
        "ruby",
        "rust",
        "typescript",
        "vb",
        "zig",
    ];
}

// Build
console.log(chalk.blue("Building"));
// C
if (languages.includes("c")) {
    cd("c");
    await spinner("Building C ...", () => $`CFLAGS="-O3" make`);
    console.log("    Building C " + chalk.green("DONE"));
    cd(base_dir);
}
// C++
if (languages.includes("cpp")) {
    cd("cpp");
    await spinner(
        "Building C++ ...",
        () =>
            $`meson setup --reconfigure build; meson configure -Dbuildtype=release build; pushd build; ninja; popd`
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
// Dart
if (languages.includes("dart")) {
    cd("dart");
    await spinner(
        "Building Dart ...",
        () => $`dart compile exe bin/game_of_life.dart`
    );
    console.log("    Building Dart " + chalk.green("DONE"));
    cd(base_dir);
}
// Go
if (languages.includes("go")) {
    cd("go");
    await spinner("Building Go ...", () => $`go build -ldflags "-s"`);
    console.log("    Building Go " + chalk.green("DONE"));
    cd(base_dir);
}
// Java
if (languages.includes("java")) {
    cd("java");
    await spinner("Building Java ...", () => $`./gradlew build`);
    console.log("    Building Java " + chalk.green("DONE"));
    cd(base_dir);
}
// Nim
if (languages.includes("nim")) {
    cd("nim");
    await spinner(
        "Building Nim ...",
        () => $`nim compile -d:release GameOfLife.nim`
    );
    console.log("    Building Nim " + chalk.green("DONE"));
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
    await spinner(
        "Building TypeScript ...",
        () => $`yarn install && yarn run build`
    );
    console.log("    Building TypeScript " + chalk.green("DONE"));
    cd(base_dir);
}
// Visual Basic
if (languages.includes("vb")) {
    cd("vb");
    await spinner(
        "Building Visual Basic ...",
        () => $`dotnet build --configuration Release`
    );
    console.log("    Building Visual Basic " + chalk.green("DONE"));
    cd(base_dir);
}
// Zig
if (languages.includes("zig")) {
    cd("zig");
    await spinner("Building Zig ...", () => $`zig build -Drelease-fast`);
    console.log("    Building Zig " + chalk.green("DONE"));
    cd(base_dir);
}

// Run Benchmark
const results = new Object();
for (let i = 0; i < iterations; i++) {
    console.log(chalk.blue(`\nPass (${i + 1}/${iterations})`));

    // Bash
    if (languages.includes("bash")) {
        if (i === 0) {
            results["Bash"] = [];
        }
        results["Bash"].push(await time("./bash/game_of_life.sh", "Running Bash ..."));
        console.log("    Running Bash " + chalk.green("DONE"));
    }

    // C
    if (languages.includes("c")) {
        if (i === 0) {
            results["C"] = [];
        }
        results["C"].push(await time("./c/game_of_life", "Running C ..."));
        console.log("    Running C " + chalk.green("DONE"));
    }

    // C++
    if (languages.includes("cpp")) {
        if (i === 0) {
            results["C++"] = [];
        }
        results["C++"].push(
            await time("./cpp/build/game_of_life", "Running C++ ...")
        );
        console.log("    Running C++ " + chalk.green("DONE"));
    }

    // C#
    if (languages.includes("csharp")) {
        if (i === 0) {
            results["C#"] = [];
        }
        results["C#"].push(
            await time(
                "./csharp/bin/Release/net7.0/GameOfLife",
                "Running C# ..."
            )
        );
        console.log("    Running C# " + chalk.green("DONE"));
    }

    // Dart
    if (languages.includes("dart")) {
        if (i === 0) {
            results["Dart"] = [];
        }
        results["Dart"].push(
            await time("./dart/bin/game_of_life.exe", "Running Dart ...")
        );
        console.log("    Running Dart " + chalk.green("DONE"));
    }

    // Go
    if (languages.includes("go")) {
        if (i === 0) {
            results["Go"] = [];
        }
        results["Go"].push(await time("./go/game_of_life", "Running Go ..."));
        console.log("    Running Go " + chalk.green("DONE"));
    }

    // Java
    if (languages.includes("java")) {
        if (i === 0) {
            results["Java"] = [];
        }
        results["Java"].push(
            await time(
                [
                    "java",
                    "-classpath",
                    "java/app/build/classes/java/main",
                    "gameoflife.App",
                ],
                "Running Java ..."
            )
        );
        console.log("    Running Java " + chalk.green("DONE"));
    }

    // Lua
    if (languages.includes("lua")) {
        if (i === 0) {
            results["Lua"] = [];
        }
        results["Lua"].push(
            await time(["lua", "./lua/game_of_life.lua"], "Running Lua ...")
        );
        console.log("    Running Lua " + chalk.green("DONE"));
    }

    // Nim
    if (languages.includes("nim")) {
        if (i === 0) {
            results["Nim"] = [];
        }
        results["Nim"].push(await time("./nim/GameOfLife", "Running Nim ..."));
        console.log("    Running Nim " + chalk.green("DONE"));
    }

    // Perl
    if (languages.includes("perl")) {
        if (i === 0) {
            results["Perl"] = [];
        }
        results["Perl"].push(
            await time(
                ["perl", "perl/GameOfLife.pl"],
                "Running Perl ..."
            )
        );
        console.log("    Running Perl " + chalk.green("DONE"));
    }

    // Powershell
    if (languages.includes("powershell")) {
        if (i === 0) {
            results["PowerShell"] = [];
        }
        results["PowerShell"].push(
            await time(
                ["pwsh", "powershell/Game-Of-Life.ps1"],
                "Running PowerShell ..."
            )
        );
        console.log("    Running PowerShell " + chalk.green("DONE"));
    }

    // Python
    if (languages.includes("python")) {
        if (i === 0) {
            results["Python"] = [];
        }
        results["Python"].push(
            await time(
                ["python", "python/game_of_life.py"],
                "Running Python ..."
            )
        );
        console.log("    Running Python " + chalk.green("DONE"));
    }

    // Ruby
    if (languages.includes("ruby")) {
        if (i === 0) {
            results["Ruby"] = [];
        }
        results["Ruby"].push(
            await time(["ruby", "ruby/GameOfLife.rb"], "Running Ruby ...")
        );
        console.log("    Running Ruby " + chalk.green("DONE"));
    }

    // Rust
    if (languages.includes("rust")) {
        if (i === 0) {
            results["Rust"] = [];
        }
        results["Rust"].push(
            await time("rust/target/release/game_of_life", "Running Rust ...")
        );
        console.log("    Running Rust " + chalk.green("DONE"));
    }

    // Typescript
    if (languages.includes("typescript")) {
        if (i === 0) {
            results["TypeScript"] = [];
        }
        results["TypeScript"].push(
            await time(
                ["node", "typescript/build/src/main.js"],
                "Running TypeScript ..."
            )
        );
        console.log("    Running TypeScript " + chalk.green("DONE"));
    }

    // Visual Basic
    if (languages.includes("vb")) {
        if (i === 0) {
            results["Visual Basic"] = [];
        }
        results["Visual Basic"].push(
            await time(
                "./vb/bin/Release/net7.0/GameOfLife",
                "Running Visual Basic ..."
            )
        );
        console.log("    Running Visual Basic " + chalk.green("DONE"));
    }

    // Zig
    if (languages.includes("zig")) {
        if (i === 0) {
            results["Zig"] = [];
        }
        results["Zig"].push(
            await time("zig/zig-out/bin/game_of_life", "Running Zig ...")
        );
        console.log("    Running Zig " + chalk.green("DONE"));
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

    // Dart
    if (languages.includes("dart")) {
        cd("dart");
        await spinner(
            "Cleaning up Dart ...",
            () => $`rm -rf ./bin/game_of_life.exe`
        );
        console.log("    Cleaning up Dart " + chalk.green("DONE"));
        cd(base_dir);
    }

    // Go
    if (languages.includes("go")) {
        cd("go");
        await spinner("Cleaning up Go ...", () => $`rm -f game_of_life`);
        console.log("    Cleaning up Go " + chalk.green("DONE"));
        cd(base_dir);
    }

    // Java
    if (languages.includes("java")) {
        cd("java");
        await spinner("Cleaning up Java ...", () => $`gradle clean`);
        console.log("    Cleaning up Java " + chalk.green("DONE"));
        cd(base_dir);
    }

    // Nim
    if (languages.includes("nim")) {
        cd("nim");
        await spinner("Cleaning up Nim ...", () => $`rm -f GameOfLife`);
        console.log("    Cleaning up Nim " + chalk.green("DONE"));
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

    // Visual Basic
    if (languages.includes("vb")) {
        cd("vb");
        await spinner("Cleaning up Visual Basic ...", () => $`dotnet clean`);
        console.log("    Cleaning up Visual Basic " + chalk.green("DONE"));
        cd(base_dir);
    }

    // Zig
    if (languages.includes("zig")) {
        cd("zig");
        await spinner("Cleaning up Zig ...", () => $`rm -rf zig-out zig-cache`);
        console.log("    Cleaning up Zig " + chalk.green("DONE"));
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
console.log(`500 generations (average of ${iterations})`);
console.log(table(averages));

const output = stringify(averages);
fs.writeFile("benchmark_results.csv", output, (err) => {
    if (err) {
        console.error(err);
    }
    // file written successfully
});

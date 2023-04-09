#!/usr/bin/env zx

import "zx/globals";

$.verbose = false;

let software = [
    { name: ".NET SDK", versionCmd: ["dotnet", "--version"] },
    { name: "Bash", versionCmd: ["bash", "--version"] },
    { name: "Cargo", versionCmd: ["cargo", "--version"] },
    { name: "Dart SDK", versionCmd: ["dart", "--version"] },
    { name: "G++", versionCmd: ["g++", "--version"] },
    { name: "GCC", versionCmd: ["gcc", "--version"] },
    { name: "GDC", versionCmd: ["gdc", "--version"] },
    { name: "GHC", versionCmd: ["ghc", "--version"] },
    { name: "Gnat", versionCmd: ["gnat", "--version"] },
    { name: "Go", versionCmd: ["go", "version"] },
    { name: "Gradle", versionCmd: ["gradle", "--version"] },
    { name: "Java", versionCmd: ["java", "--version"] },
    { name: "Julia", versionCmd: ["julia", "--version"] },
    { name: "Lua", versionCmd: ["lua", "-v"] },
    { name: "Make", versionCmd: ["make", "--version"] },
    { name: "Meson", versionCmd: ["meson", "--version"] },
    { name: "Nim", versionCmd: ["nim", "--version"] },
    { name: "Ninja", versionCmd: ["ninja", "--version"] },
    { name: "Node.js", versionCmd: ["node", "--version"] },
    { name: "npm", versionCmd: ["npm", "--version"] },
    { name: "Perl", versionCmd: ["perl", "--version"] },
    { name: "PowerShell", versionCmd: ["pwsh", "--version"] },
    { name: "Python", versionCmd: ["python", "--version"] },
    { name: "Ruby", versionCmd: ["ruby", "--version"] },
    { name: "Rust", versionCmd: ["rustc", "--version"] },
    { name: "V", versionCmd: ["v", "--version"] },
    { name: "Zig", versionCmd: ["zig", "version"] },
];

let success = true;

for (var item of software) {
    try {
        await $`${item.versionCmd}`
        console.log(chalk.green(`${item.name} is installed`))
    }
    catch {
        console.log(chalk.red(`Error: ${item.name} is not installed`))
        success = false;
    }
}

if (!success) {
    process.exit(1);
}
# Conway's Game of Life

### Conway's Game of Life in an many programming languages as I can figure out

![C](https://img.shields.io/badge/c-%2300599C.svg?style=for-the-badge&logo=c&logoColor=white)
![C++](https://img.shields.io/badge/c++-%2300599C.svg?style=for-the-badge&logo=c%2B%2B&logoColor=white)
![C#](https://img.shields.io/badge/c%23-%23239120.svg?style=for-the-badge&logo=.net&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Go](https://img.shields.io/badge/go-%2300ADD8.svg?style=for-the-badge&logo=go&logoColor=white)
![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)
![Nim](https://img.shields.io/badge/nim-%23FFE953.svg?style=for-the-badge&logo=nim&logoColor=black)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white)
![Rust](https://img.shields.io/badge/rust-%23000000.svg?style=for-the-badge&logo=rust&logoColor=white)
![TypeScript](https://img.shields.io/badge/typescript-%23007ACC.svg?style=for-the-badge&logo=typescript&logoColor=white)
![Zig](https://img.shields.io/badge/Zig-%23F7A442.svg?style=for-the-badge&logo=zig&logoColor=black)

<!-- ![Assembly](https://img.shields.io/badge/Assembly-black?style=for-the-badge&logo=arm&logoColor=white)
![Fortran](https://img.shields.io/badge/D-AA0000.svg?style=for-the-badge&logo=d&logoColor=white)
![Elixir](https://img.shields.io/badge/elixir-%234B275F.svg?style=for-the-badge&logo=elixir&logoColor=white)
![F#](https://img.shields.io/badge/f%23-%23239120.svg?style=for-the-badge&logo=.net&logoColor=white)
![Fortran](https://img.shields.io/badge/Fortran-%23734F96.svg?style=for-the-badge&logo=fortran&logoColor=white)
![Go](https://img.shields.io/badge/go-%2300ADD8.svg?style=for-the-badge&logo=go&logoColor=white)
![Haskell](https://img.shields.io/badge/Haskell-5e5086?style=for-the-badge&logo=haskell&logoColor=white)
![Julia](https://img.shields.io/badge/-Julia-9558B2?style=for-the-badge&logo=julia&logoColor=white)
![Perl](https://img.shields.io/badge/perl-%2339457E.svg?style=for-the-badge&logo=perl&logoColor=white)
-->

The games are all setup to run a 100x50 (WxH) board for 500 generations. Most of them were originally written to be dynamic and find the terminal
size or accept arguments but it was taking too much work to get all of that set up for each language and (imo) distracting from the purpose of this
by shifting half of the work onto random argument parsing libraries rather than the languages themselves.

## Prerequisites

<!-- - Assembly
  - GNU Binutils (as & ld)
  - Raspberry Pi 4
 - D
  - GCC (GDC)
- Elixir
- F#
  - .NET SDK
- Fortran
  - GCC (gfortran)
- Haskell
  - GHC
- Julia
- Perl -->
- C
  - GCC
  - GNU Make
- C++
  - GCC
  - Meson
  - Ninja
- C#
  - .NET 7.0 SDK
- Dart
- Go
- Lua
- Nim
- Python
- Ruby
- Rust
  - Cargo
- Typescript
  - Node.js
  - Yarn
- Zig

## Building from Source

<!-- ### Assembly

This is written for a Raspberry Pi 4 running aarch64 Linux

```sh
cd asm/
make
./game_of_life
``` -->

### C

```sh
cd c/
make
./game_of_life
```

### C++

```sh
cd cpp/
meson setup build
cd build
ninja
./game_of_life
```

### C\#

```sh
cd csharp/
dotnet run
```

### Dart

```sh
cd dart/
dart run
```

<!-- ### Elixir

```sh
cd elixir/
elixir game_of_life.exs
```

### F\#

```sh
cd fsharp/
dotnet run
``` -->

### Go

```sh
cd go/
go run .
```

<!--
### Haskell

```sh
cd haskell/
ghc game_of_life.hs
./game_of_life
```

### Julia

```sh
cd julia/
julia game_of_life.jl
``` -->

### Lua

```sh
cd lua/
lua game_of_life.lua
```

### Nim

```sh
cd nim/
nim c -r GameOfLife.nim
```

### Python

```sh
cd python/
python game_of_life.py
```

### Ruby

```sh
cd ruby/
ruby GameOfLife.rb
```

### Rust

```sh
cd rust/
cargo run
```

### Typescript

```sh
cd typescript/
yarn install
yarn run start
```

### Zig

```sh
cd zig/
zig build run
```

## Benchmarking

There's an included script to build all version and run benchmarks. It requires [zx](https://github.org/google/zx) to run

```sh
zx --install benchmark.mjs
```

`--install` is only needed on the first run to install the script's dependencies

You can also specify how many iterations to run the benchmark (default 5), averaging the results

```sh
zx benchmark.mjs --iterations 5
```

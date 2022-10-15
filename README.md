# Conway's Game of Life

![Assembly](https://img.shields.io/badge/Assembly-black?style=for-the-badge&logo=arm&logoColor=white)
![C](https://img.shields.io/badge/c-%2300599C.svg?style=for-the-badge&logo=c&logoColor=white)
![C#](https://img.shields.io/badge/c%23-%23239120.svg?style=for-the-badge&logo=.net&logoColor=white)
![C++](https://img.shields.io/badge/c++-%2300599C.svg?style=for-the-badge&logo=c%2B%2B&logoColor=white)
![Elixir](https://img.shields.io/badge/elixir-%234B275F.svg?style=for-the-badge&logo=elixir&logoColor=white)
![F#](https://img.shields.io/badge/f%23-%23239120.svg?style=for-the-badge&logo=.net&logoColor=white)
![Go](https://img.shields.io/badge/go-%2300ADD8.svg?style=for-the-badge&logo=go&logoColor=white)
![Haskell](https://img.shields.io/badge/Haskell-5e5086?style=for-the-badge&logo=haskell&logoColor=white)
![Julia](https://img.shields.io/badge/-Julia-9558B2?style=for-the-badge&logo=julia&logoColor=white)
![Nim](https://img.shields.io/badge/nim-%23FFE953.svg?style=for-the-badge&logo=nim&logoColor=black)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white)
![Rust](https://img.shields.io/badge/rust-%23000000.svg?style=for-the-badge&logo=rust&logoColor=white)
![TypeScript](https://img.shields.io/badge/typescript-%23007ACC.svg?style=for-the-badge&logo=typescript&logoColor=white)
![Zig](https://img.shields.io/badge/Zig-%23F7A41D.svg?style=for-the-badge&logo=zig&logoColor=white)

![CMake](https://img.shields.io/badge/CMake-%23008FBA.svg?style=for-the-badge&logo=cmake&logoColor=white)

Conway's Game of Life in an many programming languages as I can figure out

## Prerequisites

- Assembly
  - GNU Binutils (as & ld)
  - Raspberry Pi 4
- C
  - GCC
- C++
  - CMake
  - GCC
- C#
  - .NET SDK
- Elixir
- F#
  - .NET SDK
- Go
- Haskell
  - GHC
- Julia
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

### Assembly

This is written for a Raspberry Pi 4 running aarch64 Linux

```sh
cd asm/
make
./game_of_life
```

### C

```sh
cd c/
make
./game_of_life
```

### C++

```sh
cd cpp/
cmake .
make
./game_of_life
```

### C\#

```sh
cd csharp/
dotnet run
```

### Elixir

```sh
cd elixir/
elixir game_of_life.exs
```

### F\#

```sh
cd fsharp/
dotnet run
```

### Go

```sh
cd go/
go run .
```

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
```

### Python

```sh
cd python/
python game_of_life.py
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
yarn run main
```

### Zig

TODO:

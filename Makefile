all: ada c cpp csharp d dart fsharp go haskell java kotlin nim rust typescript vb zig

ada:
	$(MAKE) -C ada

bash:
	# Nothing to do

c:
	$(MAKE) -C c gcc clang

cpp:
	$(MAKE) -C cpp gcc clang

csharp:
	$(MAKE) -C csharp

d:
	$(MAKE) -C d

dart:
	$(MAKE) -C dart

fsharp:
	$(MAKE) -C fsharp

go:
	$(MAKE) -C go

haskell:
	$(MAKE) -C haskell

java:
	$(MAKE) -C java

julia:
	# Nothing to do

kotlin:
	$(MAKE) -C kotlin

lua:
	# Nothing to do

nim:
	$(MAKE) -C nim

perl:
	# Nothing to do

php:
	# Nothing to do

powershell:
	# Nothing to do

python:
	# Nothing to do

ruby:
	# Nothing to do

rust:
	$(MAKE) -C rust
	$(MAKE) -C rust-alt

typescript:
	$(MAKE) -C typescript

vb:
	$(MAKE) -C vb

zig:
	$(MAKE) -C zig

clean:
	$(MAKE) -C ada clean
	$(MAKE) -C c clean
	$(MAKE) -C cpp clean
	$(MAKE) -C csharp clean
	$(MAKE) -C d clean
	$(MAKE) -C dart clean
	$(MAKE) -C fsharp clean
	$(MAKE) -C go clean
	$(MAKE) -C haskell clean
	$(MAKE) -C java clean
	$(MAKE) -C kotlin clean
	$(MAKE) -C nim clean
	$(MAKE) -C rust clean
	$(MAKE) -C rust-alt clean
	$(MAKE) -C typescript clean
	$(MAKE) -C vb clean
	$(MAKE) -C zig clean

.PHONY: all ada bash c cpp csharp cython d dart fsharp go haskell java julia lua nim perl php powershell python ruby rust typescript vb zig clean
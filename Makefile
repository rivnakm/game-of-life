all: ada c cobol cpp csharp cython d dart fsharp go haskell java nim ocaml rust typescript vb zig

ada:
	$(MAKE) -C ada

bash:
	# Nothing to do

c:
	$(MAKE) -C c

cobol:
	$(MAKE) -C cobol

cpp:
	$(MAKE) -C cpp

csharp:
	$(MAKE) -C csharp

cython:
	$(MAKE) -C cython

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

lua:
	# Nothing to do

nim:
	$(MAKE) -C nim

ocaml:
	$(MAKE) -C ocaml

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

typescript:
	$(MAKE) -C typescript

vb:
	$(MAKE) -C vb

zig:
	$(MAKE) -C zig

clean:
	$(MAKE) -C ada clean
	$(MAKE) -C c clean
	$(MAKE) -C cobol clean
	$(MAKE) -C cpp clean
	$(MAKE) -C csharp clean
	$(MAKE) -C cython clean
	$(MAKE) -C d clean
	$(MAKE) -C dart clean
	$(MAKE) -C fsharp clean
	$(MAKE) -C go clean
	$(MAKE) -C haskell clean
	$(MAKE) -C java clean
	$(MAKE) -C nim clean
	$(MAKE) -C ocaml clean
	$(MAKE) -C rust clean
	$(MAKE) -C typescript clean
	$(MAKE) -C vb clean
	$(MAKE) -C zig clean

.PHONY: all ada bash c cobol cpp csharp cython d dart fsharp go haskell java julia lua nim ocaml perl php powershell python ruby rust typescript vb zig clean
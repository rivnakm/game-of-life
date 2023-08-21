CFLAGS ?= -O3

all: gcc
gcc:
	gcc ${CFLAGS} src/main.c -o main.gcc.o -c -I include
	gcc ${CFLAGS} src/game.c -o game.gcc.o -c -I include
	gcc ${CFLAGS} -o game_of_life_gcc main.gcc.o game.gcc.o
	strip -s game_of_life_gcc

clang:
	clang ${CFLAGS} src/main.c -o main.clang.o -c -I include
	clang ${CFLAGS} src/game.c -o game.clang.o -c -I include
	clang ${CFLAGS} -o game_of_life_clang main.clang.o game.clang.o
	strip -s game_of_life_clang

clean:
	rm -f *.o
	rm -f game_of_life
CFLAGS ?= -O3 -march=native

all: gcc clang
gcc:
	gcc ${CFLAGS} -o game_of_life_gcc src/main.c
	strip -s game_of_life_gcc

clang:
	clang ${CFLAGS} -o game_of_life_clang src/main.c
	strip -s game_of_life_clang

clean:
	rm -f *.o
	rm -f game_of_life_gcc game_of_life_clang

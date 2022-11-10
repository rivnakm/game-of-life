CC ?= gcc

all:
	$(CC) ${CFLAGS} src/main.c -o main.o -c -I include
	$(CC) ${CFLAGS} src/game.c -o game.o -c -I include
	$(CC) ${CFLAGS} -o game_of_life main.o game.o

clean:
	rm -f *.o
	rm -f game_of_life
build:
	as -march=armv8-a+crc -mcpu=cortex-a72 game_of_life.s -o game_of_life.o
	ld game_of_life.o -o game_of_life

clean:
	rm -f game_of_life.o
	rm -f game_of_life
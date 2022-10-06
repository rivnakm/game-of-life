build:
	as -march=armv8-a+crc -mtune=cortex-a72 game_of_life.s -o game_of_life.o
	ld game_of_life.o game_of_life

clean:
	rm game_of_life.o
	rm game_of_life
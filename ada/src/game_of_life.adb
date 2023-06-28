with GAME;
procedure GAME_OF_LIFE is
    HEIGHT      : constant INTEGER := 50;
    WIDTH       : constant INTEGER := 100;
    GENERATIONS : constant INTEGER := 500;
begin

    GAME.RUN_GAME(HEIGHT, WIDTH, GENERATIONS);
end GAME_OF_LIFE;
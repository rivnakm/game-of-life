package GAME is
    type CELL is (ALIVE, DEAD);
    type GRID is array(INTEGER range <>) of CELL;
    function GET_CELL(BOARD : GRID; HEIGHT, WIDTH, ROW, COL : INTEGER) return CELL;
    procedure RUN_GAME(HEIGHT, WIDTH, GENERATIONS : INTEGER);
    procedure NEXT_GENERATION(BOARD : in out GRID; HEIGHT, WIDTH : INTEGER);
    procedure DRAW_SCREEN(BOARD : GRID; HEIGHT, WIDTH : INTEGER);
end GAME;
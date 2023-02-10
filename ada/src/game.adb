with ADA.TEXT_IO; use ADA.TEXT_IO;
with ADA.INTEGER_TEXT_IO; use ADA.INTEGER_TEXT_IO;
with ADA.NUMERICS.DISCRETE_RANDOM;
with ADA.CHARACTERS.LATIN_1;

package body GAME is
    procedure RUN_GAME(HEIGHT, WIDTH, GENERATIONS : INTEGER) is
        SIZE : constant INTEGER := HEIGHT * WIDTH;
        BOARD : GRID(0..SIZE);
        package RANDOM_CELL is new ADA.NUMERICS.DISCRETE_RANDOM (CELL);
        use RANDOM_CELL;
        G : GENERATOR;
    begin
        ADA.INTEGER_TEXT_IO.DEFAULT_WIDTH := 0;

        for I in 0 .. SIZE-1 loop
            BOARD(I) := RANDOM(G);
        end loop;

        for I in 1 .. GENERATIONS loop
            DRAW_SCREEN(BOARD, HEIGHT, WIDTH);
            PUT(ADA.CHARACTERS.LATIN_1.ESC & "["); PUT(HEIGHT); PUT("A");
            NEXT_GENERATION(BOARD, HEIGHT, WIDTH);
        end loop;
    end RUN_GAME;

    function GET_CELL(BOARD : GRID; HEIGHT, WIDTH, ROW, COL : INTEGER) return CELL is
    begin
        if (ROW >= 0 and COL >= 0 and ROW < HEIGHT and COL < WIDTH) then
            return BOARD(ROW * WIDTH + COL);
        else
            return DEAD;
        end if;
    end GET_CELL;

    procedure NEXT_GENERATION(BOARD : in out GRID; HEIGHT, WIDTH : INTEGER) is
        SIZE : constant INTEGER := HEIGHT * WIDTH;
        BOARD_COPY : GRID(0..SIZE);
        CURRENT : CELL;
        ADJACENT : INTEGER;
    begin
        for I in 0 .. SIZE-1 loop
            BOARD_COPY(I) := BOARD(I);
        end loop;

        for I in 0 .. HEIGHT-1 loop
            for J in 0 .. WIDTH-1 loop
                CURRENT := GET_CELL(BOARD_COPY, HEIGHT, WIDTH, I, J);
                ADJACENT := 0;

                for N in -1 .. 1 loop
                    for M in -1 .. 1 loop
                        if (not (N = 0 and M = 0)) and GET_CELL(BOARD_COPY, HEIGHT, WIDTH, I + N, J + M) = ALIVE then
                            ADJACENT := ADJACENT + 1;
                        end if;
                    end loop;
                end loop;

                if CURRENT = ALIVE then
                    if ADJACENT < 2 then
                        CURRENT := DEAD;
                    elsif ADJACENT > 3 then
                        CURRENT := DEAD;
                    end if;
                else
                    if ADJACENT = 3 then
                        CURRENT := ALIVE;
                    end if;
                end if;

                BOARD(I * WIDTH + J) := CURRENT;
                        
            end loop;
        end loop;
    end NEXT_GENERATION;
    
    procedure DRAW_SCREEN(BOARD : GRID; HEIGHT, WIDTH : INTEGER) is
    begin
        for I in 0 .. HEIGHT-1 loop
            for J in 0 .. WIDTH-1 loop
                if BOARD(I * WIDTH + J) = ALIVE then
                    PUT("██");
                else
                    PUT("  ");
                end if;
            end loop;
            PUT_LINE("");
        end loop;
    end DRAW_SCREEN;
end GAME;
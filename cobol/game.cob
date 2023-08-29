       IDENTIFICATION DIVISION.
       PROGRAM-ID. GAME-OF-LIFE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 HEIGHT PIC 9(2) VALUE 50.
       01 WIDTH PIC 9(3) VALUE 100.
       01 BOARD-SIZE PIC 9(4) VALUE 5000.
       01 GENERATIONS PIC 9(3) VALUE 500.
       01 CELLS-TABLE.
           05 CELLS-A PIC 9 OCCURS 5000 TIMES.
           05 CELLS-B PIC 9 OCCURS 5000 TIMES.
       01 SEED PIC 9(9) VALUE 123456789.
       01 RAND PIC 9(9).
       01 F PIC 9(4).
       01 G PIC 9(4).
       01 I PIC 9(3).
       01 J PIC 9(3).
       01 N PIC 9(3).
       01 M PIC 9(3).
       01 K PIC 9(3).
       01 L PIC 9(3).
       01 RESULT PIC 9.
       01 CELL PIC 9.
       01 ADJ PIC 9.
       01 ESC PIC X VALUE X"1B".
           
       PROCEDURE DIVISION.
           PERFORM VARYING F FROM 1 BY 1 UNTIL F > BOARD-SIZE
               COMPUTE SEED = SEED * 4848 + 1
               COMPUTE RAND = FUNCTION MOD(SEED, 90) + 2
               
               IF RAND > 50
                   MOVE 1 TO CELLS-A(F)
               ELSE
                   MOVE 0 TO CELLS-A(F)
               END-IF
           END-PERFORM.

           PERFORM VARYING F FROM 1 BY 1 UNTIL F > GENERATIONS
               PERFORM VARYING I FROM 1 BY 1 UNTIL I > HEIGHT
                   PERFORM VARYING J FROM 1 BY 1 UNTIL J > WIDTH
                       IF CELLS-A((I - 1) * WIDTH + J) = 1
                           DISPLAY "██" WITH NO ADVANCING
                       ELSE
                           DISPLAY "  " WITH NO ADVANCING
                       END-IF
                   END-PERFORM
                   DISPLAY " "
               END-PERFORM

               DISPLAY ESC "[50A" WITH NO ADVANCING

               PERFORM VARYING G FROM 1 BY 1 UNTIL G > BOARD-SIZE
                   MOVE CELLS-A(G) TO CELLS-B(G)
               END-PERFORM

               PERFORM VARYING I FROM 1 BY 1 UNTIL I > HEIGHT
                   PERFORM VARYING J FROM 1 BY 1 UNTIL J > WIDTH
                       MOVE I TO N
                       MOVE J TO M
                       PERFORM GET-CELL
                       MOVE RESULT TO CELL
                       MOVE 0 TO ADJ

                       PERFORM COMPUTE-ADJACENT
                       
                       IF CELL = 1
                           IF ADJ < 2
                               MOVE 0 TO CELL
                           END-IF
                           IF ADJ > 3
                               MOVE 0 TO CELL
                           END-IF
                       ELSE
                           IF ADJ = 3
                               MOVE 1 TO CELL
                           END-IF
                       END-IF

                       MOVE CELL TO CELLS-A((I - 1) * WIDTH + J)
                   END-PERFORM
               END-PERFORM
           END-PERFORM.
           STOP RUN.

       GET-CELL.
           IF N >= 1 AND M >= 1 AND N <= HEIGHT AND M <= WIDTH
               MOVE CELLS-B((N - 1) * WIDTH + M) TO RESULT
           ELSE
               MOVE 0 TO RESULT
           END-IF.

       COMPUTE-ADJACENT.
           PERFORM VARYING K FROM 0 BY 1 UNTIL K > 2
               PERFORM VARYING L FROM 0 BY 1 UNTIL L > 2
                   IF K <> 1 OR L <> 1
                       COMPUTE N = I + K - 1
                       COMPUTE M = J + L - 1
                       PERFORM GET-CELL
                       IF RESULT = 1
                           COMPUTE ADJ = ADJ + 1
                       END-IF
                   END-IF
               END-PERFORM
           END-PERFORM.
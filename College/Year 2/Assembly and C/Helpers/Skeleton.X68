
   ORG    $1000
START:                  

INITIALISE:
    MOVE.B #3, DO
    MOVE.B DI

GAME_LOOP:
    CMP.B #1, DO
    BNE GAME_POINTS
    BEQ GAME_OVER

GAME_POINTS:
    ADD.B #10, D1
    SUB.B #1, D0
    BRA GAME_LOOP

GAME OVER:

    SIMHALT            


    END    START    

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

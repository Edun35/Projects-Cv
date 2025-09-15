*-----------------------------------------------------------
* Title      : part2
* Written by : evan dunphy c00303467
* Date       : 17/1/25
* Description: practical 1 part2
*-----------------------------------------------------------
    ORG    $1000
START:               
    MOVE.L #%00001111, D1 ;LOAD IMMEDIATE VALUE INTO D1
    MOVE.B D1, D2 ;COPY BYTE FROM D1 TO D2
    MOVE.B D1, $2000 ;STORE BYTE FROM D1 TO MEMORY LOCATION $2000
    MOVE.B $2000, D2 ;LOAD BYTE FROM MEMORY LOCATION $2000 INTO D2
    MOVE.B $2000, $3000 ; COPY BYTE FROM $2000 TO MEMORY LOCATION $3000

    SIMHALT            


    END    START        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

    ORG    $1000
START:                  
    
    MOVE.B #100, $3000
    MOVE.B #$12, D2
    SUB.B #22, D3
    AND.B D2, D3
    LEA $3000, A1
    SUB.B #20, (A1)
    ADD.B #10, (A1)


    SIMHALT             



    END    START       


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

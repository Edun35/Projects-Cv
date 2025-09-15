*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    
    MOVE.L #%101, D0
    MOVE.L #$101, D1
    MOVE.L #101, D2
    MOVE.L D0, $3030
    MOVE.L D1, $3040
    MOVE.L D2, $3050
    
    MOVE.W #102, $3020
    MOVE.W #$102, $3010
    MOVE.W #%100, $3000
    MOVE.W $3020, D0
    MOVE.W $3010, D1
    MOVE.W $3000, D2
    
    MOVE.B D0, $3020
    MOVE.B D1, $3010
    MOVE.B D2, $3000
    MOVE.B #105, $3020
    MOVE.B #$72, $3010
    MOVE.B #%11111111, $3000
* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

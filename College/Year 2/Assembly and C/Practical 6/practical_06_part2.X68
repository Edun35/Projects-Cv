*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program              
    LEA MESSAGE, A1
    move.b #255, d1
    MOVE.B #0, D0
    TRAP #15
    MOVE.B #1, D0
    TRAP #15
    
    
    MOVE.B #2, D0
    TRAP #15
    
    MOVE.B #4, D0
    TRAP #15
    MOVE.B #3, D0
    TRAP #15
    MOVE.B #5, D0
    TRAP #15
    MOVE.B #6, D0
    TRAP #15
    
    MOVE.B #7, D0
    TRAP #15
    
    MOVE.B #8, D0
    TRAP #15
    
    MOVE.B #11, D0
    TRAP #15
    
    MOVE.B #12, D0
    TRAP #15
    
    LEA MESSAGE, A1
    MOVE.B #13, D0
    TRAP #15
    MOVE.B #14, D0
    TRAP #15
    
    
    MOVE.B #16, D0
    TRAP #15
    
    MOVE.B #17, D0
    TRAP #15
    
    MOVE.B #18, D0
    TRAP #15
    
    MOVE.B #19, D0
    TRAP #15
    
    MOVE.B #20, D0
    TRAP #15
    
    MOVE.B #21, D0
    TRAP #15
    
    MOVE.B #22, D0
    TRAP #15
    
    MOVE.B #9, D0
    TRAP #15
    
   
* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here
MESSAGE DC.B 'TRAP TASK TEST',0 

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

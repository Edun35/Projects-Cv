*-----------------------------------------------------------
* Title      : part 3
* Written by : evan dunphy c00303467
* Date       : 17/1/25
* Description: practical 1 part 3
*-----------------------------------------------------------
    ORG    $1000 ;START CODE AT MEMORY LOCATION $1000
START:                  
    MOVE.B #$64, D1 ;LOAD IMMEDIATE VALUE (100 IN DECIMAL) INTO D1
    LEA text, A1 ;LOAD ADDRESS OF TEXT INTO A1
    MOVE #14, D0 ;LOAD IMMEDIATE VALUE (14) INTO D0
    TRAP #15 ;EXECUTE TRAP (OUTPUT D0 TO CONSOLE
    
    MOVE #3, D0 ;LOAD IMMEDIATE VALUE (3) INTO D0
    TRAP #15 ;EXECUTE TRAP (OUTPUT D0 TO CONSOLE)
    
    SIMHALT ;HALT THE SIMULATION    


text:   dc.b 'Data Register: ',0 ;DEFINE THE STRING 'Data Register: '
    END    START        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

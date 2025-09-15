*-----------------------------------------------------------
* Title      : part 4
* Written by : Evan dunphy c00303467
* Date       : 17/1/25
* Description: practical 1 part 4
*-----------------------------------------------------------
    ORG    $1000    ;START CODE AT MEMORY LOCATION $1000
START:                 
    LEA text, A1    ;LOAD ADDRESS OF text INTO A1
    MOVE #4, D0     ;LOAD IMMEDIATE VALUE (4) INTO D0
    TRAP #15        ;EXECUTE TRAP (OUTPUT D0 TO CONSOLE)
    
    MOVE #14, D0    ;LOAD IMMEDIATE VALUE (14) INTO D0
    TRAP #15        ;EXECUTE TRAP (OUTPUT D0 TO CONSOLE)
    
    MOVE #3, D0     ;LOAD IMMEDIATE VALUE (3) INTO D0
    TRAP #15        ;EXECUTE TRAP (OUTPUT D0 TO CONSOLE)

    SIMHALT             ;HALT THE SIMULATION

text:   dc.b 'Data Register: ', 0   ;DEFINE THE STRING 'Data Register: '

    END    START        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

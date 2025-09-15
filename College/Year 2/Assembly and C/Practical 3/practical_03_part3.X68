*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  
    
    LEA HEALTH, A3
    SUB.B #10, (A3)
     
    SIMHALT        

HEALTH dc.b $64     

    END    START        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

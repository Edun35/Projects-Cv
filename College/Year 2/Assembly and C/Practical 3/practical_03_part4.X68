*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  
    
    LEA HEALTH, A1
    LEA BOSSHEALTH, A2
    
    SUB.B #10, (A2)
    SUB.B #30, (A1)
    
    SUB.B #10, (A2)
    SUB.B #30, (A1)
    
    SUB.B #10, (A2)
    SUB.B #30, (A1)
    
    MOVE.B #100, (A1)
    SUB.B #20, (A1)
    
    SUB.B #30, (A2)
    SUB.B #20, (A1)
    
    SUB.B #10, (A2)
    SUB.B #20, (A1)
    
    SUB.B #10, (A2)
    SUB.B #20, (A1)
    
    SUB.B #10, (A2)
    
    SIMHALT    

HEALTH dc.b $64
BOSSHEALTH dc.b $64  

    END    START        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

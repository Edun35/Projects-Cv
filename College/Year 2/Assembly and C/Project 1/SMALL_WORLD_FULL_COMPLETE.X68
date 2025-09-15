*-------------------------------------------------------------------
* Title      :  SMALL WORLD
* Written by :  EVAN DUNPHY C00303467
* Date       :  1 MARCH 2025
* Description:  A SMALL GAME. MISSION MODE AND ENDLESS MODE.
*               PLAYER EXPLORES A 4*4 RNG MAP. COMPLETE MISSION
*               TO WIN. RNG ENEMY, BOSS, SHOP, FIELD, FOREST, EXIT 
*               IN SOME TILES.
*               ENEMY RESPAWNS ON TILE RE-ENTRY. ENDLESS MODE
*               LEVEL COUNT IS SCORE. QUIT BETWEEN LEVELS.
*               GAME OVER WHEN HEALTH OR STAMINA IS 0.
* 
* Bugs       :  LOAD MAP RNG HAPPENS TO QUICK  OR ADDING DELAY SLOWS GAME DOWN
*               SEEMS LIKE THE PORTAL DOESNT WORK SOMETIMES. PORTAL IS ADDED TO ARRAY
*               BUT WHEN PLAYER GOES THROUGH MAP PORTAL TILE IS NOT THERE.
*------------------------------------------------------------------    
  
*-------------------------------------------------------
*------------------- COMPARISON VALUES 
*-------------------------------------------------------
    ORG    $1000
;ALL
MIN_ALL EQU 0 ;MIN VALUE FOR ALL VARS EXCEPT DICE ROLL
MAX_LEVEL_MISSIONS EQU 1 

;DIRECTION KEYS
W EQU $57 ;77 
A EQU $41 ;61
S EQU $53 ;73
D EQU $44 ;64
ONE EQU $31 ;1
TWO EQU $32 ;2 
THREE EQU $33 ;3
FOUR EQU $34 ; 4

;RNG MISSION
BOSS EQU 0
BOAT EQU 1

;TILES
ENEMY_TILE EQU 1
MOUNTAIN EQU 2
FOREST EQU 3
BEACH EQU 4
TOWN EQU 5
FIELD EQU 6 
EXIT_TILE EQU 7 ;BOAT
BOSS_TILE EQU 8 ;BOSS
PORTAL_TILE EQU 9 ;PORTAL
*-------------------------------------------------------
*------------------- LOAD 
*-------------------------------------------------------
START:              
    LEA START_MSG, A1
    BSR DRAW_STRING 
    BSR DRAW_NEWLINE
    
    BRA MODE

*-------------------------------------------------------
*------------------- PLAY MODE LOOP
*-------------------------------------------------------
    ORG $3000
MODE:
    LEA MODE_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE 
    BSR MODE_INPUT
    
    BRA MODE
    
*-------------------------------------------------------
*------------------- INPUT MISSION CHOICE
*-------------------------------------------------------
MODE_INPUT:
    BSR GET_INPUT
    BSR DRAW_NEWLINE
    CMP #ONE, D1
    BEQ CHECK_MISSION
    
    CMP #TWO, D1
    BEQ ENDLESS
    
    BSR DRAW_NEWLINE
    BSR INVALID_INPUTS
    RTS
    
*-------------------------------------------------------
*------------------- LOAD MISSION MODE AND LOOP 
*-------------------------------------------------------
CHECK_MISSION:
    MOVE.B LEVEL, D1
    CMP #MAX_LEVEL_MISSIONS, D1
    BGT GAME_COMPLETE
    BRA MISSION
    
MISSION:
    BSR DRAW_NEWLINE    
    LEA MISSION_MODE_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    ;RNG MISSION EXIT OR BOSS
    BSR RNG_0_1
    CMP #BOAT, D1 
    BEQ LOAD_BOSS_MAP
    BNE LOAD_BOAT_MAP
    
MISSION_INTRO: 
    LEA WELCOME_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    LEA EQUIP_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    LEA LEARN_HEAL_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    LEA MOVE_COST_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    LEA WASD_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    LEA START_COORD_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    BSR MISSION_PLAYER
    BRA MAP_LOOP
    

*-------------------------------------------------------
*------------------- ENDLESS MODE LOOP
*-------------------------------------------------------    
ENDLESS:
    LEA SURVIVE_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    LEA GAME_OVER_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    BSR ENDLESS_PLAYER
    BRA ENDLESS_LOOP

ENDLESS_LOOP:
    MOVE.B MODE_TEST, D1
    ADD.B #1, D1
    MOVE.B D1, MODE_TEST
  
    BSR RNG_0_1
    CMP #BOSS, D1 
    BEQ LOAD_BOSS_ENDLESS_MAP
    BNE LOAD_PORTAL_MAP
    
ENDLESS_INTRO:
    LEA CURRENT_LEVEL_MSG, A1
    BSR DRAW_STRING
    MOVE.B LEVEL, D1
    BSR DRAW_NUMBER
    BSR DRAW_NEWLINE
    BSR DRAW_NEWLINE
    
    BSR DRAW_HUD
    
    BRA MAP_LOOP
    
    
*-------------------------------------------------------
*------------------- LOAD VALUES INTO MAP 
*-------------------------------------------------------
LOAD_BOSS_ENDLESS_MAP:
    BSR UPDATE_MAP
    
    MOVE.B #4, D5 ;COUNTER
    CLR D2
    LEA MAP_ROW4, A2 ;RELOAD MAP START IN MEMORY
    BSR ADD_BOSS
    
    BSR ADD_CAMP
    BSR ADD_TOWN
    
    ;PLAY BOSS MSG
    LEA DEFEAT_BOSS_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    ;ENDLESS MODE GO TO ENDLESS INMT
    BRA ENDLESS_INTRO   
    
LOAD_BOSS_MAP:
    BSR UPDATE_MAP
    
    MOVE.B #4, D5 ;COUNTER
    CLR D2
    LEA MAP_ROW4, A2 ;RELOAD MAP START IN MEMORY
    BSR ADD_BOSS
    
    BSR ADD_CAMP
    BSR ADD_TOWN
    
    ;PLAY BOSS MSG
    LEA DEFEAT_BOSS_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    LEA GAME_OVER_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    ;ENDLESS MODE GO TO ENDLESS INMT
    BRA MISSION_INTRO    
LOAD_BOAT_MAP:
    BSR UPDATE_MAP
    BSR ADD_EXIT
    
    MOVE.B #4, D5 ;COUNTER
    CLR D2
    LEA MAP_ROW4, A2 ;RELOAD MAP START IN MEMORY
    BSR ADD_EXIT
    
    BSR ADD_CAMP
    BSR ADD_TOWN
    
    ;PLAY BOAT MSG    
    LEA FIND_EXIT_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    LEA GAME_OVER_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    BRA MISSION_INTRO
    
LOAD_PORTAL_MAP:
    BSR UPDATE_MAP
    BSR ADD_CAMP
    BSR ADD_TOWN
    BSR ADD_PORTAL
    
    LEA FIND_EXIT_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    BRA ENDLESS_INTRO

UPDATE_MAP:
    ;ADD TILES TO MAP
    CLR D2
    MOVE.B #4, D5 ;COUNTER
    LEA MAP_ROW1, A2 ;RELOAD MAP START IN MEMORY
    BSR UPDATE_ROW
    
    CLR D2
    MOVE.B #4, D5 ;COUNTER
    LEA MAP_ROW2, A2 ;RELOAD MAP START IN MEMORY
    BSR UPDATE_ROW
    
    CLR D2
    MOVE.B #4, D5 ;COUNTER
    LEA MAP_ROW3, A2 ;RELOAD MAP START IN MEMORY
    BSR UPDATE_ROW
    
    CLR D2
    MOVE.B #4, D5 ;COUNTER
    LEA MAP_ROW4, A2 ;RELOAD MAP START IN MEMORY    
    BSR UPDATE_ROW
    
    RTS
    
UPDATE_ROW:
    MOVE.B (A2), D2 ;GET VALUE
    
    BSR RNG_1_4 ;GET RNG VALUE
    ;NOT CHECKING VALUE
    MOVE.B D1, D2 ;UPDATE VALUE
    MOVE.B D2, (A2)+ ;RE ENTER VALUE
    SUB.B #1, D5 ;COUNTER--
    CMP.B #0, D5 
    BNE UPDATE_ROW ;EXIT LOOP AFTER  
    RTS

*-------------------------------------------------------
*------------------- CLEAN MAP 
*-------------------------------------------------------
ADD_BOSS:
    ;PUT BOSS TILE AT ROW4[3]    
    MOVE.B (A2)+, D2 ;GET VALUE
    
    SUB.B #1, D5 ;COUNTER--
    CMP.B #2, D5 
    BNE ADD_BOSS ;EXIT LOOP AFTER 

    MOVE.B #BOSS_TILE, D2 ;UPDATE VALUE
    MOVE.B D2, (A2) ;RE ENTER VALUE 
    
    RTS
    
ADD_EXIT:
    ;PUT BOAT TILE AT ROW4[3]    
    MOVE.B (A2)+, D2 ;GET VALUE
    
    SUB.B #1, D5 ;COUNTER--
    CMP.B #2, D5 
    BNE ADD_EXIT ;EXIT LOOP AFTER 

    MOVE.B #EXIT_TILE, D2 ;UPDATE VALUE
    MOVE.B D2, (A2) ;RE ENTER VALUE 
    
    RTS
    
ADD_PORTAL:
    MOVE.B #PORTAL_TILE, D6
    ;PUT PORTAL AT RNG TILE ?,?
    BSR RNG_1_4
    ;CHOOSE ROW
    CMP.B #1, D1
    BEQ LOAD_ROW_1
    
    CMP.B #2, D1
    BEQ LOAD_ROW_2

    CMP.B #3, D1
    BEQ LOAD_ROW_3

    CMP.B #4, D1  
    BEQ LOAD_ROW_4
    
ADD_CAMP:
    MOVE.B #FIELD, D6
    ;PUT PORTAL AT RNG TILE ?,?
    BSR RNG_1_3
    ;CHOOSE ROW
    CMP.B #1, D1
    BEQ LOAD_ROW_1
    
    CMP.B #2, D1
    BEQ LOAD_ROW_2

    CMP.B #3, D1
    BEQ LOAD_ROW_3
ADD_TOWN:
    MOVE.B #TOWN, D6
    ;PUT PORTAL AT RNG TILE ?,?
    BSR RNG_1_3
    ;CHOOSE ROW
    CMP.B #1, D1
    BEQ LOAD_ROW_1
    
    CMP.B #2, D1
    BEQ LOAD_ROW_2

    CMP.B #3, D1
    BEQ LOAD_ROW_3
    
LOAD_ROW_1:
    LEA MAP_ROW1, A2 ;RELOAD MAP START IN MEMORY
    BSR RNG_1_3
    MOVE.B D1, D5
    BSR LOAD_VALUE
    RTS
    
LOAD_ROW_2:    
    LEA MAP_ROW2, A2 ;RELOAD MAP START IN MEMORY
    BSR RNG_1_3
    MOVE.B D1, D5
    BSR LOAD_VALUE
    RTS
    
LOAD_ROW_3:
    LEA MAP_ROW3, A2 ;RELOAD MAP START IN MEMORY
    BSR RNG_1_3
    MOVE.B D1, D5
    BSR LOAD_VALUE
    RTS
    
LOAD_ROW_4:
    LEA MAP_ROW4, A2 ;RELOAD MAP START IN MEMORY    
    BSR RNG_1_3
    MOVE.B D1, D5
    BSR LOAD_VALUE
    RTS

LOAD_VALUE:
    ;CHOOSE ROW INDEX  
    MOVE.B (A2)+, D2 ;GET VALUE
    
    SUB.B #1, D5 ;COUNTER--
    CMP.B #0, D5 
    BNE LOAD_VALUE ;EXIT LOOP AFTER 
    
    ;ADD VALUE
    MOVE.B D6, D2 ;UPDATE VALUE
    MOVE.B D2, (A2) ;RE ENTER VALUE 
    
    ;CLEAR D5,D6
    CLR D5
    CLR D6
    RTS
*-------------------------------------------------------
*------------------- LOAD PLAYER AND ITEMS 
*-------------------------------------------------------
MISSION_PLAYER:
    MOVE.B #$64, HEALTH 
    MOVE.B #$64, STAMINA
    MOVE.B #$1, STAMINA_POTIONS
    MOVE.B #$0, CAMPS
    MOVE.B #$0, GOLD
    MOVE.B #$1, SPELL_SLOTS
    MOVE.B #0, PLAYER_X
    MOVE.B #0, PLAYER_Y
    RTS
    
ENDLESS_PLAYER:
    MOVE.B #$64, HEALTH
    MOVE.B #$64, STAMINA
    MOVE.B #$5, STAMINA_POTIONS
    MOVE.B #$2, CAMPS
    MOVE.B #$64, GOLD
    MOVE.B #$3, SPELL_SLOTS
    MOVE.B #0, PLAYER_X
    MOVE.B #0, PLAYER_Y
    RTS

*-------------------------------------------------------
*------------------- MAP GAMELOOP
*-------------------------------------------------------
MAP_LOOP:
    ;CHECK STAMINA
    ;NOT WORKING NEEDS FIXING
    MOVE.B STAMINA, D1
    CMP #MIN_ALL, D1    ;EXIT IF 0
    BEQ USE_STAMINA_POTION
    
    ;CHECK COLS
    BRA CHECK_Y_POS
    
*-------------------------------------------------------
*------------------- CHECK POSITION IN MAP
*-------------------------------------------------------
CHECK_Y_POS:
    MOVE.B PLAYER_Y, D5
    
    CMP #0, D5
    BEQ CHECK_X_POS_ROW1
    CMP #1, D5
    BEQ CHECK_X_POS_ROW2 
    CMP #2, D5
    BEQ CHECK_X_POS_ROW3 
    CMP #3, D5
    BEQ CHECK_X_POS_ROW4 
    
CHECK_X_POS_ROW1:
    MOVE.B PLAYER_X, D5 ;PX IS COUNTER AFTER PICKING ROW
    
    ;LOAD MAP ROW
    LEA MAP_ROW1, A2 ;RELOAD MAP START IN MEMORY
    ;LOOP UNTIL COUNT
    BSR LOOP_MAP_ROW
    ;MOVE VALUE TO D1
    ;ENTER TILE
    BRA ENTER_TILE
    
CHECK_X_POS_ROW2:
    MOVE.B PLAYER_X, D5 ;PX IS COUNTER AFTER PICKING ROW
    
    ;LOAD MAP ROW
    LEA MAP_ROW2, A2 ;RELOAD MAP START IN MEMORY
    ;LOOP UNTIL COUNT
    BSR LOOP_MAP_ROW
    ;MOVE VALUE TO D1
    ;ENTER TILE
    BRA ENTER_TILE

CHECK_X_POS_ROW3:
    MOVE.B PLAYER_X, D5 ;PX IS COUNTER AFTER PICKING ROW
    
    ;LOAD MAP ROW
    LEA MAP_ROW3, A2 ;RELOAD MAP START IN MEMORY
    ;LOOP UNTIL COUNT
    BSR LOOP_MAP_ROW
    ;MOVE VALUE TO D1
    ;ENTER TILE
    BRA ENTER_TILE

CHECK_X_POS_ROW4:
    MOVE.B PLAYER_X, D5 ;PX IS COUNTER AFTER PICKING ROW
    
    ;LOAD MAP ROW
    LEA MAP_ROW4, A2 ;RELOAD MAP START IN MEMORY
    ;LOOP UNTIL COUNT
    BSR LOOP_MAP_ROW
    ;MOVE VALUE TO D1
    ;ENTER TILE
    BRA ENTER_TILE    
    
LOOP_MAP_ROW:        
    MOVE.B (A2)+, D2 ;GET VALUE     
    SUB.B #1, D5 ;COUNTER--
    CMP.B #0, D5 ;CHECK  HERE
    BGT LOOP_MAP_ROW ;EXIT LOOP AFTER     
    RTS


*-------------------------------------------------------
*------------------- ENTER TILE  
*-------------------------------------------------------
ENTER_TILE:
    CMP #ENEMY_TILE,D2
    BEQ ENTER_ENEMY
    
    CMP #MOUNTAIN,D2
    BEQ ENTER_MOUNTAIN
    
    CMP #FOREST,D2
    BEQ ENTER_FOREST
    
    CMP #BEACH,D2
    BEQ ENTER_BEACH
    
    CMP #TOWN,D2
    BEQ ENTER_TOWN
    
    CMP #FIELD,D2
    BEQ ENTER_FIELD
    
    CMP #EXIT_TILE,D2
    BEQ ENTER_BOAT
    
    CMP #BOSS_TILE,D2
    BEQ ENTER_BOSS

    CMP #PORTAL_TILE,D2
    BEQ ENTER_PORTAL
    
*-------------------------------------------------------
*------------------- ENEMY
*-------------------------------------------------------
ENTER_ENEMY:
    LEA ENEMY_MSG,A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    LEA FIGHT_MSG,A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    BSR GET_INPUT
    BSR DRAW_NEWLINE
    
    CMP #ONE, D1
    BEQ MOVE_PLAYER
    
    CMP #TWO, D1
    BEQ FIGHT_ENEMY
    
    BSR DRAW_NEWLINE
    BSR INVALID_INPUTS
    BSR DRAW_NEWLINE
    BRA ENTER_ENEMY
*-------------------------------------------------------
*------------------- MOUNTAIN 
*-------------------------------------------------------
ENTER_MOUNTAIN:
    LEA MOUNTAIN_MSG,A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    BRA MOVE_PLAYER
*-------------------------------------------------------
*------------------- FOREST
*------------------------------------------------------- 
ENTER_FOREST:
    LEA FOREST_MSG,A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    LEA SEARCH_MSG,A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE

    ;RNG  1 POTION 2 STR++ 3 CAMP 4 NO ITEM
    BSR RNG_1_4
    CMP #1, D1
    BEQ GET_POTION
    CMP #2, D1
    BEQ GET_WEAPON
    CMP #3, D1
    BEQ GET_CAMP
    
    LEA NO_ITEM_MSG,A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    BRA MOVE_PLAYER
*-------------------------------------------------------
*------------------- FOREST PICKUPS 
*-------------------------------------------------------
GET_POTION:
    MOVE.B STAMINA_POTIONS ,D1
    ADD.B #1, D1
    MOVE.B D1, STAMINA_POTIONS
    
    LEA FOUND_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    BRA MOVE_PLAYER
    
GET_WEAPON:
    MOVE.B STRENGTH ,D1
    ADD.B #3, D1
    MOVE.B D1, STRENGTH
    
    LEA FOUND_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    BRA MOVE_PLAYER

GET_CAMP:
    MOVE.B CAMPS ,D1
    ADD.B #1, D1
    MOVE.B D1, CAMPS
    
    LEA FOUND_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    BRA MOVE_PLAYER
*-------------------------------------------------------
*------------------- BEACH 
*-------------------------------------------------------
ENTER_BEACH:
    LEA BEACH_MSG,A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    BRA MOVE_PLAYER
*-------------------------------------------------------
*------------------- TOWN
*-------------------------------------------------------
ENTER_TOWN:
    LEA TOWN_MSG,A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    LEA SHOP_MSG,A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    BSR GET_INPUT
    BSR DRAW_NEWLINE
    
    CMP #ONE, D1
    BEQ SHOP_1
        
    CMP #TWO, D1
    BEQ SHOP_2
    
    CMP #THREE, D1
    BEQ EXIT_SHOP
    
    BSR DRAW_NEWLINE
    BSR INVALID_INPUTS
    BSR DRAW_NEWLINE
    BRA ENTER_TOWN
EXIT_SHOP:
    LEA EXIT_SHOP_MSG,A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    BRA MOVE_PLAYER
    
*-------------------------------------------------------
*------------------- SHOP
*-------------------------------------------------------
SHOP_1:
    MOVE.B GOLD, D1
    CMP #10, D1
    BLT NO_GOLD
    
    SUB.B #10, D1
    MOVE.B D1, GOLD
    
    MOVE.B #1, D1
    ADD.B D1, STAMINA_POTIONS
    
    LEA BOUGHT_STAMINA_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    BRA MOVE_PLAYER

SHOP_2:
    MOVE.B GOLD, D1
    CMP #20, D1
    BLT NO_GOLD
    
    SUB.B #20, D1
    MOVE.B D1, GOLD
    
    MOVE.B #3, D1
    ADD.B D1, STRENGTH
    
    LEA BOUGHT_WEAPON_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    BRA MOVE_PLAYER

NO_GOLD:
    BSR INSUFFICIENT_RESOURCES
    BRA MAP_LOOP 
*-------------------------------------------------------
*------------------- FIELD  
*-------------------------------------------------------
ENTER_FIELD:
    LEA FIELD_MSG,A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    LEA CAMP_MSG,A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    BSR GET_INPUT
    BSR DRAW_NEWLINE
    
    CMP #ONE, D1
    BEQ NOT_CAMP
    
    CMP #TWO, D1
    BEQ USE_CAMP
    
    BSR DRAW_NEWLINE
    BSR INVALID_INPUTS
    BSR DRAW_NEWLINE
    
    BRA ENTER_FIELD
    
NOT_CAMP:
    LEA NO_CAMP_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    BRA MOVE_PLAYER

*-------------------------------------------------------
*------------------- BOAT
*-------------------------------------------------------
ENTER_BOAT:
    LEA BOAT_MSG,A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    BRA GAME_COMPLETE
    
*-------------------------------------------------------
*------------------- BOSS
*-------------------------------------------------------
ENTER_BOSS:
    LEA BOSS_MSG,A1 
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    BRA FIGHT_BOSS
    
*-------------------------------------------------------
*------------------- PORTAL 
*-------------------------------------------------------
ENTER_PORTAL:
    LEA NEXT_LVL_MSG,A1 
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    BRA NEXT_LEVEL ;CHANGE TO LEVEL UP

*-------------------------------------------------------
*------------------- USE ITEMS 
*-------------------------------------------------------
USE_STAMINA_POTION:
    MOVE.B STAMINA_POTIONS, D1
    CMP #MIN_ALL, D1
    BEQ NO_POTIONS
    
    SUB.B #1, D1
    MOVE.B D1, STAMINA_POTIONS
    
    MOVE.B #30, D1
    MOVE.B D1, STAMINA
    
    BRA MAP_LOOP
    
NO_POTIONS:
    BSR INSUFFICIENT_RESOURCES 
    BRA GAME_OVER

USE_CAMP:
    MOVE.B CAMPS, D1
    CMP #MIN_ALL, D1
    BEQ NO_CAMPS
    
    LEA CAMP_USED_MSG,A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    SUB.B #1, D1
    MOVE.B D1, CAMPS
    
    MOVE.B #$64, D1
    MOVE.B D1, HEALTH
    MOVE.B D1, STAMINA
    
    BRA MOVE_PLAYER
    
NO_CAMPS:
    BSR INSUFFICIENT_RESOURCES
    BRA MAP_LOOP
    
PLAYER_HEAL:
    ;CHECK SPELLS
    MOVE.B SPELL_SLOTS, D1
    CMP.B #0, D1
    BEQ NO_SPELLS
    ;NO SPELLS

    LEA HEAL_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    ;ADD HEALTH
    MOVE.B #50, D2
    MOVE.B D2, HEALTH
    ;TAKE SPELL
    SUB.B #1, D1
    MOVE.B D1, SPELL_SLOTS
    
    BRA MAP_LOOP  

NO_SPELLS:
    BSR INSUFFICIENT_RESOURCES
    BRA GAME_OVER
    
INSUFFICIENT_RESOURCES:
    LEA NO_ITEMS_MSG, A1 
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    RTS
    
*-------------------------------------------------------
*------------------- FIGHT   
*-------------------------------------------------------
FIGHT_ENEMY:
    BSR DRAW_NEWLINE
    MOVE.B STRENGTH, D1
    CMP.B ENEMY_STR, D1
    BLT LOSE_FIGHT
    
    BRA WIN_FIGHT 
        
FIGHT_BOSS:
    BSR DRAW_NEWLINE
    MOVE.B STRENGTH, D1
    CMP.B BOSS_STR, D1
    BLT LOSE_FIGHT
    
    BRA WIN_BOSS_FIGHT
        
*-------------------------------------------------------
*------------------- WIN FIGHT    
*-------------------------------------------------------
WIN_FIGHT:
    BSR LOSE_HEALTH
    ;CHECK HEALTH 
    MOVE.B HEALTH, D1
    CMP.B #0, D1
    BLT LOSE_FIGHT
    
    LEA VICTORY_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    BRA REWARD
    
WIN_BOSS_FIGHT:
    LEA BOSS_VICTORY_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    BSR DRAW_NEWLINE
    BSR DRAW_NEWLINE
    BRA NEXT_LEVEL

*-------------------------------------------------------
*------------------- LOSE FIGHT    
*-------------------------------------------------------
LOSE_FIGHT:   
    LEA DEATH_MSG, A1
    BSR DRAW_STRING
    BRA GAME_OVER

*-------------------------------------------------------
*------------------- FIGHT REWARDS
*-------------------------------------------------------
REWARD:
    BSR ENEMY_STATS_UP
    BSR PLAYER_STR_UP
    BSR PLAYER_HEALTH_UP
    
    BSR RNG_1_3
    CMP.B #1, D1
    BEQ OBTAIN_POTION
    
    CMP.B #2, D1
    BEQ OBTAIN_GOLD
    
    CMP.B #3, D1
    BEQ OBTAIN_CAMP

LOSE_HEALTH:
    MOVE.B HEALTH, D4
    BSR RNG_1_4
    SUB.B D1, D4
    MOVE.B D4, HEALTH
    RTS
    
OBTAIN_POTION:
    MOVE.B STAMINA_POTIONS, D4
    ADD.B #1, D4
    MOVE.B D4, STAMINA_POTIONS
    CLR D4
    BRA MOVE_PLAYER
    
OBTAIN_GOLD:
    MOVE.B GOLD, D4
    ADD.B #10, D4
    MOVE.B D4, GOLD
    CLR D4
    BRA MOVE_PLAYER

OBTAIN_CAMP:
    MOVE.B CAMPS, D4
    ADD.B #1, D4
    MOVE.B D4, CAMPS
    CLR D4
    BRA MOVE_PLAYER

PLAYER_HEALTH_UP:
    MOVE.B MAX_HEALTH, D4
    ADD.B #1, D4
    MOVE.B D4, MAX_HEALTH
    RTS
    
PLAYER_SPELL_UP:
    MOVE.B SPELL_SLOTS, D4
    ADD.B #1, D4
    MOVE.B D4, SPELL_SLOTS
    RTS
    
PLAYER_STR_UP:
    MOVE.B STRENGTH, D4
    ADD.B #1, D4
    MOVE.B D4, STRENGTH
    RTS
    
ENEMY_STATS_UP:
    MOVE.B ENEMY_STR, D4
    ADD.B #1, D4
    MOVE.B D4, ENEMY_STR
    RTS
*-------------------------------------------------------
*------------------- REPEATLY USED FUNCTIONS 
*------------------- RNG FUNCTIONS 
*-------------------------------------------------------
RNG_0_1:
    BSR GET_SEED
    
    AND.L	#$7FFF,D1			; prevent overflow in divu
	DIVU	#10,D1				; time count / max number
	SWAP	D1				; swap upper and lower words of D1 to get remainder	
	EXT.L	D1				; convert lower word to long
	
	CMP #8, D1  ;RESULT MUST BE 8-9 OR REPEATS
	BLT RNG_0_1
	
	SUB.B #8,D1 ;RESULT BECOMES 0 OR 1 8-8=0 8-9=1
    RTS

RNG_1_4:
    BSR GET_SEED
    
    AND.L	#$7FFF,D1			; prevent overflow in divu
	DIVU	#10,D1				; time count / max number
	SWAP	D1				; swap upper and lower words of D1 to get remainder	
	EXT.L	D1				; convert lower word to long
	
	CMP #6, D1  ;RESULT MUST BE 6-9 OR REPEATS
	BLT RNG_1_4
	
	SUB.B #5,D1 ;RESULT BECOMES 1 TO 4
    RTS

RNG_1_3:
    BSR GET_SEED
    
    AND.L	#$7FFF,D1			; prevent overflow in divu
	DIVU	#10,D1				; time count / max number
	SWAP	D1				; swap upper and lower words of D1 to get remainder	
	EXT.L	D1				; convert lower word to long
	
	CMP #7, D1  ;RESULT MUST BE 7-9 OR REPEATS
	BLT RNG_1_3
	
	SUB.B #6,D1 ;RESULT BECOMES 1 TO 3
    RTS

GET_SEED:
    MOVE.W #$3999, D7
    BSR DELAY
    MOVE.B	#8,D0   ;TIME STAMP
	TRAP	#15	
    RTS	
    
DELAY:
    SUB.W #1, D7 ;COUNTER--
    CMP.W #0, D7 
    BNE DELAY
    RTS
    
*-------------------------------------------------------
*------------------- INPUT MOVEMENT
*-------------------------------------------------------
MOVE_PLAYER:
    BSR DRAW_HUD

    ;GET INPUT
    LEA WASD_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    BSR GET_INPUT
    BSR DRAW_NEWLINE
    
    ;GO DIRECTION
    CMP #W, D1
    BEQ MOVE_NORTH
    CMP #S, D1
    BEQ MOVE_SOUTH
    CMP #D, D1
    BEQ MOVE_EAST
    CMP #A, D1
    BEQ MOVE_WEST
    
    CMP #$77, D1
    BEQ MOVE_NORTH
    CMP #$73, D1
    BEQ MOVE_SOUTH
    CMP #$64, D1
    BEQ MOVE_EAST
    CMP #$61, D1
    BEQ MOVE_WEST
    
    ;KEY NOT WASD
    BNE INVALID_MOVE_INPUT
    
MOVE_NORTH:
    BSR DRAW_NEWLINE 
    ;MOVEMENT CHECKS 
    ;CHECK IF YOU CAN MOVE DIRECTION FIRST
    BSR INVALID_MOVEMENT_CHECK_N

    ;USE ENERGY
    MOVE.B STAMINA, D1
    SUB.B #10, D1
    MOVE.B D1, STAMINA

    ;PLAY MSG    
    LEA NORTH_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    ;UPDATE CO-ORD
    MOVE.B PLAYER_Y, D1
    SUB.B #1, D1
    MOVE.B D1, PLAYER_Y
 
    BRA MAP_LOOP
    
INVALID_NORTH:
    ;TEMP MOVE UPDATE CO-ORD
    MOVE.B PLAYER_Y, D1
    SUB.B #1, D1
    MOVE.B D1, PLAYER_Y
    
    ;CHECK OUT OF BOUNDS
    CMP #$FF, D1
    BEQ INVALID_MOVEMENT_N
    RTS
    
INVALID_MOVEMENT_N:
    ;UNDO TEMP MOVE
    MOVE.B PLAYER_Y, D1
    ADD.B #1, D1
    MOVE.B D1, PLAYER_Y
    BRA INVALID_MOVEMENT
   
MOVE_SOUTH:
    BSR DRAW_NEWLINE  
    ;CHECK IF YOU CAN MOVE DIRECTION FIRST
    BSR INVALID_MOVEMENT_CHECK_S
    
    ;USE ENERGY
    MOVE.B STAMINA, D1
    SUB.B #10, D1
    MOVE.B D1, STAMINA

    ;PLAY MSG    
    LEA SOUTH_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    
    ;UPDATE CO-ORD
    MOVE.B PLAYER_Y, D1
    ADD.B #1, D1
    MOVE.B D1, PLAYER_Y
    
    BRA MAP_LOOP
    
INVALID_SOUTH:
    ;TEMP MOVE UPDATE CO-ORD
    MOVE.B PLAYER_Y, D1
    ADD.B #1, D1
    MOVE.B D1, PLAYER_Y
    
    ;CHECK OUT OF BOUNDS
    CMP #$4, D1
    BEQ INVALID_MOVEMENT_S
    RTS
    
INVALID_MOVEMENT_S:
    ;UNDO TEMP MOVE
    MOVE.B PLAYER_Y, D1
    SUB.B #1, D1
    MOVE.B D1, PLAYER_Y
    BRA INVALID_MOVEMENT
   
MOVE_WEST:
    BSR DRAW_NEWLINE  
    ;CHECK IF YOU CAN MOVE DIRECTION FIRST
    BSR INVALID_MOVEMENT_CHECK_W
    ;USE ENERGY
    MOVE.B STAMINA, D1
    SUB.B #10, D1
    MOVE.B D1, STAMINA
    ;PLAY MSG    
    LEA WEST_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    ;UPDATE CO-ORD
    MOVE.B PLAYER_X, D1
    SUB.B #1, D1
    MOVE.B D1, PLAYER_X
    
    BRA MAP_LOOP
    
INVALID_WEST:
    ;TEMP MOVE UPDATE CO-ORD
    MOVE.B PLAYER_X, D1
    SUB.B #1, D1
    MOVE.B D1, PLAYER_X
    
    ;CHECK OUT OF BOUNDS
    CMP #$FF, D1
    BEQ INVALID_MOVEMENT_W
    RTS
    
INVALID_MOVEMENT_W:
    ;UNDO TEMP MOVE
    MOVE.B PLAYER_X, D1
    ADD.B #1, D1
    MOVE.B D1, PLAYER_X
    BRA INVALID_MOVEMENT   
 
    
MOVE_EAST:
    BSR DRAW_NEWLINE  
    ;CHECK IF YOU CAN MOVE DIRECTION FIRST
    BSR INVALID_MOVEMENT_CHECK_E
    ;USE ENERGY
    MOVE.B STAMINA, D1
    SUB.B #10, D1
    MOVE.B D1, STAMINA
    ;PLAY MSG    
    LEA EAST_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    ;UPDATE CO-ORD
    MOVE.B PLAYER_X, D1
    ADD.B #1, D1
    MOVE.B D1, PLAYER_X
       
    BRA MAP_LOOP
   
INVALID_EAST:
    ;TEMP MOVE UPDATE CO-ORD
    MOVE.B PLAYER_X, D1
    ADD.B #1, D1
    MOVE.B D1, PLAYER_X
    
    ;CHECK OUT OF BOUNDS
    CMP #$4, D1
    BEQ INVALID_MOVEMENT_E
    RTS
    
INVALID_MOVEMENT_E:
    ;UNDO TEMP MOVE
    MOVE.B PLAYER_X, D1
    SUB.B #1, D1
    MOVE.B D1, PLAYER_X
    BRA INVALID_MOVEMENT   
    
INVALID_MOVEMENT_CHECK_N:
    ;Y=0 NO NORTH
    MOVE.B PLAYER_Y, D1
    CMP #0, D1
    BEQ INVALID_NORTH
    RTS
    
INVALID_MOVEMENT_CHECK_W:
    ;X=0 NO WEST
    MOVE.B PLAYER_X, D1
    CMP #0, D1
    BEQ INVALID_WEST
    RTS
    
INVALID_MOVEMENT_CHECK_S:    
    ;Y=3 NO SOUTH
    MOVE.B PLAYER_Y, D1
    CMP #3, D1
    BEQ INVALID_SOUTH
    RTS
    
INVALID_MOVEMENT_CHECK_E:    
    ;X=3 NO EAST
    MOVE.B PLAYER_X, D1
    CMP #3, D1
    BEQ INVALID_EAST  
    
    RTS

INVALID_MOVEMENT:
    BSR DRAW_NEWLINE  
    ;USE ENERGY
    MOVE.B STAMINA, D1
    SUB.B #10, D1
    MOVE.B D1, STAMINA
    ;PLAY MSG    
    LEA INVALID_DIRECTION_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE       
    
    BRA MAP_LOOP
    
INVALID_MOVE_INPUT:
    BSR DRAW_NEWLINE  
    ;USE ENERGY
    ;PLAY MSG    
    LEA INVALID_INPUT, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
       
    BRA MOVE_PLAYER

*-------------------------------------------------------
*------------------- GET INPUT  
*-------------------------------------------------------
GET_INPUT:
    MOVE.B #5, D0
    TRAP #15
    RTS

*-------------------------------------------------------
*------------------- INVALID INPUTS    
*-------------------------------------------------------
INVALID_INPUTS:
    LEA INVALID_INPUT, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    RTS
    
*-------------------------------------------------------
*------------------- DRAW
*-------------------------------------------------------
;OUTPUT MESSAGES 
DRAW_STRING:
    MOVE.B #14, D0
    TRAP #15
    RTS

DRAW_NUMBER:
    MOVE.B #3, D0
    TRAP #15  
    RTS

DRAW_NEWLINE:
    LEA     CRLF,A1                 
    MOVE    #14,D0          
    TRAP    #15                  
    RTS 
    
DRAW_HUD:
    ;PLAY MSG
    LEA HEALTH_MSG, A1
    BSR DRAW_STRING
    MOVE.B HEALTH, D1
    BSR DRAW_NUMBER
    BSR DRAW_NEWLINE
    
    LEA STAMINA_MSG, A1
    BSR DRAW_STRING
    MOVE.B STAMINA, D1
    BSR DRAW_NUMBER
    BSR DRAW_NEWLINE

    LEA PLAYER_STRENGTH_MSG, A1
    BSR DRAW_STRING
    MOVE.B STRENGTH, D1
    BSR DRAW_NUMBER
    BSR DRAW_NEWLINE

    
    LEA SPELLS_MSG, A1
    BSR DRAW_STRING
    MOVE.B SPELL_SLOTS, D1
    BSR DRAW_NUMBER
    BSR DRAW_NEWLINE
    
    LEA CAMPS_MSG, A1
    BSR DRAW_STRING
    MOVE.B CAMPS, D1
    BSR DRAW_NUMBER
    BSR DRAW_NEWLINE
    
    LEA POTIONS_MSG, A1
    BSR DRAW_STRING
    MOVE.B STAMINA_POTIONS, D1
    BSR DRAW_NUMBER
    BSR DRAW_NEWLINE
    
    LEA GOLD_MSG, A1
    BSR DRAW_STRING
    MOVE.B GOLD, D1
    BSR DRAW_NUMBER
    BSR DRAW_NEWLINE
    
    LEA CURRENT_X_MSG ,A1
    BSR DRAW_STRING
    MOVE.B PLAYER_X, D1
    BSR DRAW_NUMBER
    BSR DRAW_NEWLINE
    
    LEA CURRENT_Y_MSG ,A1
    BSR DRAW_STRING
    MOVE.B PLAYER_Y, D1
    BSR DRAW_NUMBER
    BSR DRAW_NEWLINE
    
    LEA MOVE_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE

    RTS
*-------------------------------------------------------
*------------------- LEVEL COMPLETE 
*------------------------------------------------------- 
NEXT_LEVEL:
    BSR BOSS_STATS_UP
    BSR INCREASE_LEVEL
    BSR RESET_PLAYER_POS
    
    MOVE.B MODE_TEST, D1
    CMP.B #0, D1
    BEQ GAME_COMPLETE
    BRA ENDLESS_LOOP   
    
RESET_PLAYER_POS:
    MOVE.B #0, PLAYER_X
    MOVE.B #0, PLAYER_Y
    RTS

INCREASE_LEVEL:
    MOVE.B LEVEL, D4
    ADD.B #1, D4
    MOVE.B D4, LEVEL
    CLR D4
    RTS 
    
    
BOSS_STATS_UP:
    MOVE.B BOSS_STR, D4
    ADD.B #4, D4
    MOVE.B D4, BOSS_STR
    RTS
*-------------------------------------------------------
*------------------- GAME COMPLETE 
*-------------------------------------------------------
GAME_COMPLETE:
    LEA GAME_COMPLETE_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    BRA EXIT

*-------------------------------------------------------
*------------------- GAME OVER 
*-------------------------------------------------------
GAME_OVER:
    LEA GAME_END_MSG, A1
    BSR DRAW_STRING
    BSR DRAW_NEWLINE
    BRA EXIT

EXIT:
    SIMHALT  
         
*-------------------------------------------------------
*------------------- VARIABLES 
*------------------- GAME INFO   
*-------------------------------------------------------
MODE_TEST DC.B 0

CURRENT_LEVEL_MSG DC.B 'LEVEL: ',0
LEVEL DC.B 1

SEED DC.L 0
MAPVALUE DC.B 0 

;GAME SETUP MESSAGES
CRLF DC.B $0D,$0A,0
INVALID_INPUT DC.B 'INVALID INPUT.',0
START_MSG DC.B 'GAME START!',0
MODE_MSG DC.B 'DO YOU WANT TO PLAY A MISSION OR ENDLESS MODE? 1=MISSION 2=ENDLESS',0

MISSION_MODE_MSG DC.B 'MISSION MODE CHOOSEN.',0
ENDLESS_MODE_MSG DC.B 'ENDLESS MODE CHOOSEN.',0

;GAME INTRO MESSAGES
WELCOME_MSG DC.B 'WELCOME TO THE SMALL WORLD.',0
EQUIP_MSG DC.B 'YOU EQUIP A NEEDLE SWORD.',0
LEARN_HEAL_MSG DC.B 'YOU LEARN THE HEAL SPELL. (HEAL TO FULL HEALTH)',0
MOVE_COST_MSG DC.B 'MOVING IN THE MAP COSTS 10 STAMINA.',0
WASD_MSG DC.B 'W TO MOVE NORTH. A TO MOVE WEST. S TO MOVE SOUTH. E TO EAST.',0
START_COORD_MSG DC.B '(0,0) IS START POINT FOR EVERY LEVEL AND THE MOST NORTH WEST POINT OF THE MAP.',0

;QUESTS
SURVIVE_MSG DC.B 'SURVIVE AS LONG AS POSSIBLE.',0
DEFEAT_BOSS_MSG DC.B 'DEFEAT THE BOSS!',0
FIND_EXIT_MSG DC.B 'FIND THE EXIT.',0
GAME_OVER_MSG DC.B 'GAME OVER WHEN HEALTH OR STAMINA 0',0

;GAME OVER/COMPLETE
GAME_END_MSG DC.B 'GAME OVER! YOU LOSE!',0
GAME_COMPLETE_MSG DC.B 'GAME COMPLETE! YOU WIN!',0

;USE ITEMS
;WHEN STAMINA == 0 USE POTION
POTION_USED_MSG DC.B 'STAMINA POTION USED, STAMINA RECOVERED BY 10',0
NO_ITEMS_MSG DC.B 'INSUFFICIENT RESOURCES.',0

;HEAL
HEAL_MSG DC.B 'USED HEAL, HEALTH RECOVERED FULLY.',0

;MOVE
MOVE_MSG DC.B 'WHICH DIRECTION DO YOU GO?',0
NORTH_MSG DC.B 'YOU WENT NORTH.',0
SOUTH_MSG DC.B 'YOU WENT SOUTH.',0
EAST_MSG DC.B 'YOU WENT EAST.',0
WEST_MSG DC.B 'YOU WENT WEST.',0
INVALID_DIRECTION_MSG DC.B 'YOU WASTE YOUR ENERGY GOING IN A CIRCLE.(INVALID DIRECTION)',0
*-------------------------------------------------------
*------------------- STATS    
*-------------------------------------------------------
;PLAYER
MAX_HEALTH DC.B $64

HEALTH DC.B $5 ;64
HEALTH_MSG DC.B 'HEALTH: ',0

STAMINA DC.B $64
STAMINA_MSG DC.B 'STAMINA: ',0

STAMINA_POTIONS DC.B 1
POTIONS_MSG DC.B 'STAMINA POTIONS: ',0

SPELL_SLOTS DC.B 1
SPELLS_MSG DC.B 'HEAL SPELLS: ',0

CAMPS DC.B 1
CAMPS_MSG DC.B 'CAMPS: ',0

STRENGTH DC.B $5
PLAYER_STRENGTH_MSG DC.B 'STRENGTH: ',0

GOLD DC.B 50
GOLD_MSG DC.B 'GOLD: ',0

PLAYER_X DC.B 0
CURRENT_X_MSG DC.B 'X POSITION: ',0

PLAYER_Y DC.B 0
CURRENT_Y_MSG DC.B 'Y POSITION: ',0

;ENEMY
ENEMY_STR DC.B $1
ENEMY_STRENGTH_MSG DC.B 'ENEMY STRENGHT: ',0

;BOSS
BOSS_STR DC.B $3
BOSS_STRENGTH_MSG DC.B 'BOSS STRENGHT: ',0

*-------------------------------------------------------
*------------------- MAP AND TILES    
*-------------------------------------------------------
;LEVEL MAP
MAP_ROW1 DC.B 0,0,0,0
MAP_ROW2 DC.B 0,0,0,0
MAP_ROW3 DC.B 0,0,0,0  
MAP_ROW4 DC.B 0,0,0,0

;ENEMY TILE 1
ENEMY_MSG DC.B 'A ENEMY APPEARS.',0
FIGHT_MSG DC.B 'DO YOU WANT TO FIGHT? 1=NO 2=YES',0 ;RE-USE FOR BOSS FIGHT

;FOREST TILE 2
FOREST_MSG DC.B 'YOU ENTER A FOREST.',0
SEARCH_MSG DC.B 'SEARCHING FOR ITEMS.',0
NO_ITEM_MSG DC.B 'NO ITEMS FOUND.',0
FOUND_MSG DC.B 'YOU FOUND AN ITEM',0

;MOUNTAIN TILE 3
MOUNTAIN_MSG DC.B 'YOU WANDER THROUGH THE MOUNTAINS.',0

;BEACH TILE 4
BEACH_MSG DC.B 'YOU TAKE A STROLL ON THE BEACH', 0

;TOWN TILE  5
TOWN_MSG DC.B 'YOU ENTER A CASTLE TOWN. YOU SEE A ITEM SHOP.',0
SHOP_MSG DC.B 'DO YOU WANT TO BUY A ITEM? 1=STAMINA POTION (10G) 2=WEAPON UPGRADE (20G) 3=EXIT',0
BOUGHT_STAMINA_MSG DC.B 'YOU BOUGHT A STAMINA POTION. (RESTORES 30 STAMINA)',0
BOUGHT_WEAPON_MSG DC.B 'YOU GOT YOUR WEAPON UPGRADED. (STRENGHT+3)',0
INN_MSG DC.B 'YOU STAY THE NIGHT AT A INN. COMPLETELY RECOVERED.',0
EXIT_SHOP_MSG DC.B 'YOU EXIT THE ITEM SHOP.',0

;FIELD TILE 6
FIELD_MSG DC.B 'A WIDE SAFE FIELD.',0
CAMP_MSG DC.B 'SET UP CAMP?  1=NO 2=YES',0
CAMP_USED_MSG DC.B 'CAMP USED, STAMINA AND HEALTH FULLY RESTORED.',0
NO_CAMP_MSG DC.B 'YOU CHOOSE NOT TO CAMP.',0

;EXIT TILE 7
BOAT_MSG DC.B 'BOAT FOUND. ESCAPING ISLAND TO SAFETY.',0

;BOSS TILE 8
BOSS_MSG DC.B 'THE BOSS APPEARS.',0
BOSS_VICTORY_MSG DC.B 'BOSS DEFEATED.',0

;PORTAL TILE 9
NEXT_LVL_MSG DC.B 'YOU ENTER A MAGIC PORTAL AND END UP SOMEWHERE UNKNOWN.',0

;REWARDS FIGHT AND PICKUP
POTION_OBTAINED_MSG DC.B 'STAMINA POTION OBTAINED.',0
CAMP_SUPLIIES_MSG DC.B 'CAMP SUPPLIES OBTAINED.',0
*-------------------------------------------------------
*------------------- FIGHT MESSAGES    
*-------------------------------------------------------
;LOSE
DEATH_MSG DC.B 'YOUR HEALTH IS 0. YOU DIED.', 0

;WIN
VICTORY_MSG DC.B 'ENEMY DEFEATED.',0
DROP_MSG DC.B 'THE ENEMY DROPPED AN ITEM.',0
*-------------------------------------------------------
*------------------- END PROGRAM    
*-------------------------------------------------------

    END    START 






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

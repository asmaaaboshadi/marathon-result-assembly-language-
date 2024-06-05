ORG 100H                
;---------------------STORE INPUTS------------------------
    
    ;DISPLAY MSG FOR NUMBERS OF PLAYERS
    MOV AH, 09H
    LEA DX, WEL
    INT 21H

    ;READ INPUT FOR NUMBERS OF PLAYERS
    LEA DX, STP
    MOV AH, 0AH
    INT 21H 
    MOV AX,0
    LEA SI, STP + 2
    MOV BL, [SI] 
    CMP BL, '$'

    SUB BL,30H
    XOR CX,CX
    MOV CL,BL
    MOV SZ[0],CL

    LEA DI,TIM
    MOV BH,30H
OUT_LOOP:

    ;DISPLAY NEWLINE 
    MOV AH, 02H
    MOV DL, 0DH
    INT 21H
    MOV DL, 0AH
    INT 21H
    
    ;DISPLAY MSG  FOR TIME OF PLAYERS
    MOV AH, 09H
    LEA DX, MSG
    INT 21H
    
    INC BH        ;TARQEEM L PLAYERS
    MOV DL,BH
    MOV AH, 02H
    INT 21H
    
    MOV AH, 09H   ; BA2E L MSG
    LEA DX, MSGG
    INT 21H

    ;READ INPUT  FOR TIME OF PLAYERS
    LEA DX, INP
    MOV AH, 0AH
    INT 21H 
    PUSH CX
    ADD DI,2
    MOV CX,0004
    MOV AX,0
    LEA SI, INP + 2 ;

MAIN_LOOP:
    MOV BL, [SI] 
    CMP BL, '$'   ; CHECK STRING END
    JE DONE    
    
    ;CONVERT ASCII TO HEX
    SUB BL, '0'   
    CMP BL, 9     
    JA NOT_DIGIT  ; IF A>F
    JMP CONVERT   ; IF O>9
NOT_DIGIT:
    SUB BL, 7

CONVERT:
    SHL AX, 4
    OR AL, BL     ; ADD NEW DIGIT TO AL
    INC SI       ; MOVE TO NEXT CHARACTER  
    DEC CX
    JNZ MAIN_LOOP ;REPEAT FOR NEXT DIGIT

DONE:
    ;STORE IN ARRAY
    MOV [DI-2], AX
    POP CX
    DEC CX                                
    JNZ OUT_LOOP ;REPEAT FOR NEXT PLAYER 
    
;--------------CODE----------

START: MOV BYTE PTR [FLG], 0
       LEA SI,TIM
       LEA DI,NUM
       XOR CX,CX
       MOV CL, SZ
       DEC CL 
MAIN_LOOP1: MOV AX,[SI]
            MOV DX,[SI+2]
            
            MOV BL,[DI]
            MOV BH,[DI+1]
             
            CMP AX,DX
            JBE NO_SWAP
    SWAP:  MOV BYTE PTR [FLG], 1
           XCHG AX ,DX
           XCHG BL ,BH
           
           MOV [SI],AX
           MOV [SI+2],DX 
           
           MOV [DI],BL
           MOV [DI+1],BH
NO_SWAP: ADD SI,2
         INC DI
         LOOP MAIN_LOOP1
         MOV BL,[FLG]
         DEC BL
         JZ START
         
;---------------------PRINT OUTPUTS------------------------

; Display new line
MOV AH, 02H
MOV DL, 0DH
INT 21H
MOV DL, 0AH
INT 21H
;Display message for ranking of players
MOV AH, 09H
LEA DX, FIN
INT 21H


LEA SI, NUM 
LEA DI, IND
XOR CX,CX
MOV CL, SZ
XOR AX, AX

CONVERT_LOOP:
    
    MOV AL, [SI]
    MOV BX, 16
    XOR DX, DX           
    DIV BX              
    ADD DL, '0'
    ADD AL,30H

    MOV [DI+1], DL
    MOV [DI],AL
    
    INC SI               
    ADD DI,2 
    LOOP CONVERT_LOOP
    
XOR CX,CX
MOV CL, SZ
LEA DI, IND
 
PRINT_LOOP:
    ; Display the converted number
    MOV DL,[DI]
    MOV AH, 02H
    INT 21H
    
    MOV DL,[DI+1]
    MOV AH, 02H
    INT 21H

    ; Display new line
    MOV AH, 02H
    MOV DL, 0DH
    INT 21H
    MOV DL, 0AH
    INT 21H
    
    
    ADD DI,2 
    LOOP PRINT_LOOP

HLT    
 ;--------------DATA----------
WEL DB 'ENTER THE NUMBER OF PLAYERS: $'
MSG DB '    ENTER THE TIME IN HEX FOR PLAYER $' 
NUM DB 01,02,03,04,05,06,07,08,09
MSGG DB ': $'
INP DB 6(0)
STP DB 6(0)
FLG DB 0
IND DB 5 DUP ('0'), '$'
FIN DB 'THE RANKING IS: $'
ORG 300H
TIM DW 8(0000H)
ORG 400H 
SZ DB 00H 
ret

     
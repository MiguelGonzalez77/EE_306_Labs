;***********************************************************
; Programming Assignment 4
; Student Name: Miguel Gonzalez
; UT Eid: mag9688
; -------------------Save Simba (Part II)---------------------
; This is the starter code. You are given the main program
; and some declarations. The subroutines you are responsible for
; are given as empty stubs at the bottom. Follow the contract. 
; You are free to rearrange your subroutines if the need were to 
; arise.

;***********************************************************

.ORIG x4000

;***********************************************************
; Main Program
;***********************************************************
        JSR   DISPLAY_JUNGLE
        LEA   R0, JUNGLE_INITIAL
        TRAP  x22 
        LDI   R0,BLOCKS
        JSR   LOAD_JUNGLE
        JSR   DISPLAY_JUNGLE
        LEA   R0, JUNGLE_LOADED
        TRAP  x22                        ; output end message
HOMEBOUND
        LEA   R0,PROMPT
        TRAP  x22
        TRAP  x20                        ; get a character from keyboard into R0
        TRAP  x21                        ; echo character entered
        LD    R3, ASCII_Q_COMPLEMENT     ; load the 2's complement of ASCII 'Q'
        ADD   R3, R0, R3                 ; compare the first character with 'Q'
        BRz   EXIT                       ; if input was 'Q', exit
;; call a converter to convert i,j,k,l to up(0) left(1),down(2),right(3) respectively
        JSR   IS_INPUT_VALID      
        ADD   R2, R2, #0                 ; R2 will be zero if the move was valid
        BRz   VALID_INPUT
        LEA   R0, INVALID_MOVE_STRING    ; if the input was invalid, output corresponding
        TRAP  x22                        ; message and go back to prompt
        BR    HOMEBOUND
VALID_INPUT                 
        JSR   APPLY_MOVE                 ; apply the move (Input in R0)
        JSR   DISPLAY_JUNGLE
        JSR   IS_SIMBA_HOME      
        ADD   R2, R2, #0                 ; R2 will be zero if Simba reached Home
        BRnp  HOMEBOUND                     ; otherwise, loop back
EXIT   
        LEA   R0, GOODBYE_STRING
        TRAP  x22                        ; output a goodbye message
        TRAP  x25                        ; halt
JUNGLE_LOADED       .STRINGZ "\nJungle Loaded\n"
JUNGLE_INITIAL      .STRINGZ "\nJungle Initial\n"
ASCII_Q_COMPLEMENT  .FILL    x-71    ; two's complement of ASCII code for 'q'
PROMPT .STRINGZ "\nEnter Move \n\t(up(i) left(j),down(k),right(l)): "
INVALID_MOVE_STRING .STRINGZ "\nInvalid Input (ijkl)\n"
GOODBYE_STRING      .STRINGZ "\nYou Saved Simba !Goodbye!\n"
BLOCKS               .FILL x5000

;***********************************************************
; Global constants used in program
;***********************************************************
;***********************************************************
; This is the data structure for the Jungle grid
;***********************************************************
GRID .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
  
;***********************************************************
; this data stores the state of current position of Simba and his Home
;***********************************************************
CURRENT_ROW        .BLKW   #1       ; row position of Simba
CURRENT_COL        .BLKW   #1       ; col position of Simba 
HOME_ROW           .BLKW   #1       ; Home coordinates (row and col)
HOME_COL           .BLKW   #1

;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
; The code above is provided for you. 
; DO NOT MODIFY THE CODE ABOVE THIS LINE.
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************

;***********************************************************
; DISPLAY_JUNGLE
;   Displays the current state of the Jungle Grid 
;   This can be called initially to display the un-populated jungle
;   OR after populating it, to indicate where Simba is (*), any 
;   Hyena's(#) are, and Simba's Home (H).
; Input: None
; Output: None
; Notes: The displayed grid must have the row and column numbers
;***********************************************************
DISPLAY_JUNGLE
;---callee saves      
    ST R0, DispSaveR0
    ST R1, DispSaveR1
    ST R2, DispSaveR2
    ST R3, DispSaveR3
    ST R4, DispSaveR4
    ST R5, DispSaveR5
    ST R6, DispSaveR6
    ST R7, DispSaveR7
;---load initial values
    AND R1, R1, #0              ; set counter to zero
    LD R3, DISP_18              ; put 18 in R3
    LD R5, DISP_48              ; put 48 in R5
;---print first two lines of grid
    LEA R0, DISP_NEWLINE        ; new line
    TRAP x22
    LEA R0, DISP_COLNUMS        ; print column numbers
    TRAP x22
    LEA R0, DISP_NEWLINE        ; new line
    TRAP x22
    LEA R0, DISP_PLUSLINE       ; print first row
    TRAP x22
    LEA R0, DISP_NEWLINE        ; new line
    TRAP x22
    LD R2, DISP_GRIDADDR        ; load grid address

dispLoop
;---print row number and space
    AND R0, R0, #0
    ADD R0, R1, #0
    ADD R0, R0, R5              ; print row number
    TRAP x21
    LEA R0, DISP_SPACE          ; print space
    TRAP x22
;---print row with |
    AND R0, R0, #0              ; print first line of pattern
    ADD R0, R2, #0
    TRAP x22
    ADD R2, R2, R3
    LEA R0, DISP_NEWLINE        ; new line
    TRAP x22
;---print row with +
    LEA R0, DISP_SPACE          ; add two spaces
    TRAP x22
    LEA R0, DISP_SPACE
    TRAP x22
    AND R0, R0, #0              ; print second line of pattern
    ADD R0, R2, #0
    TRAP x22
    ADD R2, R2, R3
    LEA R0, DISP_NEWLINE        ; new line
    TRAP x22
;---check if R1 = 8
    LD R4, DISP_8               ; R4 holds value 8
    ADD R1, R1, #1              ; increment R1 (counter)
    AND R6, R6, #0              ; clear R6
    ADD R6, R1, #0              ; put R1 in R6
    NOT R6, R6                  ; make R6 negative
    ADD R6, R6, #1
    ADD R4, R4, R6              ; add R4 and R6
    BRp dispLoop                ; pos sum = final row not yet reached
;---callee restores
    LD R0, DispSaveR0
    LD R1, DispSaveR1
    LD R2, DispSaveR2
    LD R3, DispSaveR3
    LD R4, DispSaveR4
    LD R5, DispSaveR5
    LD R6, DispSaveR6
    LD R7, DispSaveR7
    
    JMP R7

; .FILLs
DISP_GRIDADDR   .FILL x40B6
DISP_18         .FILL #18
DISP_8          .FILL #8
DISP_48         .FILL #48
; STRINGZ Declarations
DISP_COLNUMS    .STRINGZ "   0 1 2 3 4 5 6 7 "
DISP_PLUSLINE   .STRINGZ "  +-+-+-+-+-+-+-+-+"
DISP_NEWLINE    .STRINGZ "\n"
DISP_SPACE      .STRINGZ " "
    DispSaveR0  .BLKW #1
    DispSaveR1  .BLKW #1
    DispSaveR2  .BLKW #1
    DispSaveR3  .BLKW #1
    DispSaveR4  .BLKW #1
    DispSaveR5  .BLKW #1
    DispSaveR6  .BLKW #1
    DispSaveR7  .BLKW #1
;***********************************************************
; LOAD_JUNGLE
; Input:  R0  has the address of the head of a linked list of
;         gridblock records. Each record has four fields:
;       0. Address of the next gridblock in the list
;       1. row # (0-7)
;       2. col # (0-7)
;       3. Symbol (can be I->Initial,H->Home or #->Hyena)
;    The list is guaranteed to: 
;               * have only one Inital and one Home gridblock
;               * have zero or more gridboxes with Hyenas
;               * be terminated by a gridblock whose next address 
;                 field is a zero
; Output: None
;   This function loads the JUNGLE from a linked list by inserting 
;   the appropriate characters in boxes (I(*),#,H)
;   You must also change the contents of these
;   locations: 
;        1.  (CURRENT_ROW, CURRENT_COL) to hold the (row, col) 
;            numbers of Simba's Initial gridblock
;        2.  (HOME_ROW, HOME_COL) to hold the (row, col) 
;            numbers of the Home gridblock
;       
;***********************************************************
LOAD_JUNGLE 
;---callee saves
    ST R1, LoadSaveR1
    ST R2, LoadSaveR2
    ST R3, LoadSaveR3
    ST R4, LoadSaveR4
    ST R5, LoadSaveR5
    ST R6, LoadSaveR6
    ST R7, LoadSaveR7
;---check if empty grid
    ADD R0, R0, #0
    BRz gridDone

gridLoop
;---load head link address
    AND R5, R5, #0
    ADD R5, R5, R0
;---load first link    
    LDR R1, R5, #1
    LDR R2, R5, #2
    LDR R3, R5, #3
;---if symbol is an "H" store home row and col
    LD R6, LOAD_n72             ; load -72 into R6
    ADD R6, R6, R3              ; if sum is 0, value is H
    BRnp #2
    ST R1, HOME_ROW             ; store home row
    ST R2, HOME_COL             ; store home col
;---if symbol is an "I" change it to an asterisk
    LDR R3, R5, #3
    LD R6, LOAD_n73             ; load -73 into R6
    ADD R6, R6, R3              ; if sum is 0, value is I
    BRnp #4
    AND R3, R3, #0
    LD R3, LOAD_ASTERISK        ; load an asterisk
    ST R1, CURRENT_ROW          ; store current row
    ST R2, CURRENT_COL          ; store current col
;---store symbol in grid
    JSR GRID_ADDRESS            ; load grid address calculator
    STR R3, R0, #0              ; store symbol into grid
    LDR R4, R5, #0              ; load new link address into R4
;---determine whether sentinel is reached
    BRz gridDone                ; if address is 0, done
    AND R0, R0, #0              ; else, repeat with next link
    ADD R0, R0, R4
    BR gridLoop

;---callee restores
gridDone
    LD R1, LoadSaveR1
    LD R2, LoadSaveR2
    LD R3, LoadSaveR3
    LD R4, LoadSaveR4
    LD R5, LoadSaveR5
    LD R6, LoadSaveR6
    LD R7, LoadSaveR7
    
    JMP R7

; .FILLs
LOAD_n73        .FILL #-73
LOAD_n72        .FILL #-72
LOAD_ASTERISK   .FILL x002A
    FindHSave   .BLKW #1
    LoadSaveR1  .BLKW #1
    LoadSaveR2  .BLKW #1
    LoadSaveR3  .BLKW #1
    LoadSaveR4  .BLKW #1
    LoadSaveR5  .BLKW #1
    LoadSaveR6  .BLKW #1
    LoadSaveR7  .BLKW #1
;***********************************************************
; GRID_ADDRESS
; Input:  R1 has the row number (0-7)
;         R2 has the column number (0-7)
; Output: R0 has the corresponding address of the space in the GRID
; Notes: This is a key routine.  It translates the (row, col) logical 
;        GRID coordinates of a gridblock to the physical address in 
;        the GRID memory.
;***********************************************************
GRID_ADDRESS     
;---callee saves
    ST R3, AddrSaveR3
    ST R4, AddrSaveR4
    ST R5, AddrSaveR5
    ST R7, AddrSaveR7
;---load initial address
    AND R0, R0, #0
    LD R0, GRID_START
;---calculate and add row spaces to address
    AND R3, R3, #0
    LD R3, GRID_36              ; load 36 into R3
    AND R4, R4, #0              
    ADD R4, R4, R1              ; put row number into R4
    JSR MULTIPLY                ; multiply R3 and R4
    ADD R0, R0, R5              ; add contribution to address
;---calculate and add column spaces to address
    AND R3, R3, #0
    ADD R3, R3, #2              ; put 2 in R3
    AND R4, R4, #0
    ADD R4, R4, R2              ; put col number into R4
    JSR MULTIPLY                ; multiply R3 and R4
    ADD R0, R0, R5              ; add contribution to address
;---callee restores
    LD R3, AddrSaveR3
    LD R4, AddrSaveR4
    LD R5, AddrSaveR5
    LD R7, AddrSaveR7
    
    JMP R7

; .FILLs
GRID_START      .FILL x40B7
GRID_36         .FILL #36
    AddrSaveR3  .BLKW #1
    AddrSaveR4  .BLKW #1
    AddrSaveR5  .BLKW #1
    AddrSaveR7  .BLKW #1
;***********************************************************
; MULTIPLY
; Input:  R3 has the first number to multiply
;         R4 has the second number to multiply
; Output: R5 has the product of the two numbers
;***********************************************************
MULTIPLY     
;---callee saves
    ST R1, MultSaveR1
    ST R2, MultSaveR2
    ST R7, MultSaveR7
;---- Initialize values
	AND	R5,R5,#0	; Clear R0 as it holds the result
    AND R1,R1,#0
    AND R2,R2,#0
    ADD R1,R1,R3
    ADD R2,R2,R4
;---- Check if R1 or R2 is 0
	ADD R1,R1,#0	; Add 0 to R1
	BRz D 			; If R1 is 0, skip to end
	ADD R2,R2,#0	; Add 0 to R2
	BRz D			; If R2 is 0, skip to end
;---- Flip the signs of R1 and R2
	NOT R1,R1		; Flip R1 bits
	ADD R1,R1,#1	; Add 1
	NOT R2,R2		; Flip R2 bits
	ADD R2,R2,#1	; Add 1
;---- Branch back to sign flip section is R2 is negative
	ADD R2,R2,#0	; Add 0 to R2
	BRn #-6			; Check if R2 is negative
;---- Add R1 to R0 until R2 is 0
	ADD R5,R5,R1	; Update cumulative sum
	ADD R2,R2,#-1	; Decrement R2
	BRp #-3			; Continue updating sum if R2 is positive
;---- Done
D   LD R1, MultSaveR1
    LD R2, MultSaveR2
    LD R7, MultSaveR7

    JMP R7

;---callee restores
    MultSaveR1  .BLKW #1
    MultSaveR2  .BLKW #1
    MultSaveR7  .BLKW #1
;***********************************************************
; IS_INPUT_VALID
; Input: R0 has the move (character i,j,k,l)
; Output: R2  zero if valid; -1 if invalid
; Notes: Validates move to make sure it is one of i,j,k,l
;        Only checks if a valid character is entered
;***********************************************************
IS_INPUT_VALID
;---callee saves      
    ST R0, ValidSaveR0
    ST R1, ValidSaveR1
    ST R3, ValidSaveR3
    ST R7, ValidSaveR7
    AND R2, R2, #0
    AND R3, R3, #0
;---convert to 0, 1, 2, 3
    JSR CONVERT
    AND R1, R1, #0
    ADD R1, R1, R0
    ADD R3, R3, #-3

validCheck
;---check if R1 is zero
    ADD R1, R1, #0
    BRz validDone
    ADD R3, R3, #0
    BRz validNo
    ADD R1, R1, #-1
    ADD R3, R3, #1
    BR validCheck

validNo
;---if input is invalid
    NOT R2, R2

validDone
;---callee restores
    LD R0, ValidSaveR0
    LD R1, ValidSaveR1
    LD R3, ValidSaveR3
    LD R7, ValidSaveR7
    
    JMP R7

    ValidSaveR0  .BLKW #1
    ValidSaveR1  .BLKW #1
    ValidSaveR3  .BLKW #1
    ValidSaveR7  .BLKW #1
;***********************************************************
; SAFE_MOVE
; Input: R0 has 'i','j','k','l'
; Output: R1, R2 have the new row and col if the move is safe
;         If the move is unsafe, that is, the move would 
;         take Simba to a Hyena or outside the Grid then 
;         return R1=-1 
; Notes: Translates user entered move to actual row and column
;        Also checks the contents of the intended space to
;        move to in determining if the move is safe
;        Calls GRID_ADDRESS
;        This subroutine does not check if the input (R0) is 
;        valid. This functionality is implemented elsewhere.
;***********************************************************
SAFE_MOVE
;---callee saves
    ST R0, SafeSaveR0
    ST R3, SafeSaveR3
    ST R4, SafeSaveR4
    ST R5, SafeSaveR5
    ST R6, SafeSaveR6
    ST R7, SafeSaveR7
;---convert move to 0-3 input and initialize registers
    LDI R1, CURRENT_ROW3
    LDI R2, CURRENT_COL3
    JSR CONVERT

safeUp
;---check if it is safe to go up
    ADD R0, R0, #0
    BRnp safeLeft       ; if not i, go to next section
;---grid address for possible move
    JSR GRID_ADDRESS
    LD R3, SAFE_n36     ; load -36 into R3
    ADD R0, R0, R3      ; subract 36 from address
    LDR R4, R0, #0      ; if 0, outside grid
;---check if space
    LD R5, SAFE_n32     ; load -32 into R5
    ADD R5, R5, R4      ; add R4 and R5
    BRz safeUpDone      ; if 0, space, so safe
;---check if home
    LDR R4, R0, #0      ; reload R4
    LD R5, SAFE_n72     ; load -72 into R5
    ADD R5, R5, R4      ; add R4 and R5
    BRz safeUpDone      ; if 0, home, so safe
    BR safeNo
safeUpDone
    ADD R1, R1, #-1     ; new row
    BR safeDone

safeLeft
;---check if it is safe to go left
    AND R6, R6, #0      ; if not j, go to next section
    ADD R6, R6, #-1
    ADD R6, R6, R0
    BRnp safeDown
;---grid address for possible move
    JSR GRID_ADDRESS
    ADD R0, R0, #-2     ; decrease memory address by 2
    LDR R4, R0, #0      ; if 0, outside grid
;---check if space
    LD R5, SAFE_n32     ; load -32 into R5
    ADD R5, R5, R4      ; add R4 and R5
    BRz safeLeftDone    ; if 0, space, so safe
;---check if home
    LDR R4, R0, #0      ; reload R4
    LD R5, SAFE_n72     ; load -72 into R5
    ADD R5, R5, R4      ; add R4 and R5
    BRz safeLeftDone    ; if 0, home, so safe
    BR safeNo
safeLeftDone
    ADD R2, R2, #-1     ; new col
    BR safeDone

safeDown
;---check if it is safe to go down
    AND R6, R6, #0      ; if not k, go to next section
    ADD R6, R6, #-2
    ADD R6, R6, R0
    BRnp safeRight
;---grid address for possible move
    JSR GRID_ADDRESS
    LD R3, SAFE_36      ; load 36 into R3
    ADD R0, R0, R3      ; add 36 from address
    LDR R4, R0, #0      ; if 0, outside grid
;---check if space
    LD R5, SAFE_n32     ; load -32 into R5
    ADD R5, R5, R4      ; add R4 and R5
    BRz safeDownDone        ; if 0, space, so safe
;---check if home
    LDR R4, R0, #0      ; reload R4
    LD R5, SAFE_n72     ; load -72 into R5
    ADD R5, R5, R4      ; add R4 and R5
    BRz safeDownDone    ; if 0, home, so safe
    BR safeNo
safeDownDone
    ADD R1, R1, #1      ; new row
    BR safeDone

safeRight
;---grid address for possible move
    JSR GRID_ADDRESS
    ADD R0, R0, #2      ; increase memory address by 2
    LDR R4, R0, #0      ; if 0, outside grid
;---check if space
    LD R5, SAFE_n32     ; load -32 into R5
    ADD R5, R5, R4      ; add R4 and R5
    BRz safeRightDone   ; if 0, space, so safe
;---check if home
    LDR R4, R0, #0      ; reload R4
    LD R5, SAFE_n72     ; load -72 into R5
    ADD R5, R5, R4      ; add R4 and R5
    BRz safeRightDone   ; if 0, home, so safe
    BR safeNo
safeRightDone
    ADD R2, R2, #1      ; new col
    BR safeDone

safeNo
    AND R1, R1, #0
    NOT R1, R1

safeDone
;---callee restores
    LD R0, SafeSaveR0
    LD R3, SafeSaveR3
    LD R4, SafeSaveR4
    LD R5, SafeSaveR5
    LD R6, SafeSaveR6
    LD R7, SafeSaveR7
    
    JMP R7

SAFE_36         .FILL #36
SAFE_n36        .FILL #-36
SAFE_n32        .FILL #-32
SAFE_n72        .FILL #-72
CURRENT_ROW3    .FILL CURRENT_ROW
CURRENT_COL3    .FILL CURRENT_COL
    SafeSaveR0  .BLKW #1
    SafeSaveR3  .BLKW #1
    SafeSaveR4  .BLKW #1
    SafeSaveR5  .BLKW #1
    SafeSaveR6  .BLKW #1
    SafeSaveR7  .BLKW #1
;***********************************************************
; APPLY_MOVE
; This subroutine makes the move if it can be completed. 
; It checks to see if the movement is safe by calling 
; SAFE_MOVE which returns the coordinates of where the move 
; goes (or -1 if movement is unsafe as detailed below). 
; If the move is Safe then this routine moves the player 
; symbol to the new coordinates and clears any walls (|'s and -'s) 
; as necessary for the movement to take place. 
; If the movement is unsafe, output a console message of your 
; choice and return. 
; Input:  R0 has move (i or j or k or l)
; Output: None; However must update the GRID and 
;               change CURRENT_ROW and CURRENT_COL 
;               if move can be successfully applied.
; Notes:  Calls SAFE_MOVE and GRID_ADDRESS
;***********************************************************
APPLY_MOVE   
;---callee saves      
    ST R0, ApplySaveR0
    ST R1, ApplySaveR1
    ST R2, ApplySaveR2
    ST R3, ApplySaveR3
    ST R4, ApplySaveR4
    ST R5, ApplySaveR5
    ST R6, ApplySaveR6
    ST R7, ApplySaveR7
;---check if move is safe and if unsafe, output console message
    JSR SAFE_MOVE
    ADD R1, R1, #0
    BRn applyNotSafe
;---put new row and col in R3 and R4
    AND R3, R3, #0
    ADD R3, R3, R1
    AND R4, R4, #0
    ADD R4, R4, R2
;---determine which move is occurring
    LDI R1, CURRENT_ROW2
    LDI R2, CURRENT_COL2
    JSR CONVERT

applyUp
;---go up
    ADD R0, R0, #0
    BRnp applyLeft      ; if not i, go to next section
    
    JSR GRID_ADDRESS    ; grab current grid address
    LD R5, APPLY_SPACE  ; load space
    STR R5, R0, #0      ; put space in current grid address
    LD R5, APPLY_n18    ; load -18
    ADD R0, R0, R5      ; decrease grid address by 18
    LD R5, APPLY_SPACE  ; load space
    STR R5, R0, #0      ; clear wall

    AND R1, R1, #0      ; clear and put new row loc in R1
    ADD R1, R1, R3
    AND R2, R2, #0      ; clear and put new col loc in R2
    ADD R2, R2, R4
    JSR GRID_ADDRESS    ; grab new grid address
    LD R5, APPLY_ASTERISK
    STR R5, R0, #0      ; put asterisk in new address
    BR applyDone
    
applyLeft
;---go left
    AND R6, R6, #0      ; if not j, go to next section
    ADD R6, R6, #-1
    ADD R6, R6, R0
    BRnp applyDown

    JSR GRID_ADDRESS    ; grab current grid address
    LD R5, APPLY_SPACE  ; load space
    STR R5, R0, #0      ; put space in current grid address
    ADD R0, R0, #-1     ; decrease grid address by 1
    LD R5, APPLY_SPACE  ; load space
    STR R5, R0, #0      ; clear wall

    AND R1, R1, #0      ; clear and put new row loc in R1
    ADD R1, R1, R3
    AND R2, R2, #0      ; clear and put new col loc in R2
    ADD R2, R2, R4
    JSR GRID_ADDRESS    ; grab new grid address
    LD R5, APPLY_ASTERISK
    STR R5, R0, #0      ; put asterisk in new address
    BR applyDone
    
applyDown
;---go down
    AND R6, R6, #0      ; if not k, go to next section
    ADD R6, R6, #-2
    ADD R6, R6, R0
    BRnp applyRight

    JSR GRID_ADDRESS    ; grab current grid address
    LD R5, APPLY_SPACE  ; load space
    STR R5, R0, #0      ; put space in current grid address
    LD R5, APPLY_18     ; load 18
    ADD R0, R0, R5      ; increase grid address by 18
    LD R5, APPLY_SPACE  ; load space
    STR R5, R0, #0      ; clear wall

    AND R1, R1, #0      ; clear and put new row loc in R1
    ADD R1, R1, R3
    AND R2, R2, #0      ; clear and put new col loc in R2
    ADD R2, R2, R4
    JSR GRID_ADDRESS    ; grab new grid address
    LD R5, APPLY_ASTERISK
    STR R5, R0, #0      ; put asterisk in new address
    BR applyDone

applyRight
;---go right
    JSR GRID_ADDRESS    ; grab current grid address
    LD R5, APPLY_SPACE  ; load space
    STR R5, R0, #0      ; put space in current grid address
    ADD R0, R0, #1      ; increase grid address by 1
    LD R5, APPLY_SPACE  ; load space
    STR R5, R0, #0      ; clear wall

    AND R1, R1, #0      ; clear and put new row loc in R1
    ADD R1, R1, R3
    AND R2, R2, #0      ; clear and put new col loc in R2
    ADD R2, R2, R4
    JSR GRID_ADDRESS    ; grab new grid address
    LD R5, APPLY_ASTERISK
    STR R5, R0, #0      ; put asterisk in new address
    BR applyDone
   
applyDone
    STI R1, CURRENT_ROW2
    STI R2, CURRENT_COL2
    BR applyStore

applyNotSafe
;---outputs a console message if the user's move is unsafe
    LEA R0, APPLY_NOTSAFE
    TRAP x22

applyStore
;---callee restores
    LD R0, ApplySaveR0
    LD R1, ApplySaveR1
    LD R2, ApplySaveR2
    LD R3, ApplySaveR3
    LD R4, ApplySaveR4
    LD R5, ApplySaveR5
    LD R6, ApplySaveR6
    LD R7, ApplySaveR7
    
    JMP R7

APPLY_NOTSAFE    .STRINGZ "\nHold your horses buddy, that's not a safe move!\nTry again.\n"
APPLY_SPACE      .FILL #32
APPLY_18         .FILL #18
APPLY_n18        .FILL #-18
APPLY_ASTERISK   .FILL x002A
    ApplySaveR0  .BLKW #1
    ApplySaveR1  .BLKW #1
    ApplySaveR2  .BLKW #1
    ApplySaveR3  .BLKW #1
    ApplySaveR4  .BLKW #1
    ApplySaveR5  .BLKW #1
    ApplySaveR6  .BLKW #1
    ApplySaveR7  .BLKW #1
;***********************************************************
; IS_SIMBA_HOME
; Checks to see if Simba has reached Home.
; Input:  None
; Output: R2 is zero if Simba is Home; -1 otherwise
;***********************************************************
IS_SIMBA_HOME
;---callee saves      
    ST R0, HomeSaveR0
    ST R1, HomeSaveR1
    ST R3, HomeSaveR3
    ST R4, HomeSaveR4
    ST R5, HomeSaveR5
    ST R6, HomeSaveR6
    ST R7, HomeSaveR7
;---initialize current row and col values
    AND R0, R0, #0
    LDI R0, CURRENT_ROW2
    AND R1, R1, #0
    LDI R1, CURRENT_COL2
;---initialize home row and col values
    AND R4, R4, #0
    LDI R4, HOME_ROW2
    AND R5, R5, #0
    LDI R5, HOME_COL2
;---check if same row
    AND R6, R6, #0
    NOT R6, R0
    ADD R6, R6, #1
    ADD R6, R6, R4
    BRnp homeNot
;---check if same col
    AND R6, R6, #0
    NOT R6, R1
    ADD R6, R6, #1
    ADD R6, R6, R5
    BRnp homeNot
;---store 0 in R2 if at home
    AND R2, R2, #0
    BR homeDone

homeNot
    AND R2, R2, #0
    NOT R2, R2

homeDone
;---callee restores
    LD R0, HomeSaveR0
    LD R1, HomeSaveR1
    LD R3, HomeSaveR3
    LD R4, HomeSaveR4
    LD R5, HomeSaveR5
    LD R6, HomeSaveR6
    LD R7, HomeSaveR7
    
    JMP R7

CURRENT_ROW2    .FILL CURRENT_ROW
CURRENT_COL2    .FILL CURRENT_COL
HOME_ROW2       .FILL HOME_ROW
HOME_COL2       .FILL HOME_COL
    HomeSaveR0  .BLKW #1
    HomeSaveR1  .BLKW #1
    HomeSaveR3  .BLKW #1
    HomeSaveR4  .BLKW #1
    HomeSaveR5  .BLKW #1
    HomeSaveR6  .BLKW #1
    HomeSaveR7  .BLKW #1
;***********************************************************
; CONVERT
; Input:  R0 has the hex value keystroke
; Output: R0 has the value of the keystroke converted to
;         0, 1, 2, or 3
; Notes: 'i'=up=0, 'j'=left=1, 'k'=down=2, 'l'=right=3
;***********************************************************
CONVERT
;---callee saves
    ST R1, ConvSaveR1
    ST R7, ConvSaveR7
;---convert input keystroke
    LD R1, CONV_n69
    ADD R0, R0, R1
;---callee restores
    LD R1, ConvSaveR1
    LD R7, ConvSaveR7

    JMP R7

; .FILLs
CONV_n69    .FILL #-105
    ConvSaveR1  .BLKW #1
    ConvSaveR7  .BLKW #1

    .END

; This section has the linked list for the
; Jungle's layout: #(0,1)->H(4,7)->I(2,1)->#(1,1)->#(6,3)->#(3,5)->#(4,4)->#(5,6)

	.ORIG	x5000
	.FILL	Head  ; Holds the address of the first record in the linked-list (Head)
blk2
	.FILL   blk4
    .FILL   #1
	.FILL   #1
	.FILL   x23
Head
	.FILL	blk1
    .FILL   #0
	.FILL   #1
	.FILL   x23
blk1
	.FILL   blk3
	.FILL   #4
	.FILL   #7
	.FILL   x48
blk3
	.FILL   blk2
	.FILL   #2
	.FILL   #1
	.FILL   x49
blk4
	.FILL   blk5
	.FILL   #6
	.FILL   #3
	.FILL   x23
blk7
	.FILL   #0
	.FILL   #5
	.FILL   #6
	.FILL   x23
blk6
	.FILL   blk7
	.FILL   #4
	.FILL   #4
	.FILL   x23
blk5
	.FILL   blk6
	.FILL   #3
	.FILL   #5
	.FILL   x23
	.END
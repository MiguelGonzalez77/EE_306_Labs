;***********************************************************
; Programming Assignment 3
; Student Name: Miguel Gonzalez
; UT Eid: mag9688
; Simba in the Jungle
; This is the starter code. You are given the main program
; and some declarations. The subroutines you are responsible for
; are given as empty stubs at the bottom. Follow the contract. 
; You are free to rearrange your subroutines if the need were to 
; arise.
; Note: Remember "Callee-Saves" (Cleans its own mess)

;***********************************************************

.ORIG x3000

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
    TRAP  x25                        ; halt
JUNGLE_LOADED       .STRINGZ "\nJungle Loaded\n"
JUNGLE_INITIAL      .STRINGZ "\nJungle Initial\n"
BLOCKS          .FILL x5000

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
    LD R3, Disp_18              ; put 18 in R3
    LD R5, Disp_48              ; put 48 in R5
;---print first two lines of grid
    LEA R0, Disp_NewLine        ; new line
    TRAP x22
    LEA R0, Disp_Columns        ; print column numbers
    TRAP x22
    LEA R0, Disp_NewLine        ; new line
    TRAP x22
    LEA R0, Disp_PlusLine       ; print first row
    TRAP x22
    LEA R0, Disp_NewLine        ; new line
    TRAP x22
    LD R2, Disp_GridAddr        ; load grid address

dispLoop
;---print row number and space
    AND R0, R0, #0
    ADD R0, R1, #0
    ADD R0, R0, R5              ; print row number
    TRAP x21
    LEA R0, Disp_Space         ; print space
    TRAP x22
;---print row with |
    AND R0, R0, #0              ; print first line of pattern
    ADD R0, R2, #0
    TRAP x22
    ADD R2, R2, R3
    LEA R0, Disp_NewLine        ; new line
    TRAP x22
;---print row with +-
    LEA R0, Disp_Space         ; add two spaces
    TRAP x22
    LEA R0, Disp_Space
    TRAP x22
    AND R0, R0, #0              ; print second line of pattern
    ADD R0, R2, #0
    TRAP x22
    ADD R2, R2, R3
    LEA R0, Disp_NewLine        ; new line
    TRAP x22
;---check if R1 = 8
    LD R4, Disp_8               ; R4 holds value 8
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
Disp_GridAddr   .FILL x303D
Disp_18         .FILL #18
Disp_8          .FILL #8
Disp_48         .FILL #48
; STRINGZ Declarations
Disp_Columns    .STRINGZ "   0 1 2 3 4 5 6 7 "
Disp_PlusLine   .STRINGZ "  +-+-+-+-+-+-+-+-+"
Disp_NewLine    .STRINGZ "\n"
Disp_Space      .STRINGZ " "
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
    LD R6, Load_n72             ; load -72 into R6
    ADD R6, R6, R3              ; if sum is 0, value is H
    BRnp #2
    ST R1, HOME_ROW             ; store home row
    ST R2, HOME_COL             ; store home col
;---if symbol is an "I" change it to an asterisk
    LD R6, Load_n73             ; load -73 into R6
    ADD R6, R6, R3              ; if sum is 0, value is I
    BRnp #4
    AND R3, R3, #0
    LD R3, Load_Aster        ; load an asterisk
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

gridDone
;---callee restores
    LD R1, LoadSaveR1
    LD R2, LoadSaveR2
    LD R3, LoadSaveR3
    LD R4, LoadSaveR4
    LD R5, LoadSaveR5
    LD R6, LoadSaveR6
    LD R7, LoadSaveR7
    
    JMP R7

; .FILLs
Load_n73        .FILL #-73
Load_n72        .FILL #-72
Load_Aster      .FILL x002A
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
    JSR MULTI                ; multiply R3 and R4
    ADD R0, R0, R5              ; add contribution to address
;---calculate and add column spaces to address
    AND R3, R3, #0
    ADD R3, R3, #2              ; put 2 in R3
    AND R4, R4, #0
    ADD R4, R4, R2              ; put col number into R4
    JSR MULTI                ; multiply R3 and R4
    ADD R0, R0, R5              ; add contribution to address
;---callee restores
    LD R3, AddrSaveR3
    LD R4, AddrSaveR4
    LD R5, AddrSaveR5
    LD R7, AddrSaveR7
    
    JMP R7

; .FILLs
GRID_START      .FILL x303E
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
MULTI     
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
	BRz Fin			; If R1 is 0, skip to end
	ADD R2,R2,#0	; Add 0 to R2
	BRz Fin			; If R2 is 0, skip to end
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
Fin   LD R1, MultSaveR1
    LD R2, MultSaveR2
    LD R7, MultSaveR7
    
    JMP R7

;---callee restores
    MultSaveR1  .BLKW #1
    MultSaveR2  .BLKW #1
    MultSaveR7  .BLKW #1

    .END

; This section has the linked list for the
; Jungle's layout: #(0,1)->H(4,7)->I(2,1)->#(1,1)->#(6,3)->#(3,5)->#(4,4)->#(5,6)

    	.ORIG	x5000
	.FILL	Head   ; Holds the address of the first record in the linked-list (Head)
blk2
	.FILL   blk4
    .FILL	#1
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
	
	
	
	
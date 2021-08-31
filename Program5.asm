; Program5.asm
; Name(s): Miguel Gonzalez and Tadilo Demisie
; UTEid(s): mag9688 and tmd2446
; Continuously reads from x3600 making sure its not reading duplicate
; symbols. Processes the symbol based on the program description
; of mRNA processing.
.ORIG x3000
    LD  R6, SP
; set up the keyboard interrupt vector table entry
    LD  R0, KBISR       ; M[x0180] <- x2600
    STI R0, KBINTVec
; enable keyboard interrupts
; KBSR[14] <- 1 ==== M[xFE00] = x4000
    LDI	R1,	KBSR
    LD  R2, KBINTEN

    NOT	R1,	R1
    NOT R2, R2
    AND	R3,	R1,	R2
    NOT R3, R3          ; A + B = (A'B')'

    STI	R3,	KBSR
; start of actual program
; This loop is the proper way to read an input
State_1
    JSR	INPUT           ; Grabs the new input
    LD  R1, A_CHAR
    ADD	R1,	R1,	R0
    BRz	State_2         ; State 1 & 'A' = State 2
    BRnzp	State_1     ; State 1 & 'C'|'G'|'U' = State 1
State_2
    JSR INPUT
    LD  R1, U_CHAR
    ADD R1, R1, R0
    BRz	State_3         ; State 2 & 'U' = State 3
    LD  R1, A_CHAR
    ADD R1, R1, R0
    BRz	State_2         ; State 2 & 'A' = State 2
    BRnzp   State_1     ; State 2 & 'C'|'G' = State 1
State_3
    JSR INPUT
    LD  R1, A_CHAR
    ADD R1, R1, R0
    BRz	State_2         ; State 3 & 'A' = State 2
    LD  R1, G_CHAR
    ADD R1, R1, R0
    BRnp	State_1     ; State 3 & 'C'|'U' = State 1
State_4                 ; State 3 & 'G' = State 4
    LEA R0, PIPE
    TRAP    x22         ; Output '|'
    JSR INPUT
    LD  R1, U_CHAR
    ADD R1, R1, R0
    BRz State_6         ; State 4 & 'U' = State 6
State_5
    JSR INPUT
    LD  R1, U_CHAR
    ADD R1, R1, R0
    BRz	State_6         ; State 5 & 'U' = State 6
    BRnzp	State_5     ; State 5 & 'A'|'C'|'G' = State 5
State_6
    JSR INPUT
    LD  R1, C_CHAR
    ADD R1, R1, R0
    BRz	State_5         ; State 6 & 'C' = State 5
    LD  R1, A_CHAR
    ADD R1, R1, R0
    BRz State_7a        ; State 6 & 'A' = State 7a
    LD  R1, G_CHAR
    ADD R1, R1, R0
    BRz State_7b        ; State 6 & 'G' = State 7b
    BRnzp State_6       ; State 6 & 'U' = State 6
State_7a
    JSR INPUT
    LD R1, U_CHAR
    ADD R1, R1, R0
    BRz State_6         ; State 7a & 'U' = State 6
    LD R1, C_CHAR
    ADD R1, R1, R0
    BRz State_5         ; State 7a & 'C' = State 5
    BRnzp State_8       ; State 7a & 'A'|'G'
State_7b
    JSR INPUT
    LD	R1,	U_CHAR
    ADD R1, R1, R0
    BRz	State_6         ; State 7b & 'U' = State 6
    LD R1, A_CHAR
    ADD R1, R1, R0
    BRz State_8         ; State 7b & 'A' = State 8
    BRnzp State_5       ; State 7b & 'C'|'G' = State 5
State_8
; Process it
    TRAP	x25

SP  .FILL	x3000
KBINTVec .FILL	x0180
KBISR   .FILL	x2600
KBSR    .FILL	xFE00
KBDR    .FILL	xFE02
KBINTEN    .FILL	x4000              ; Mask for KBSR[14] = 1
GLOBAL  .FILL	x3600
A_CHAR  .FILL	x-41
C_CHAR  .FILL	x-43
G_CHAR  .FILL	x-47
U_CHAR  .FILL	x-55
PIPE    .STRINGZ	"|"


; INPUT
; Returns the inputted character in R0
; if it's a new character (waits if not)
INPUT
    ST  R1, In_Save_R1
    ST  R7, In_Save_R7
    LDI	R0,	GLOBAL
    BRz INPUT
    AND	R1,	R1,	#0
    STI R1, GLOBAL      ; Writes a 0 to global
    TRAP    x21         ; Displays character if valid
    LD  R1, In_Save_R1
    LD  R7, In_Save_R7
    JMP	R7
In_Save_R1 .BLKW #1
In_Save_R7 .BLKW #1

; Repeat unil Stop Codon detected

.END
; end of main program


; Interrupt Service Routine
; Keyboard ISR runs when a key is struck
; Checks for a valid RNA symbol and places it at x3600
.ORIG x2600
    ST R1, SaveR1
    ST R2, SaveR2
    LDI R1, KBDR2
Check_A
    LD	R2,	A_CHARACTER
    ADD	R2,	R2,	R1
    BRz Valid
Check_C
    LD  R2, C_CHARACTER
    ADD R2, R2, R1
    BRz Valid
Check_G
    LD  R2, G_CHARACTER
    ADD R2, R2, R1
    BRz Valid
Check_U
    LD  R2, U_CHARACTER
    ADD R2, R2, R1
    BRz Valid
Invalid
    BRnzp	Done
Valid
    STI	R1,	GLOBAL2
Done
    LD R1, SaveR1
    LD R2, SaveR2
    RTI
SaveR1  .BLKW   #1
SaveR2  .BLKW   #1
KBDR2    .FILL   xFE02
GLOBAL2  .FILL   x3600
A_CHARACTER  .FILL	x-41
C_CHARACTER  .FILL	x-43
G_CHARACTER  .FILL	x-47
U_CHARACTER  .FILL	x-55
.END
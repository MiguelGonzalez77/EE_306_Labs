; Programming Project 1 starter file
; Student Name  : Miguel Gonzalez
; UTEid: mag9688
; Modify this code to satisfy the requirements of Project 1
; left-rotate a 16-bit number N by B bit positions. 
; N is at x30FF; B is is x3100; put result at x3101
; Read the complete Project Description on Canvas

	.ORIG x3000
	;R0 <- time to rotate
	;R1 <- Number
	LDI R0, Rotate
	LDI R1, Number
loop
    ;Is R0 Positive
    ADD R0, R0, #0
    BRp continue
    
    ;Store Result
    LD R3, Number; R3 <- x30FF
    STR R1, R3, #2
    
    ;Finish
    TRAP x25
    
Continue
    ;is R1 Negative
    ADD R1, R1, #0 ; R1 = R1 + 0
    BRn Negative
    ADD R1, R1, R1
    BRnzp Decrement
Negative
    ADD R1, R1, R1
    ADD R1, R1, #1
Decrement
    ADD R0, R0, #-1
    BRnzp loop
    Rotate .FILL x3100
    Number .FILL x30FF
    
    .END
    

  
    


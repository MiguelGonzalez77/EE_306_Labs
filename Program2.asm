; Programming Assignment 2
; Student Name: Miguel Gonzalez
; UT Eid: mag9688
; Linked List creation from array. Insertion into the list
; You are given an array of student records starting at location x3500.
; The array is terminated by a sentinel. Each student record in the array
; has two fields:
;      Score -  A value between 0 and 100
;      Address of Name  -  A value which is the address of a location in memory where
;                          this student's name is stored.
; The end of the array is indicated by the sentinel record whose Score is -1
; The array itself is unordered meaning that the student records dont follow
; any ordering by score or name.
; You are to perform two tasks:
; Task 1: Sort the array in decreasing order of Score. Highest score first.
; Task 2: You are given a name (string) at location x6000, You have to lookup this student 
;         in the linked list (post Task1) and put the student's score at x5FFF (i.e., in front of the name)
;         If the student is not in the list then a score of -1 must be written to x5FFF
; Notes:
;       * If two students have the same score then keep their relative order as
;         in the original array.
;       * Names are case-sensitive.

	.ORIG	x3000

;	SORT
start
	LD R1, begin	; start at x3500

check				
	LDR R2, R1, #0	; load initial value
	BRn search		; check if sentinel

load				
	LDR R2, R1, #0	; holds grade 1
	LDR R3, R1, #1	; holds stu 1
	LDR R4, R1, #2	; holds grade 2
	BRn search		; if sentinel, done. go to search
	LDR R5, R1, #3	; holds stu 2
	BR compare		; compare the two values

compare
	NOT R6, R4
	ADD R6, R6, #1	; this puts -R4 into R6
	ADD R6, R6, R2	; add R6 and R2
	BRzp incBase	; if result is negative, swap

swap
	STR R4, R1, #0	; stores stu2's values in stu1's location
	STR R5, R1, #1
	STR R2, R1, #2	; stores stu1's values in stu2's location
	STR R3, R1, #3
	BR start		; go back to start

incBase
    AND R0, R0, #0	; clear R0
    ADD R0, R0, R1	; add R1 to R0
	ADD R0, R0, #2  ; add 2 to R0
    ADD R1, R0, #0	; add R0 back to R1
	BR check		; check if sentinel

;	SEARCH
search
    LD R1, begin	; load base address for names

outerSearch
	LD R7, lookup	; load lookup address
	LDR R2, R1, #1	; load first name
	BRnp innerSearch; if not 0 (sentinel), compare with lookup
	AND R0, R0, #0	; set -1
	NOT R0, R0
	BR storeN		; branch to store

innerSearch
	LDR R3, R2, #0	; load name val
	BRnp A			; if not zero, branch to comparison
	
	LDR R4, R7, #0	; load lookup val
	BRz storeY		; if zero, both vals are zero so store name at x5FFF

A	LDR R4, R7, #0	; load lookup val
	NOT R4, R4		; R4 --> -R4
	ADD R4, R4, #1
	ADD R5, R3, R4	; compare vals
	BRnp incBase2	; if not zero, branch to new name
	ADD R2, R2, #1	; if zero, increment name
	ADD R7, R7, #1
	BR innerSearch
	
incBase2
    AND R0, R0, #0	; clear R0
    ADD R0, R0, R1	; add R1 to R0
	ADD R0, R0, #2  ; add 2 to R0
    ADD R1, R0, #0	; add R0 back to R1
	BR outerSearch

storeN
	LD R7, lookup	; reload lookup val
	STR R0, R7, #-1	; store -1 in x5FFF
	BR done

storeY
	LD R7, lookup	; reload lookup val
	LDR R0, R1, #0	
	STR R0, R7, #-1 ; store grade in x5FFF

done
	TRAP	x25		; halt

; 	.FILLs
begin 	.FILL x3500
lookup 	.FILL x6000
stLoc 	.FILL x5FFF
	.END

; Student records are at x3500
    .ORIG	x3500
    .FILL   #55     ; student 0' score
    .FILL   x4700   ; student 0's nameAddr
    .FILL	#75     ; student 1' score
    .FILL   x4100   ; student 1's nameAdd
    .FILL   #65     ; student 2' score
    .FILL   x4200   ; student 2's nameAdd
	.FILL   #-1
    .END

; Joe
	.ORIG	x4700
	.STRINGZ "Joe"
	.END
; Wow
	.ORIG	x4200
	.STRINGZ "Wonder woman"
	.END
	
; Bat
	.ORIG	x4100
	.STRINGZ "Bat Man"
	.END

; Person to Lookup	
	.ORIG   x6000
;       The following lookup should give score of 
	.STRINGZ  "Joe"
;       The following lookup should give score of
	.STRINGZ  "Bat Man"
;       The following lookup should give score of -1 because Bat man is 
;           spelled with lowercase m; There is no student with that name 
	.STRINGZ  "Bat man"
	.END
	
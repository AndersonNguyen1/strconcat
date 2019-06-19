;; Anderson Nguyen 68319094

ORG 0H
SJMP MAIN

STRING1: DB 0 ;; string data
DB 0 ;; Null termination
STRING1_L: DB 0

STRING2: DB "crabs" ;; string data
DB 0 ;; Null termination
STRING2_L: DB 5

STRCPY:
	;; the function copies from source to the destination address
	MOV R1, #0

	LOOP1:
	;; Load each character from source string's memory
	MOV A, R1
	MOVC A, @A + DPTR
	
	;; Check if not null char
	CJNE A, #0, NEXT

	;;ELSE
	MOV @R0, A
	MOV A, R1
	RET

NEXT:
	MOV @R0, A
	INC R1
	INC R0
	SJMP LOOP1

STRCONCAT:
	MOV DPTR, #STRING1
	CALL STRCPY
	MOV R7, A ;; move len to R7

	INC R1
	MOV A, R1
	MOVC A, @A + DPTR
	MOV R6, A
	MOV R5, A

	MOV DPTR, #STRING2
	CALL STRCPY
	;; store into R7
	ADD A, R7
	MOV R7, A

	INC R1
	MOV A, R1
	MOVC A, @A + DPTR
	MOV R2, A
	
	ADD A, R6
	MOV R6, A
	
	RET

TESTSTRING:
;; The purpose is to call STRCONCAT, fetch the answer
;; and check whether it works right
CALL STRCONCAT
;; If the length is different from the expected length
CLR C
SUBB A, R3
;; then jump to ERROR.
JNZ ERROR
;; Else Compare the copied data with the string1 and then string 2
MOV R1, #0
MOV R0, #60H

LOOP2:
MOV A, R1
MOVC A, @A + DPTR
MOV R4, A

MOV A, @R0
;; If one character does not match
SUBB A, R4
;; then jump to ERROR.
JNZ ERROR

INC R1
INC R0
MOV A, R7
JZ SKIP1;;special case for null
DJNZ R7, LOOP2
	;;decrement count of str1
SKIP1:
	MOV R1, #0;;reset count
	MOV DPTR, #STRING2

	LOOP3:
	MOV A, R1
	MOVC A, @A + DPTR
	MOV R4, A

	MOV A, @R0

	SUBB A, R4

	JNZ ERROR
	
	INC R1
	INC R0
	MOV A, R2
	JZ PASS ;;special case for null char
	DJNZ R2, LOOP3
	PASS:
	SJMP SUCCESS

MAIN:
	MOV R0, #60H
	CALL TESTSTRING
	SUCCESS: SJMP SUCCESS
	ERROR: SJMP ERROR

END

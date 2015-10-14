.286
.model LARGE, C

; Template for DOS .exe file

assume  cs:CSEG, ds:DSEG, ss:SSEG

	; this is header file
include proc.inc

        ; code
CSEG    SEGMENT

start:SetSegment ds, DSEG
    
	PrintString question

	mov bx, offset digit
	invoke inputInt16, bx

	PrintString nextline

	mov dx, digit
	invoke printInt16, dx

	;mov dx, testd
	;invoke printInt16, dx

    WAIT_ANY_KEY
    ;end of program
    mov ax, 4C00h
    int 21h

CSEG    ENDS

DSEG    SEGMENT byte
	question db 'Enter a digit, please (q - the end of digit): $'
	nextline db 0Dh, 0Ah, '$'
	symbol db ?
	digit dw ?
	testd dw 234
	smalldigit db 3
DSEG    ENDS

; stack
SSEG    SEGMENT stack

db      100h    dup(?)

SSEG    ENDS
END start

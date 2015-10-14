.286
.model LARGE, C

; Template for DOS .exe file

assume  cs:CSEG, ds:DSEG, ss:SSEG

	; this is header file
include proc.inc

        ; code
CSEG    SEGMENT

start:
	SetSegment ds, DSEG
    
	mov dx, offset question
	invoke printStr, dx

    mov dx, offset buf
    invoke inputStr, dx

    mov dx, offset nextline
	invoke printStr, dx

	mov dx, offset hello
    invoke printStr, dx

    mov dx, offset buf + 2
    invoke printStr, dx
	;PrintString question
	;PrintString nextline


	

    WAIT_ANY_KEY
    ;end of program
    mov ax, 4C00h
    int 21h

CSEG    ENDS

DSEG    SEGMENT byte
	question db 'Enter a name, please: $'
	nextline db 0Dh, 0Ah, '$'
	hello db 'Hello, $'
	buf db 20, 20 dup(?)
DSEG    ENDS

; stack
SSEG    SEGMENT stack

db      100h    dup(?)

SSEG    ENDS
END start

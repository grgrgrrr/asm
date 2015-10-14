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
    
	mov dx, offset kitty
	invoke printStr, dx

    WAIT_ANY_KEY
    ;end of program
    mov ax, 4C00h
    int 21h

CSEG    ENDS

DSEG    SEGMENT byte
	kitty db 'Hello, Kitty  $'
DSEG    ENDS

; stack
SSEG    SEGMENT stack

db      100h    dup(?)

SSEG    ENDS
END start

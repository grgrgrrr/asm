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
    SetSegment es, DSEG

    mov si, offset string1
    mov di, offset string2

    ;длина строки
    mov cx, 0
    mov di, '$'
    lengthc:
    	cmpsb
    	je endc
    	inc cx
    	dec di
    	jmp lengthc
    endc: 
        mov bx, cx ;длина строки

    ;повторяем копирование
   mov si, offset string1
   mov di, offset string2
   mov cx, bx
   mov dx, 3
   l:
   		rep movsb
   		sub dx, 1
   		mov cx, bx
   		cmp dx, 0
   		je next
   		jmp l

   next:
   		PrintString string2
   		PrintString nextline
	

    WAIT_ANY_KEY
    ;end of program
    mov ax, 4C00h
    int 21h

CSEG    ENDS

DSEG    SEGMENT byte
	string1 db 'ha'
	string2 db 100h dup(?)
	nextline db 0Dh, 0Ah, '$'


DSEG    ENDS

; stack
SSEG    SEGMENT stack

db      100h    dup(?)

SSEG    ENDS
END start

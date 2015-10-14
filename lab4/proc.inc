; this is declaration of proc1 procedure.
proc1 PROTO far a:WORD
printInt8 PROTO far a:BYTE
printInt16 PROTO far a:WORD
inputInt8 PROTO far a:WORD
inputInt16 PROTO far a:WORD
inputStr PROTO far a:WORD
printStr PROTO far a:WORD

PrintString MACRO src_string
	push dx
	push ax
	mov dx, offset src_string
	mov ah, 09h
	int 21h
	pop ax
	pop dx
ENDM

SetSegment MACRO SegmentRegister, SegmentName
	push ax
	mov ax, SegmentName
	mov SegmentRegister, ax
	pop ax
endm

WAIT_ANY_KEY MACRO
	push ax
	mov ax, 0100h
	int 21h
	pop ax
endm


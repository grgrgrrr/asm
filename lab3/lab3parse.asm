        assume  cs:CSEG, ds:DSEG, ss:SSEG

        ; code
CSEG    SEGMENT

; This proc print integer from DX to console
; DS - Current data Segment.
; DX - Integer
printInt16 PROC 
	;сохраняем регистры
	push	ax
	push	bx
	push	cx
	push	dx

	;вывод числа
		mov al, 0
		mov ax, dx
		mov bx, 10 ;на что делить
		mov cx, 0 ;для разворота стека

	to_stack:
		mov dx, 0 ;очищаем dx, там будет остаток
		div bx
		push dx
		inc cx ;увеличиваем cx для того, чтобы вынуть все цифры из стека
		cmp ax, 0 ;если целая часть не равна 0
		jne to_stack ;продолжаем делить
		;иначе все число в стеке и его надо вывести

	print_from_stack:
		pop dx
		call printInt8
		loop print_from_stack

	pop	dx
	pop	cx
	pop	bx
	pop	ax

        RET
printInt16 ENDP


; This proc print integer from Dl to console
; DS - Current data Segment.
; Dl - Integer
printInt8 PROC 
	add dl, '0'
	mov ah, 02h
	int 21h
        RET
printInt8 ENDP



; This proc input integer to DX from console
; ES - Current data Segment.
; DX - Integer
inputInt16 PROC 
;ввод числа до сивола "q"
		mov dx, 0
	input:
		mov ah, 01h
		int 21h

		;признак конца введенной строки
		mov cl, 'q'
		mov bl, al
		cmp bl, cl
		je after_input
			
		sub al, '0' ;отнимаем код нуля, чтобы получить число
		mov bl, al ;число сейчас в bl

		;иначе формируем число
		mov ax, 10 ;множитель
		add dx, bx ;добавляем к числу текущий символ
		mul dx
		mov dx, ax
		jmp input

	after_input:
	;избавляемся от лишнего умножения
		mov ax, dx
		mov dx, 0
		mov bx, 10
		div bx
		mov dx, ax

        RET
inputInt16 ENDP


; This proc input integer to Dl from console
; ES - Current data Segment.
; Dl - Integer.
inputInt8 PROC 
		mov ah, 01h
		int 21h

		sub al, '0'
		cmp al, 9 ;если число больше 9, то завершаем программу
		ja end_pr
		mov dl, al

        RET
inputInt8 ENDP


; This macro input string from console.
InputString MACRO dst_string
	push dx
	push ax
	mov dx, offset dst_string
	mov ah, 0Ah
	int 21h
	pop ax
	pop dx
ENDM


; This macro input string from console.
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

start:
        ; ... put your code here ...
	SetSegment ds, DSEG

	;передаем адрес сегмента данных
	mov ax, dseg
	mov ds, ax

	;просьба ввести число
		mov dx, offset question
		mov ah, 09h
		int 21h


		call inputInt16
		mov bx, dx

	;арифметическая операция с числом
		mov ax, dx
 		mov bx, 2
		mul bx
		mov digit, ax


	;переход на след. строку, чтобы не затирался текст
		mov dx, offset nextline
		mov ah, 09h
		int 21h

	;вывод на экран
	mov dx, digit
	call printInt16

	WAIT_ANY_KEY

        ; exit to DOS
end_pr:
		mov     ax, 4C00h
       	int     21h

CSEG    ENDS


        ; data
DSEG    SEGMENT byte
	question db 'Enter a digit, please (q - the end of digit): $'
	nextline db 0Dh, 0Ah, '$'
	symbol db ?
	digit dw ?
	testd dw 534

DSEG    ENDS


        ; stack
SSEG    SEGMENT stack

        db      100h    dup(?)

SSEG    ENDS
END start

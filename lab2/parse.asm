;назначаем роли сегментов
assume	cs:cseg,ds:dseg,ss:sseg

;сегмент кода
cseg segment
start:
;передаем адрес сегмента данных
	mov ax, dseg
	mov ds, ax

;просьба ввести число
	mov dx, offset question
	mov ah, 09h
	int 21h

;инициализируем число
	mov dx, 0
	mov digit, dx

;ввод пользователя
input:
	mov dx, offset symbol
	mov ah, 01h
	int 21h
	;запоминаем символ
	mov symbol, al

	;признак конца введенной строки
	mov cl, 'q'
	;сравниваем введенный символ с признаком конца
	mov bl, symbol
	cmp bl, cl
	je after_input
		
	sub al, '0' ;отнимаем код нуля, чтобы получить число
	mov bl, al ;число сейчас в bl
	;cmp al, 9 ;если число больше 9, то завершаем программу
	;ja end_pr
	
	;иначе формируем число
	mov ax, 10 ;множитель
	mov dx, digit
	add dx, bx ;добавляем к числу текущий символ
	;умножаем на 10
	mul dx
	mov digit, ax
	jmp input

after_input:
;изюавляемся от лишнего умножения
		mov dx, 0
		mov ax, digit
		mov bx, 10
		div bx
		;mov digit, ax ;digit - это наше число

;арифметическая операция с числом (оно в ax)
 		mov bx, 2
		mul bx
		mov digit, ax

;переход на след. строку, чтобы не затирался текст
		mov dx, offset nextline
		mov ah, 09h
		int 21h

	;вывод числа
		mov al, 0
		mov ax, digit
		mov bx, 10 ;на что делить
		mov cx, 0 ;для разворота стека

	to_stack:
		mov dx, 0 ;очищаем dx, там будет остаток
		div bx
		add dl, '0'
		push dx
		inc cx ;учеличиваем cx для того, чтобы вынуть все цифры из стека
		cmp ax, 0 ;если целая часть не равна 0
		jne to_stack ;продолжаем делить
		;иначе все число в стеке и его надо вывести

	print_from_stack:
		pop dx
		mov ah, 02h
		int 21h
		loop print_from_stack

;завершение программы
end_pr:
		mov	ax, 4C00h
		int	21h
cseg ends

;сегмент данных
dseg segment byte
	question db 'Enter a digit, please (q - the end of digit): $'
	nextline db 0Dh, 0Ah, '$'
	symbol db ?
	digit dw ?
	testd dw 534
dseg ends

;сегмент стека
;в этом примере он не шибко нужен
sseg segment stack
	;выделяет 256 ячеек памяти по 4 байта (незаполненных)
	db 100h dup(?)
sseg ends

end	start
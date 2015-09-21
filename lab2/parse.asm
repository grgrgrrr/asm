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
	mov dl, 1
	mov digit, dl

;ввод пользователя
input:
	mov dx, offset symbol
	mov ah, 01h
	int 21h
	;запоминаем символ
	mov symbol, al

	;формируем число
	mov al, 10
	mul digit
	mov dl, digit
	mov bl, symbol
	add dl, bl

	;признак конца введенной строки
	mov cl, 'q'
	;сравниваем введенный символ с признаком конца
	mov bl, symbol
	cmp bl, cl
	je after_input
	jmp input

after_input:
;переход на след. строку, чтобы не затирался текст
	mov dx, offset nextline
	mov ah, 09h
	int 21h
;вывод числа
	mov dx, offset digit
	mov ah, 09h
	int 21h
	

;завершение программы
	mov	ax, 4C00h
	int	21h
cseg ends

;сегмент данных
dseg segment byte
	question db 'Enter a digit, please: $'
	nextline db 0Dh, 0Ah, '$'
	endtext db 'End$'
	symbol db ?
	digit db ?
dseg ends

;сегмент стека
;в этом примере он не шибко нужен
sseg segment stack
	;выделяет 256 ячеек памяти по 4 байта (незаполненных)
	db 100h dup(?)
sseg ends

end	start
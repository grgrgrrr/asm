;назначаем роли сегментов
assume	cs:cseg,ds:dseg,ss:sseg

;сегмент кода
cseg segment
start:

;передаем адрес сегмента данных
	mov ax, dseg
	mov ds, ax

;вывод на экран 
	mov dx, offset hello
	mov ah, 09h
	int 21h

;код завершения программы: код функции(4C), код возврата (00)
	mov	ax, 4C00h
	int	21h

cseg ends

;сегмент данных
dseg segment byte
	;строка + символ конца строки
	;выделяет 15 ячеек памяти размером по 1 байту
	hello db 'Hello, Kitty!!!', '$'
dseg ends

;сегмент стека
;в этом примере он не шибко нужен
sseg segment stack
	;выделяет 256 ячеек памяти по 4 байта (незаполненных)
	db 100h dup(?)
sseg ends

end	start
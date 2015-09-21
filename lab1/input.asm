;назначаем роли сегментов
assume	cs:cseg,ds:dseg,ss:sseg

;сегмент кода
cseg segment
start:

;передаем адрес сегмента данных
	mov ax, dseg
	mov ds, ax

;
	mov dx, offset q
	mov ah, 09h
	int 21h

;ввод пользователя
	mov dx, offset buf
	mov ah, 0ah
	int 21h

;
	mov dx, offset j
	mov ah, 09h
	int 21h

;вывод на экран

	;слово hello
	mov dx, offset hello
	mov ah, 09h
	int 21h

	;введенная строка
	;добаляем символ конца строки
	mov si, offset buf + 1 ;длина строки или номер последнего введенного символа
	mov cl, [si]
	inc cx
	add si, cx 

	;по полученному адресу добавляем символ конца строки
	mov bl, '$'
	mov [si], bl 

	;кол-во символов выводить не надо
	mov dx, offset buf + 2
	mov ah, 09h
	int 21h

;завершение программы
	mov	ax, 4C00h
	int	21h
cseg ends

;сегмент данных
dseg segment byte
	q db 'Enter your neme, please: $'
	j db 0Dh, 0Ah, '$'
	hello db 'Hello, $'
	buf db 20, 20 dup(?)
dseg ends

;сегмент стека
;в этом примере он не шибко нужен
sseg segment stack
	;выделяет 256 ячеек памяти по 4 байта (незаполненных)
	db 100h dup(?)
sseg ends

end	start
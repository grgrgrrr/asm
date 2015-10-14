 .286
 .model LARGE, C
 
        ; code
 CSEG_2    SEGMENT public

	;this is implementation of proc1 procedure.
	proc1 PROC far a:WORD
		mov ah, 1
		int 21h
		ret
	proc1 endp 
	




    ;print int16
    printInt16 PROC far a:WORD
    ;сохраняем регистры
    push    ax
    push    bx
    push    cx
    push    dx
    mov ax, 0
    mov bx, 0
    mov cx, 0
    mov dx, 0

        ;вывод числа
        mov dx, a
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
        mov dh, 0
        add dl, '0'
        mov ah, 02h
        int 21h
        loop print_from_stack

    pop dx
    pop cx
    pop bx
    pop ax
        ret
    printInt16 endp





    ;print int8
    printInt8 PROC far a:BYTE
    push ax
    push dx
        mov dx, 0
        mov dl, a
        add dl, '0'
        mov ah, 02h
        int 21h
    pop ax
    pop dx
            RET
    printInt8 endp





    ;input int8
    inputInt8 PROC far a:WORD
    push    bx
    push    cx
    push    dx
    push    ax
    mov ax, 0
    mov bx, 0
    mov cx, 0
    mov dx, 0
        mov dx, a
        mov ah, 01h
        int 21h
        sub al, '0'
        mov si, dx
        mov [si], al
        cmp al, 9 ;если число больше 9, то выводим ошибку
        ja end_pr
        jmp continue
        end_pr: 
            mov  ax, 4C00h
            int  21h
               
        continue:         
    pop ax
    pop dx
    pop cx
    pop bx
        RET
    inputInt8 endp





    ;inputint16
    inputInt16 PROC far a:WORD
    push    bx
    push    cx
    push    dx
    push    ax
    mov ax, 0
    mov bx, 0
    mov cx, 0
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

        cmp bl, 9 ;если число больше 9, то выводим ошибку
        ja end_pr
        jmp continue
    end_pr: 
        mov  ax, 4C00h
        int  21h
               
    continue:     
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
        ;mov dx, ax
        mov si, a
        mov [si], ax
    pop ax
    pop dx
    pop cx
    pop bx
        RET
    inputInt16 endp


    ;proc input string
    inputStr PROC far a:WORD
    push    bx
    push    cx
    push    dx
    push    ax
    mov ax, 0
    mov bx, 0
    mov cx, 0
    mov dx, 0

        mov dx, a
        mov ah, 0Ah
        int 21h
        ;добаляем символ конца строки
        inc dx
        mov si, dx ;длина строки или номер последнего введенного символа
        mov cl, [si]
        inc cx
        add si, cx 

        ;по полученному адресу добавляем символ конца строки
        mov bl, '$'
        mov [si], bl 

    pop ax
    pop dx
    pop cx
    pop bx
        RET
    inputStr ENDP





    ;procPrint
    printStr PROC far a:WORD
    push ax
    push dx
        mov dx, a
        mov ah, 09h
        int 21h
    pop dx
    pop ax
        RET
    printStr ENDP





    ; exit to DOS
    mov  ax, 4C00h
    int  21h

CSEG_2    ENDS


        ; data
DSEG_2    SEGMENT byte

endline db 0Ah, 24h

DSEG_2    ENDS

; stack
SSEG_2    SEGMENT stack
db      100h    dup(?)
SSEG_2    ENDS

END
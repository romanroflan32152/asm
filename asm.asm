section .text
	extern printf
	extern scanf
	global _asm_main


section .bss
    input : resb 4

section .data    
    format db "%c", 0
    format2 db "%d", 0
    digit1 db 0
    digit2 db 0


_asm_main:
    mov ebp, esp; for correct debugging

    xor eax, eax
    mov	    eax,0
    mov	    ebx,0	                     ; sum in decimal
             
    mov byte     [digit1],'0'        ; 1st digit for hex number   
    mov byte     [digit2],'0'        ; 2nd digit for hex number
    
    ; call    read_char
    push	input
    push	format
    call	scanf
    add     esp, 8

    jmp     first
read_num:                           ; input cycle
        ; call    read_char
    mov byte    [input],0
    push	input
    push	format
    call    scanf
    add     esp, 8

    cmp byte     [input],' '             ; while space - read
    je      read_num

first:
    cmp byte     [input],'9'             ; is a number?
    jg      error
    cmp byte     [input],'0'
    jl      error
        

    mov     eax, [input]
    sub     eax,'0'
    mov     ecx,10
    mul     ecx
    add     ebx,eax



    ; call    read_char           ; get ones as char from input
    mov byte    [input],0
    push	input
    push	format
    call	scanf
    add     esp, 8

    cmp byte     [input],'9'
    jg      error
    cmp byte     [input],'0'
    jl      error


    mov     eax, [input]
    sub     eax,'0'            ; to int
    add     ebx,eax             


    ; call    read_char           ; je medzera?
    mov byte    [input],0
    push	input
    push	format
    call	scanf
    add     esp, 8

    
    cmp byte     [input],' '
    jz      read_num       

    cmp byte     [input],0
    jz      final
    cmp byte     [input],10              ; koniec vstupu?
    jz      final
    cmp byte     [input],13
    jz      final

    jmp     error               ; chyba vstupu

final:
    mov     eax, ebx            ; sum in decimal    
    cmp     eax,255             ; if hex > FF = FF
    jl      less
    mov byte        [digit1],'F'
    mov byte        [digit2],'F'
    jmp     print
less:
    mov     ebx, 16             ; hex variable
    xor     edx, edx            ; edx = 0

    div     ebx                 ; eax -> tens edx -> ones

    add     eax,'0'
    cmp     eax,'9'
    jle     skip_add1           ; if tens >9 -> A/B/../F
    add     eax, 7

skip_add1:
    mov     [digit1],eax        ; save tens
    ; push dword [digit2]
    ; push format
    ; call printf


    add     edx,'0'             ; ones from char to int

    cmp     edx,'9'             ; if ones >9 -> A/B/../F
    jle     skip_add2
    add     edx, 7

skip_add2:
    mov     [digit2],edx        ; save ones
    ; push dword [digit2]
    ; push format
    ; call printf

        

print:                              ; print result
    push dword [digit1]
    push    format
    call    printf
    add     esp, 8

    push dword [digit2]
    push    format
    call    printf
    add     esp, 8

    push dword 'h'
    push    format
    call    printf
    add     esp, 8

    push dword 10
    push    format
    call    printf
    add     esp, 8

    ; mov     eax,[digit2]
    ; call    print_char
    ; mov     eax,'h'
    ; call    print_char
    ; call    print_nl
    
    ret

error:     
                    ; if error -> 00h
    ; mov     eax,'0'
    ; call    print_char
    ; mov     eax,'0'
    ; call    print_char
    ; mov     eax,'h'
    ; call    print_char
    ; call    print_nl


    push dword [digit1]
    push    format
    call    printf
    add     esp, 8

    push dword [digit2]
    push    format
    call    printf
    add     esp, 8

    push dword 'h'
    push    format
    call    printf
    add     esp, 8

    push dword 10
    push    format
    call    printf
    add     esp, 8

    ret
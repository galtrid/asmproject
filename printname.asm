;
; printname.asm - Converted to a subroutine
;
global printname            ; EXPORT this label so main.asm can see it

extern _GetStdHandle@4
extern _WriteConsoleA@20
extern _ReadConsoleA@20


section .data
    prompt      db "What is your name? ",0
    prompt_len  equ $ - prompt

    greet1      db "Hi my name is ",0
    greet1_len  equ $ - greet1

    greet2      db " hello !!!",0
    greet2_len  equ $ - greet2

section .bss
    input              resb 64
    bytesRead          resd 1
    handleforwriting   resd 1
    handleforreading   resd 1
    leninput           resd 1

section .text
printname:          
    ;  get stdout handle 
    push -11
    call _GetStdHandle@4
    mov [handleforwriting], eax

    ;  get stdin handle 
    push -10
    call _GetStdHandle@4
    mov [handleforreading], eax

    ;  print prompt 
    push 0
    push bytesRead
    push prompt_len
    push prompt
    push [handleforwriting]
    call _WriteConsoleA@20

    ;  read user input 
    push 0
    push bytesRead
    push 64
    push input
    push [handleforreading]
    call _ReadConsoleA@20

    ;  trim CRLF 
    mov eax, [bytesRead]
    cmp eax, 2
    jl after_trim
    mov byte [input + eax - 2], 0

after_trim:
    ;  count string length 
    mov esi, input
    xor ecx, ecx

count_loop:
    mov al, [esi]
    test al, al
    je count_done
    inc esi
    inc ecx
    jmp count_loop

count_done:
    mov [leninput], ecx

    ;  print greet1 
    push 0
    push bytesRead
    push greet1_len
    push greet1
    push [handleforwriting]
    call _WriteConsoleA@20

    ;  print user input 
    push 0
    push bytesRead
    push [leninput]
    push input
    push [handleforwriting]
    call _WriteConsoleA@20

    ;  print greet2 
    push 0
    push bytesRead
    push greet2_len
    push greet2
    push [handleforwriting]
    call _WriteConsoleA@20

    ;  RETURN
    ret
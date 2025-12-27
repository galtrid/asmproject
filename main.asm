global _main

extern _ReadConsoleA@20
extern _WriteConsoleA@20
extern _GetStdHandle@4
extern _ExitProcess@4


extern printname
extern readkeyboardinput

section .data
    menu db "1. Program 1",13,10,"2. Program 2",13,10,"Choose: ",0
    len equ $-menu

section .bss
    choice resb 1
    read   resd 1

section .text
_main:
    push -11
    call _GetStdHandle@4
    mov ebx, eax

    push 0
    push read
    push len
    push menu
    push ebx
    call _WriteConsoleA@20

    push -10
    call _GetStdHandle@4

    push 0
    push read
    push 1
    push choice
    push eax
    call _ReadConsoleA@20

    mov al, [choice]
    cmp al, '1'
    je call_p1
    cmp al, '2'
    je call_p2
    jmp exit

call_p1:
    call printname          
    jmp _main

call_p2:
    call readkeyboardinput  
    jmp _main

exit:
    push 0
    call _ExitProcess@4
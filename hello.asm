;this is very difficult
extern  _GetStdHandle@4
extern  _WriteConsoleA@20
extern  _ReadConsoleA@20
extern  _ExitProcess@4

section .data
    prompt      db "What is your name? ",0
    prompt_len  equ $ - prompt

    greet1      db "Hi my name is ",0
    greet1_len  equ $ - greet1

    greet2      db " hello world",0
    greet2_len  equ $ - greet2

section .bss
    input       resb 64
    bytesRead   resd 1

section .text
global _main

_main:
    ; get stdout
    push -11
    call _GetStdHandle@4
    mov ebx, eax

    ; print prompt
    push 0
    push bytesRead
    push prompt_len
    push prompt
    push ebx
    call _WriteConsoleA@20

    ; read user input
    push 0
    push bytesRead
    push 64
    push input
    push ebx
    call _ReadConsoleA@20

    ; remove newline: input[bytesRead-2] = 0
    mov eax, [bytesRead]
    cmp eax, 2
    jl skip_trim
    mov byte [input + eax - 2], 0
skip_trim:

    ; print greet1
    push 0
    push bytesRead
    push greet1_len
    push greet1
    push ebx
    call _WriteConsoleA@20

    ; print input
    push 0
    push bytesRead
    push 64
    push input
    push ebx
    call _WriteConsoleA@20

    ; print greet2
    push 0
    push bytesRead
    push greet2_len
    push greet2
    push ebx
    call _WriteConsoleA@20

    push 0
    call _ExitProcess@4

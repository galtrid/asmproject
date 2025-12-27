
global readkeyboardinput

extern _GetStdHandle@4
extern _ReadConsoleInputA@16
extern _WriteConsoleA@20

STD_INPUT_HANDLE  equ -10
STD_OUTPUT_HANDLE equ -11
KEY_EVENT         equ 1
VK_ESCAPE         equ 0x1B

SECTION .data
    outMsg db "Key pressed: ", 0
    outLen equ $ - outMsg
    newline db 13, 10
    newlineLen equ 2

SECTION .bss
    inputHandle       resd 1
    outputHandle      resd 1
    inputRecord       resb 20
    eventsRead        resd 1
    charsWritten      resd 1
    charBuffer        resb 1

SECTION .text
readkeyboardinput:          
    push STD_INPUT_HANDLE
    call _GetStdHandle@4
    mov [inputHandle], eax

    push STD_OUTPUT_HANDLE
    call _GetStdHandle@4
    mov [outputHandle], eax

.loop:
    push eventsRead
    push 1
    push inputRecord
    push [inputHandle]
    call _ReadConsoleInputA@16

    cmp word [inputRecord], KEY_EVENT
        jne .loop

    cmp dword [inputRecord+4], 0
    je .loop

    
    cmp word [inputRecord+10], VK_ESCAPE
    je .exit_subroutine      

    mov al, [inputRecord+14]
    cmp al,0
    jz .loop
    mov [charBuffer], al

    ; Print "Key pressed: "
    push 0
    push charsWritten
    push outLen
    push outMsg
    push dword [outputHandle]
    call _WriteConsoleA@20

    ; Print the character
    push 0
    push charsWritten
    push 1
    push charBuffer
    push dword  [outputHandle]
    call _WriteConsoleA@20

    ; Print Newline
    push 0
    push charsWritten
    push newlineLen
    push newline
    push dword [outputHandle]
    call _WriteConsoleA@20

    jmp .loop

.exit_subroutine:
    ;  back tomain
    ret

;readinputhandle winapi
; Byte Number,what, meaning:
; 0 - 1,Event Type,Determines what the rest of the bytes are. • 1 = Keyboard • 2 = Mouse
; 2 - 3,Padding,"Junk. These bytes are skipped to make the next number align to a 4-byte boundary. They are usually zero, but you should ignore them."
; 4 - 7,Key Down?,"1 if you just pressed the key.0 if you just released it.(This takes 4 bytes because it's a ""BOOL"" integer)"
; 8 - 9,Repeat Count,"If you hold the key down, this number goes up (1, 2, 3...) to represent rapid-fire repeats."
; 10 - 11,Virtual Key Code,"The generic ID for the key. • 0x1B is Escape.• 0x25 is Left Arrow.This is used to detect which physical button was pressed, ignoring letters."
; 12 - 13,Scan Code,The raw hardware number your specific keyboard sends. Usually ignored unless you are writing a driver.
; 14,ASCII Char,"The Letter. This is where 'a', 'B', '9', or '?' lives.If you pressed ""Shift"", this byte is 0."
; 15,Unused/Unicode,"In ReadConsoleInputA (ASCII version), this is 0.In ReadConsoleInputW (Unicode version), this is the second half of the letter."
; 16 - 19,Control Keys,A status report of the modifier keys.• Bit 1: Caps Lock is on.• Bit 2: Shift is held.• Bit 3: Ctrl is held.

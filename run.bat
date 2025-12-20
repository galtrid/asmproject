@echo off
nasm -f win32 main.asm -o main.obj
gcc main.obj -o main.exe
main.exe
pause

@echo off
nasm -f win32 printname.asm -o printname.obj
nasm -f win32 readkeyboardinput.asm -o readkeyboardinput.obj
nasm -f win32 main.asm -o main.obj

gcc main.obj printname.obj readkeyboardinput.obj -o main.exe

if exist main.exe main.exe
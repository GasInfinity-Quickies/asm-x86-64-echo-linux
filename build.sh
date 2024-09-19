mkdir -p out/
nasm -f elf64 -o out/echo.o echo.asm
ld -o out/echo.x86_64 out/echo.o

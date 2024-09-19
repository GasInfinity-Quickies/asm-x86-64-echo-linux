BITS 64

global _start

SYS_WRITE equ 1 
SYS_EXIT equ 60

FD_STDOUT equ 1 

; Gets the string from rsi
; Modifies rax, rcx and rdi
; returns the length in rdx
strlen:
    xor rax, rax ; We want to search for the NULL byte
    mov rdi, rsi ; RDI must be the start of the string
    mov rcx, -1 ; We want to calculate the length of the string, We don't want it to stop when rcx == 0
    cld ; Clear the direction flag (Used in string operations)
    repnz scasb ; REPeat while ecx != 0 and *rdi != rax. Decrements ecx to -(strlen() + 1)
    not rcx ; Contains now (strlen() + 1)
    dec rcx ; Contains strlen()
    mov rdx, rcx ; return in rdx
    ret 

_start:
    pop rbx ; argc 
    test rbx, rbx ; If 0, do nothing
    jz .echo_end

    dec rbx ; We don't want the first argument
    pop rsi ; Discard first argument

    ; char** argv -- In the stack
    .echo_start:
        test rbx, rbx
        jz .echo_end
        pop rsi ; char* argc[i]     
        call strlen
        mov rdi, FD_STDOUT
        mov rax, SYS_WRITE
        syscall ; Write argument
        mov rax, SYS_WRITE ; rax is overwritten with the syscall ret value
        mov rsi, blank
        mov rdx, 1
        syscall
        dec rbx
        jmp .echo_start
        
    .echo_end:
        mov rsi, newline 
        syscall ; rdx should be 1 from printing a blank character 

        mov rax, SYS_EXIT
        xor rdi, rdi
        syscall

blank: db " "
newline: db 10

%define SYS_write 1
%define SYS_exit  60
%define fd_stdout 1
global _start

section .data
msg:    db  "Hello, Linux nasm (no libc, C)", 10
msg_len equ $ - msg

section .text
_start:
    ; write(1, msg, msg_len)
    mov     rax, SYS_write    ; syscall number (rax)
    mov     rdi, fd_stdout    ; fd = 1 (stdout)
    lea     rsi, [rel msg]    ; pointer to msg (RIP-relative)
    mov     rdx, msg_len      ; length
    syscall

    ; write(1, msg, msg_len)  ; print again
    mov     rax, SYS_write
    mov     rdi, fd_stdout
    lea     rsi, [rel msg]
    mov     rdx, msg_len
    syscall

    mov     rax, SYS_exit
    xor     rdi, rdi          ; status = 0
    syscall

    ; unreachable, but keeps assembler happy
    ud2

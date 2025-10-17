EXTERN GetStdHandle : PROC
EXTERN WriteConsoleA : PROC
EXTERN ExitProcess : PROC

.const
    STD_OUTPUT_HANDLE equ -11

.data
    msgText     db "Hello, World!", 13, 10
    msgLength   equ $ - msgText
    bytesWritten dq 0

.code
main PROC
    sub     rsp, 28h

    mov     ecx, STD_OUTPUT_HANDLE
    call    GetStdHandle
    mov     rsi, rax

    cmp     rsi, -1
    je      exit

    lea     rcx, [rsi]
    lea     rdx, msgText
    mov     r8d, msgLength
    lea     r9, bytesWritten
    xor     rax, rax
    call    WriteConsoleA

exit:
    xor     ecx, ecx
    call    ExitProcess
main ENDP

END

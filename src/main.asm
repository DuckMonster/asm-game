extern g_init

section .text
global asm_main

asm_main:
    push    rbp

    sub     rsp, 0x28
    mov     rcx, 2*5
    mov     rax,    0xCCCCCCCC
    mov     rdi,    rsp
    rep     stosd

    mov     rcx,    msg
    call    g_init

    add     rsp,    0x28

    pop     rbp
    ret

section .rodata
msg:        db      "Hello from ASM, %d", 0x0
value:      dd      150
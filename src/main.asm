%include "def.asm"

extern g_init
extern g_print
extern g_update
extern g_isopen

extern g_drawbox
extern g_clear

section .text
global main

main:
    ; Prologue
    push    rbp
    push    rdi
    movss   xmm5,   dword [rel player_pos]

    sub     rsp,    0x28

    ; Print a nice message!
    mov     rcx,    msg
    mov     rdx,    [rel value]
    call    g_print

    ; Init graphics! Opening a window and whatnot
    mov     rcx,    wnd_title
    mov     edx,    dword [rel wnd_width] 
    mov     r8d,    dword [rel wnd_height]
    call    g_init

loop:
    ; Clear
    call    g_clear

    ; Draw a box

    ; x is 10 + numticks
    mov     rax,    0

    mov     rcx,    10
    add     rcx,    rax
    mov     rdx,    10
    mov     r8,     40
    mov     r9,     20
    call    g_drawbox

    ; Update window and inputs...
    call    g_update

    ; Loop unless g_isopen returns 0 
    call    g_isopen
    cmp     rax, 0
    jne     loop

    ; Epilogue
    add     rsp,    0x28
    pop     rdi
    pop     rbp
    ret

section .rodata
wnd_title:  db      "Asm Game!", 0
wnd_width:  dd      800   
wnd_height: dd      600   

msg:        db      "Hello from ASM, %d", 0
value:      dd      150

section .data
player_pos: dd      0.0

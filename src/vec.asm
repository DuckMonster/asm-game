section .text
vec_stuff:
	mov		rax, value
	ret

section .rodata
value:		db	0xDE, 0xAD, 0xBE, 0xEF
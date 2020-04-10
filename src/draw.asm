extern screen_data
extern screen_width
extern screen_height

section .text
global g_clear
global g_drawbox

g_clear:
	push	rbp

	; Put width * height in eax
	mov		eax, dword [rel screen_width]
	mov		ebx, dword [rel screen_height]
	mul		ebx

	; Put the pixel-pointer in rbx
	mov		rbx, qword [rel screen_data]


clear_loop:
	mov		dword [rbx], 0

	add		rbx, 4
	dec		eax
	jnz		clear_loop

	pop		rbp
	ret


; g_drawbox
;	rcx - x
;	rcy	- y
;	r8	- width
;	r9	- height
g_drawbox:
	push	rbp

	; Memory location: (x + y * screen_width) * 4

	; y * screen_width
	xor		rax, rax
	mov		eax, dword [rel screen_width]
	mul		rdx

	; ... + x
	add		rax, rcx

	; * 4
	mov		rbx, 4
	mul		rbx

	; Final row-offset is in r10
	mov		r10, rax

	mov		rcx, r9

	; Y loop
y_loop:

	; r11 is the current ptr to pixels
	mov		r11, qword [rel screen_data]
	add		r11, r10

	; X loop
	mov		rdx, r8

x_loop:
	mov		dword [r11], 0xFFFFFFFF
	add		r11, 4
	dec		rdx
	jnz		x_loop

	; Increase the memory offset by 4 * screen_width
	xor		rax, rax
	mov		eax, dword [rel screen_width]
	mov		rdx, 4
	mul		rdx
	add		r10, rax

	dec		rcx
	jnz		y_loop

	pop		rbp
	ret

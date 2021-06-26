@enderecos dispositivos
DISPLAY     .equ 0x90
SLIDER_DATA .equ 0x91

	.org 0x100
_start:
	set	r3,digitos      @ endereço tabela de dígitos
le_tecla:
	inb	r0,SLIDER_DATA  @ lê byte do sensor
	add     r0,r3
	ldb     r0,[r0]         @ padrao de bits para valor da tecla
	outb    DISPLAY,r0	@ seta valor no display
	jmp	le_tecla

digitos:
     .byte 0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b,0x4f,0x4f


@enderecos dispositivos
DISPLAY    .equ 0x90
KBD_DATA   .equ 0x91
KBD_STATUS .equ 0x92

@ máscareas para bits de estado
KBD_READY  .equ 0x1
KBD_OVRN   .equ 0x2

	.org 0x100
_start:
	set	r1,KBD_STATUS
	set	r2,KBD_DATA
	set	r3,digitos      @ endereço tabela de dígitos
	set	r10,KBD_READY
le_tecla:
	inb	r0,KBD_STATUS   @ lê byte de estado
	tst     r0,r10          @ tecla pressionada?
	jz      le_tecla
	
	inb	r0,KBD_DATA     @ lê valor da tecla
	add     r0,r3
	ldb     r0,[r0]         @ padrao de bits para valor da tecla
	outb    DISPLAY,r0	@ seta valor no display
	jmp	le_tecla

digitos:
     .byte 0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b,0x4f,0x4f


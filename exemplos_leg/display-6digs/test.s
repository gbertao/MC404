@ exemplo para ilutrar o uso de painel
@ com seis mostradores

@ valor para temporizador
TEMPORIZA .equ 5000000	

@ portas dos mostradores
DISPLAY1 .equ 0x81
DISPLAY2 .equ 0x82
DISPLAY3 .equ 0x83
DISPLAY4 .equ 0x84
DISPLAY5 .equ 0x85
DISPLAY6 .equ 0x86

	.org 0x100
_start:
	set   r10,0
	set   r11,3
	set   r12,0x80        @ máscara para ligar ponto do mostrador
laco:
	mov   r0,r10
	set   r2,tab_digitos  @ indexa valor do dígito corrente no vetor
	add   r2,r0           @ de dígitos para determinar a configuração
	ldb   r2,[r2]         @ de bits a ser escrita no mostrador
	outb  DISPLAY1,r2     @ envia para o mostrador
	mov   r3,r2
	or    r3,r12          @ liga ponto do mostrador
	outb  DISPLAY3,r3     @ envia para o mostrador
	outb  DISPLAY5,r2     @ envia para o mostrador
	mov   r0,r11
	set   r2,tab_digitos  @ indexa valor do dígito corrente no vetor
	add   r2,r0           @ de dígitos para determinar a configuração
	ldb   r2,[r2]         @ de bits a ser escrita no mostrador
	outb  DISPLAY2,r2     @ envia para o mostrador
	outb  DISPLAY4,r2     @ envia para o mostrador
	outb  DISPLAY6,r2     @ envia para o mostrador
	add   r10,1
	cmp   r10,9
	jle   cont
	set   r10,0
cont:
	add   r11,1
	cmp   r11,9
	jle   espera
	set   r11,0
espera:
	set   r6,TEMPORIZA    @ contador para temporização
espera1:
	sub   r6,1
	jnz   espera1
	jmp   laco
	
	
@ tabela de codificação de dígitos
tab_digitos:
	.byte    0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b,0x47

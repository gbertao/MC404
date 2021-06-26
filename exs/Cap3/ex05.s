@ definição de constante
VERDADEIRO 	.equ 0xff
MAXVAL		.equ 16
MINVAL 		.equ MAXVAL/2
set r0,0x1 @ inicia r0 com 1

inicio:
	add r0,MAXVAL @ Soma e guarda em r0

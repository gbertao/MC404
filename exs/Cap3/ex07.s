@ Usando a diretiva de inicialização BYTE
MAX .equ 256

@ Reservando espaço e escrevendo
contador:	.byte	0x01		@ um valor em hex
estado:		.byte	0, MAX-1	@ uma lista
letra:		.byte	'a'			@ uma letra
num:		.byte	-1			@ um negativo

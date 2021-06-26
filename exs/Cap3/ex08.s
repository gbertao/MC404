@ Usando a diretiva WORD
@ Algumas cte
ALTO	.equ	0x32000
BAIXO	.equ	0x2000

x:		.word	ALTO-1
y:		.word	BAIXO*2
		.word	31,32
ultimo:	.word	-1

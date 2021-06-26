@ Diretiva de end de montagem
MAXVAL	.equ	256

@ Definindo o end de montagem
		.org	0x200
bloco1:	.byte	10,11,12,13,14,15

@ Começando em outro bloco
		.org	0x400
bloco2:	.word	0,1,2

@ MC 404 - Lab 00 - Giovanni Bertão - ra173325
@ Reservar espaço para 3 variáveis inteiras,
@ Somar os valores das 3, somar o resultado a uma constante e
@ armazenar o total em r0.

		.org 0x100		@ Definindo inicio do bloco de variaveis

varA:	.skip 4			@ VarA inicia em 0x100
varB:	.skip 4			@ VarB inicia em 0x104
varC:	.skip 4			@ VarC inicia em 0x108

		.org 0x200		@ Definindo inicio do bloco de instruções

start:
		ld r0,varA		@ Somando o valor das 3 variaveis junto
		ld r1,varB		@ da constante e armazenando os valores
		add r0,r1		@ em r0
		ld r1,varC
		add r0,r1
		set r1,0x1000
		add r0,r1
		hlt				@ Para

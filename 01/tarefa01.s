@ MC 404 - Lab 01 - Giovanni Bertão - ra173325

@ Definindo uma constante
COMPR	.equ	8
MAXVAL	.equ	100
MINVAL	.equ	-100

@ Reservando espaço para variaveis
		.org 0x400

sequencia:	.word	-200,-101,3,10,0x0,70,-10,-888	@ Vetor de 8 posições
i:			.skip	4								@ Variaveis internas
compr:		.skip	4
resultado:	.skip	4
p:			.skip	4								@ Apontador

@ Inicializar variveis

set	r0,0x0
st	resultado,r0
set	r0,COMPR
st	compr,r0
set	r0,sequencia
st	p,r0

@ Iniciar
		.org 0x100
inicio:
inicio_for:
	set r0,0
	st	i,r0
teste_for:
	ld r1,i
	ld r2,compr
	cmp r1,r2
	jge final_for
corpo_for:
	ld	r10,p
	ld	r1,[r10]
	set	r2,-100
	cmp	r1,r2
	jl	incremento
	ld 	r2,100
	jg	incremento
	ld 	r1,resultado
	add	r1,1
	st	resultado,r1
incremento:
	set r1,p
	add r1,4
	st	p,r1
	add r0,1
	st	i,r0
	jmp teste_for
final_for:
	@printf
@ Parando
hlt

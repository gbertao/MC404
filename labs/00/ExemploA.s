@ MC404 - Tarefa Exemplo - Giovanni Bertão - 173325
	.org	0x200	@ Definindo inicio em 0x200
start:
	set r0,0x5000	@ r0 <- 0x5000
	set r1,0x200	@ r1 <- 0x200
	add r0,r1		@ r0 <- r0+r1
	add r0,r0		@ r0 <- r0+r0
	add r0,r0		@ r0 <- r0+r0
	hlt				@ Para

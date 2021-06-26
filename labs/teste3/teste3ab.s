@ MC 404 - Teste 3 - Giovanni Bertão - ra173325
@ Programa implementa um contador da maior sequencia de bits 1
@ em uma palavra de 32 bits

.org 0x1000
@ Função sequencia: dada uma palavra de 32 bits em r0
@ Devolve em r0 o número da maior sequencia de bits 1 dessa palavra
sequencia:
	push {lr}

	ldr r1,=mask				@ Mascara
	mov r2,#0					@ Maior sequencia
	mov r3,#0					@ Sequencia vigente
	mov r4,#0					@ Deslocamento
	mov r9,#32					@ Bits restantes

loop:
	mov r5,r0					@ Copia seq orginal para r5
	mov r5,r5,lsr r4			@ Seq vigente em r5
	
	and r5,r1					@ Mascara do bms
	cmp r5,#1					@ Se 1, entao r3+=1
	
	addeq r3,#1

	blne maximo					@ r2 <- max(r2,r3)
	
	add r4,#1					@ Prepara para prox bit
	sub r9,#1
	cmp r9,#0					
	bne loop						@ Enquanto não foi todos os bits

	bl maximo					@ r2 <- max(r2,r3) do ultimo bit

	mov r0,r2					@ Resultado em r0
	
	pop {lr}						@ Retorna
	bx lr

@ Função maximo: r2<-max(r2,r3) e zera r3
maximo:
	cmp r2,r3					@ r2 <- max(r2,r3)
	movlt r2,r3
	mov r3,#0					@ reseta r3
	
	bx lr							@ retorna da função

@ Flag global
.global _start
_start:
	bl sequencia

@ Constantes
.set mask,0x01					@ Mascara do bms

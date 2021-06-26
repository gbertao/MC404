
.set mask1, 0x01
.set mask2,0x80000000
.global _start

_start:
	b palindrono
palindrono:
	ldr r2,=mask1
	ldr r3,=mask2
	ldr r6,#31

loop:
	mov r1,r0
	and r1,r2
	mov r1,r1,lsr#r6

	mov r5,r0
	and r5,r3

	cmp r1,r5

	movne r0,#0
	bne fim

	sub r6,#1
	mov r2,r2,lsl#1
	mov r3,r3,lsr#1

	cmp r2,r3
	blt loop

	mov r0,#1

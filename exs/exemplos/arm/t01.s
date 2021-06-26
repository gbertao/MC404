.global _start
_start:
	mov r0, #1
loop:
	mov r0,r0,lsr#1
	b loop

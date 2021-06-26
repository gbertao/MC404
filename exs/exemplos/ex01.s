@ Diferença dos valores
inicio:

set r1, 0x200 @ r1 = 00000200
set r2, 200	  @	r2 = 000000c8 = c*16+8 = 12*16 + 8 = 192 + 8 = 200
			  @ O montador transforma o 200 em 0xc8

set r1, 0xffffffff @ r1 e r2 tem os mesmos valores
set r2, -1

@ Limite dos registradores

add r3,127 @ Como add é imd 8, 0x7f = 127 é o maior valor possível
add r4,-127 @ é de se esperara que -127 = 0x81 seja o valor minimo
			@ -128 = 0x80 -> 0x7f + 1 = 0x80 = -128

set r5, 128
add r3, r5

set r5, 2147483647
set r6, -2147483647 @ Idem para o imd32

@ carregar registrador com endereçamento imediato
set r12,var1

@ Carrega registrador com endereçamento direto
ld	r13,var1

@ Indireto por registrador
ld r10,[r12]

@ Registrador indireto + cte
ld r9,[r12+1]

@ Carregar Byte no registrador
ldb	r11,[r9]

@ Parando
hlt

.org 0x7000
var1:	.byte 2
var2:	.byte 3

@ Este programa é só para aprender algumas coisas legais
@ Talvez não funcione como esperado

a:       .skip 4
b:       .skip 4
igual:   .byte 'Igual'
         .org 0x100
dif:     .byte 'DIFERENTE'
result:
         .org 0x700
inicio:
         ld r1,a
         ld r2,b
         set r10, result
         cmp r1,r2
         jnz else
         set r11, igual
         ld r12, [r11]
         st [r10],r12
         ld r12,[r11+4]
         st [r10+4],r12
         jmp fim
else:
         set r11, dif
         ld r12, [r11]
         st [r10],r12
         ld r12,[r11+4]
         st [r10+4],r12
         ld r12, [r11+8]
         st [r10+8],r12
fim:
         hlt

cadeia:  .skip 32
compr:   .skip 1
         .org 0x100
inicio:
         xor r0,r0
         set r12,cadeia
         ld r1,compr
         
while:
         ldb r2,[r12]
         rcr r2,1
         rcl r0,1
         add r12,1
         sub r1,1
         jnz while
         hlt

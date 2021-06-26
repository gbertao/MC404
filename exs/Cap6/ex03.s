compr:   .skip 1
cadeia:  .skip 32
         .org 0x100
inicio:
         set r12,cadeia
         xor r0,r0
         ldb r1,compr
while:
         ldb r2,[r12]
         shl r0,1
         sub r2,0x30
         or r0,r2
         add r12,1
         sub r1,1
         jnz while
         hlt

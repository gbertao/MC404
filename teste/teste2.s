cadeia:  .skip 31
carac:   .skip 1
index:   .word -1
rindex:  .word -1
         .org 0x400
inicio:
   set r0,cadeia
   set r1,0x0
   set r2,carac
while:
   ldb r3,[r0]
   cmp r3,r2
   jz achei
   cmp r3,0x0
   jz fim
   add r1,1
   shl r0,1
   jmp while
   
achei:
fim:
   hlt

@ UNICAMP 2018 - MC404 - Teste 1 - Giovanni Bertão - ra173325
@ Programa para encontrar o menor e maior indice de um caracter em uma cadeia
         .org 0x100
cadeia:  .skip 32
carac:   .skip 1
index:   .word -1
rindex:  .word -1
         .org 0x400
inicio:
         set r0,cadeia  @ r0<-&(cadeia[0])
         set r1,0x0     @ r1<-contador
         ldb r2,carac   
while:
         ldb r3,[r0]    @ r3<-cadeia[i]
         cmp r3,r2
         jz achei       @ Encontrado pela primeira vez
         cmp r3,0x0
         jz fim         @ Chegou ao fim
         add r1,1       @ Incrementar
         add r0,1
         jmp while
achei:
         st index,r1
         st rindex,r1
         add r0,1       
         add r1,1
while2:                 @ Procurar pelo rindex
         ldb r3,[r0]
         cmp r3,r2
         jz achei2      @ rindex sera alterado(ou não)
         cmp r3,0x0     @ até que chegue ao fim da cadeia
         jz fim
         add r1,1
         add r0,1
         jmp while2
achei2:
         st rindex,r1
         add r0,1
         add r1,1
         jmp while2
fim:
         hlt

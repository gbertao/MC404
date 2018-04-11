@ UNICAMP 2018 - MC404 - Lab 02 - Giovanni Bertão - ra173325

@ Constantes uteis
   FIM_MEMORIA    .equ 0x1000 @ Inicio da pilha
   CERCA          .equ 11     @ Define de #

@ Endereço de portas e bits de estado
   KEYBD_DATA     .equ 0x80
   KEYBD_STAT     .equ 0x81
   KEYBD_READY    .equ 1
   DISPLAY_DATA   .equ 0x40

@ Função read: Recebe a entrada pelo teclado e armazena em r0 um número [0,9] e em r1 {*,#}
read:
   set r2,KEYBD_READY   @ Esperando número do teclado
read1:
   inb r0,KEYBD_STAT
   tst r2,r0
   jz read1
   inb r0,KEYBD_DATA    @ r0 <- valor do teclado
read2:
   inb r1,KEYBD_STAT    @ Esperando segunda entrada do teclado
   tst r2,r1
   jz read2
   inb r1,KEYBD_DATA    @ r1 <- * ou #
   ret

@ Função display: Escreve no display de 7 segmentos o valor da tab_digitos[r0]
display:
   set r3,tab_digitos   @ r3<-&(tab_digitos[0])
   add r3,r0            @ r3<-&(tab_digitos[r0])
   ldb r0,[r3]          @ r0<-tab_digitos[r0]
   outb DISPLAY_DATA,r0 
   ret

   .org 0x200
inicio:
   xor r0,r0            @ Zerando os registradores
   xor r1,r1
   xor r2,r2
   xor r3,r3
   xor r4,r4            @ r4 é o atual valor da soma
   set sp,FIM_MEMORIA   @ Setando o stack pointer
   call display         @ Display inicial = 0
loop:
   call read            @ Realiza leituras
   add r4,r0            @ Atualiza r4(Soma)
   mov r0,r4
   call display         @ Manda a saída no display
   cmp r1,CERCA         @ Repete enquanto segunda parte da entrada != *
   jz loop
fim:
   hlt

@ Tabela digitos: tab_digitos[i] = representação de 'i' no display de 7 segmentos
tab_digitos:
   .byte 0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b,0x77,0x1f,0x4e,0x3d,0x4f,0x47

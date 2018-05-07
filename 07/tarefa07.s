@ UNICAMP 2018 - Lab 07 - MC404 - Giovanni Bertão - ra173325
@ Programa em ARM para contar o número de linhas em uma cadeia
@ de caracteres

   .global _start
   .org 0x1000
@ Função linhas: 
@ Recebe em r0 o endereço de uma cadeia de caracteres
@ Devolve em r0 o número de linhas
linhas:
   mov r1,r0            @ r1 <- r0
   mov r0,#0x00         @ r0 <- 0, iniciando o contador
loop:
   ldrb r2,[r1],#0x01   @ r2 <- caracter i da cadeia e passa para o próximo caracter
   cmp r2,#0x0a   
   addeq r0,#0x01       @ Se r2 = \n, então r0 <- r0 + 1
   cmp r2,#0x00         @ Loop para avaliar todos os caracteres da cadeia
   bne loop
   bx lr                @ Retornar da chamada

_start:
   bl linhas            @ Chama a função linhas

   /* syscall exit(int status) */
   mov r0, #0           @ status -> 0
   mov r7, #1           @ exit is syscall #1
   swi #0x55            @ invoke syscall


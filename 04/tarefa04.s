@ UNICAMP 2018 - MC404 - Lab 04 - Giovanni Bertão - ra173325
@ O programa utiliza um botão do tipo push para atualizar dois displays de LED
@ O programa executa continuamente

@ Constantes
   LED1  .equ 0x90
   LED2  .equ 0x91
   BOTAO .equ 0x40

         .org 0x400
inicio:
   set r0,tab_cores     @ r0 <- endereço do vetor de cores
   set r10,0x03         @ r10 <- 0b0111

@ Semaforo 1
   set r1,0x02          @ 0 <= r1 <= 3, r1 usado como indice
   add r1,r0            @ r1 <- endereço de uma cor do vetor
   ldb r11,[r1]         @ r11 <- codificação da cor
   out LED1,r11         @ LED1 é atualizado com a cor de r11
   sub r1,r0            @ r1 volta a ser o indice

@ Semaforo 2
   set r2,0x00          @ 0 <= r2 <= 3, r2 usado como indice
   add r2,r0            @ r2 <- endereço de uma cor do vetor
   ldb r12,[r2]         @ r12 <- codificação da cor
   out LED2,r12         @ LED2 é atualizado com a cor de r12
   sub r2,r0            @ r2 volta a ser o indice
   
loop:
   inb r3,BOTAO         @ Le estado do botão
   sub r3,1             @ Se estado do botão é desligado
   jc loop
   
@ Mudando a cor do Semaforo 1
   add r1,1             @ Indice r1 avança em 1
   and r1,r10           @ r1 <- r1 mod(4)
   add r1,r0            @ r1 <- &(cor[r1])
   ldb r11,[r1]         @ r11 <- cor[r1]
   out LED1,r11         @ LED1 é atualizado com a cor de r11
   sub r1,r0            @ r1 volta a ser o indice

@ Mudando a cor do Semaforo 2
   add r2,1             @ Indice r2 avança em 1
   and r2,r10           @ r2 <- r2 mod(4)
   add r2,r0            @ r2 <- &(cor[r2])
   ldb r12,[r2]         @ r12 <- cor[r2]
   out LED2,r12         @ LED2 é atualizado com a cor de r12
   sub r2,r0            @ r2 volta a ser o indice

@ Executa continuamente
   jmp loop
   
@ Tabela de codificação de cores
tab_cores:
         .byte 0x04, 0x02, 0x01, 0x02

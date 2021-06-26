@ UNICAMP 2018 - MC404 - Lab 06 - Giovanni Bertão - ra173325
@ O programa utiliza usa um timer para gerar interupções e alterar os
@ valores dos semaforos. Além disso, o timer escreve em dois 
@ mostradores de 7 segmentos o tempo faltante para mudança de estado.
@ O programa executa continuamente

@ Alteração: Antes eu usava um vetor de 4 posições para as cores,
@            Isso acabou dando erro no tempo de processamento. Agora
@            Estou usando os estados fixos nos registradores.

@ Constantes
   FIM_MEM     .equ 0x1000
   LED1        .equ 0x90
   LED2        .equ 0x91
   TIMER       .equ 0x50
   INT_TIMER   .equ 0x10
   MSD         .equ 0x41
   LSD         .equ 0x40
   MASCARA     .equ 0x7

@ Vetor de interrupções
               .org INT_TIMER * 4
               .word tratador

@ Variaveis
intervalo:     .word 30000

               .org 0x400
inicio:
   cli
   set sp, FIM_MEM      @ Definindo o endereço da pilha

@ Tabela digitos do mostrator de 7 segmentos
   set r3, tab_digitos  @ O mostrador esta ordenado em ordem decrescente
   set r4, 0x06         @ índice do MSD a ser mostrado
   set r5, 0x09         @ índice do LSD a ser mostrado

@ Semaforo 1
   set r1,0x24212421    @ Todos os estados do semaforo 1
   set r11,0x7          @ Isolar os ultimos 4 bits
   and r11,r1           @ r11 <- codificação da cor
   out LED1,r11         @ LED1 é atualizado com a cor de r11

@ Semaforo 2
   set r2,0x21242124    @ Todos os estados do semaforo 2
   set r11,MASCARA      @ Isolar os ultimos 4 bits
   and r11,r2           @ r12 <- codificação da cor
   out LED2,r11         @ LED2 é atualizado com a cor de r12
   
@ Inicializando o Timer
   set r7, intervalo
   out TIMER, r7
   sti

@ loop eterno até interrupção
loop:         
   jmp loop
   
@ Tratador de Interrupção
tratador:
   cmp r4, 0x9          @ Como esta em ordem decrescente 0x9 é a posição do valor 0
   jnz diminui
   cmp r5, 0x9
   jnz nao_zero
   call mudar_estado
   set r4, 0x6          @ Ordem decrescente -> vetor[0x6] = 3
nao_zero:
   cmp r5, 0x4          @ Ordem decrescente -> vetor[0x4] = 5
   jnz diminui
   call mudar_estado
diminui:
@ Escrevendo nos mostradores
   push r4              @ Salva o valor do indice r4 na pilha
   add r4, r3           @ r4 <- vetor_digitos[r4]
   ldb r4,[r4]          @ r4 é a codificação de um digito
   out MSD, r4          @ O digito mais significativo é atualizado
   pop r4               @ r4 recebe seu antigo valor

   push r5              @ Procedimento se repete para r5
   add r5, r3           @ e o digito menos significativo
   ldb r5,[r5]
   out LSD, r5
   pop r5               

@ Correndo o tempo
   add r5, 0x1          
   cmp r5, 0xa          @ r5 = 0xa -> LSD passou de 0, tem de atualizar o MSD
   jnz tratado
   set r5, 0x0
   add r4, 0x1          @ Atualiza o MSD
tratado:
   iret
   
mudar_estado:
@ Mudando a cor do Semaforo 1
   ror r1,4             @ Mudando o Estado      
   set r11,MASCARA
   and r11,r1           @ Usando a mascara, obtemos a codificação da cor
   out LED1,r11         @ LED1 é atualizado com a cor de r11

@ Mudando a cor do Semaforo 2
   ror r2,4             @ Mudando o Estado
   set r11, MASCARA             
   and r11,r2           @ Usando a mascara, obtemos a codificação da cor
   out LED2,r11         @ LED2 é atualizado com a cor de r11
   ret

@ Tabela de digitos
tab_digitos:
         .byte 0x7b,0x7f,0x70,0x5f,0x5b,0x33,0x79,0x6d,0x30,0x7e

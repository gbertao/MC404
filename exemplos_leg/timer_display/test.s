@ *************
@ ContaSegundos
@ *************
@ programa para contar continuamente os segundos de 0 a 9, 
@ usando interrupções do temporizador e um mostrador de 7 segmentos

@ constantes
     DISPLAY_DATA .equ 0x30 @ porta do mostrador
     TIMER_DATA   .equ 0x20 @ porta do temporizador
     INT_TIMER    .equ 0x12 @ interrupção do temporizador

     .org   0x400
_start:
     set   r0,INT_TIMER*4  @ posição no vetor de interrupções
     set   r1,int_tempo    @ endereço do tratador
     st    [r0],r1         @ instala tratador no vetor
     set   sp,0x10000      @ prepara pilha
     set   r0,0            @ 
     stb   dig_corrente,r0 @ zera valor dig_corrente
     call  atualiza_mostr  @ atualiza mostrador
     sti                   @ habilita interrupções
     set   r0,1000         @ liga temporizador com valor 
     out   TIMER_DATA,r0   @ para interromper a cada segundo
espera:
     wait                  @ espera por interrupção
     ldb   r0,dig_corrente @ pega valor do dígito corrente
     add   r0,1            @ decrementa
     cmp   r0,10           @ verifica se excedeu 9
     jnz   trata_tick1
     set   r0,0            @ dígito corrente é zero novamente
trata_tick1:
     stb   dig_corrente,r0 @ atualiza variável
     call  atualiza_mostr  @ e atualiza mostrador
     jmp   espera          @ e volta a esperar interrupção

@ procedimento para atualizar o mostrador com o valor de r0
atualiza_mostr:            
     set   r2,tab_digitos  @ indexa valor de r0 no vetor
     add   r2,r0           @ de dígitos para determinar a configuração
     ldb   r2,[r2]         @ de bits a ser escrita no mostrador
     outb  DISPLAY_DATA,r2 @ envia para o mostrador
     ret                   @ e retorna

@ rotina de interrupção do temporizador
int_tempo:
                           @ nada a fazer neste caso
     iret                  @ apenas retorna

@ variáveis
dig_corrente:
     .skip   1             @ valor corrente do mostrador
@ tabela de codificação de dígitos
tab_digitos:
     .byte    0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b,0x7e,0x7e

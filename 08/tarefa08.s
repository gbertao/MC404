@ UNICAMP 2018 - MC404 - Lab 08 - Giovanni Bertão - ra173325
         .global _start

@ Habilitar interupções externas
         .set EIRQ, 0x80
         .set EFIQ, 0x40

@ Código das interupções
         .set IRQ,0x6
         .set FIQ,0x7

@ Endereço dos dispositivos
         .set LEDS, 0x90000
         .set DM, 0xa0000
         .set DC, 0xa0001
         .set DD, 0xa0002
         .set DU, 0xa0003
         .set KEYB_STATE, 0xb0000
         .set KEYB_DATA, 0xb0001
         .set TIMER, 0xc0000
         .set BOTAO, 0xd0000

@ Constante de estado
         .set KEYB_READY, 1

@ Vetor de interupções
         .org IRQ*4
         b tratador_botao
         b tratador_timer

         .org 0x1000
_start:  
         mrs r0, cpsr
         bic r0,r0,#(EIRQ+EFIQ)
         msr cpsr,r0
         b aberto
         /* syscall exit(int status) */
         mov     r0, #0     @ status -> 0
         mov     r7, #1     @ exit is syscall #1
         swi     #0x55      @ invoke syscall 
aberto:
@ Apaga os LEDS
         ldr r0,=LEDS
         mov r1,#0x0
         str r1,[r0]

@ Apaga o Display
         ldr r0,=DM
         str r1,[r0]
         ldr r0,=DC
         str r1,[r0]
         ldr r0,=DD
         str r1,[r0]
         ldr r0,=DU
         str r1,[r0]
         
@ Esperando interupção do botão
loop_aberto:
         ldr r1,=flag_botao
         ldr r0,[r1]
         cmp r0,#1
         bne loop_aberto
         mov r0,#0
         str r0,[r1]
         b fechado

fechado:
@ Acende LED verde
         ldr r0,=LEDS
         mov r1,#1
         str r1,[r0]
@ Esperando interupção do botão ou teclado
loop_fechado:
         ldr r5,=flag_botao
         ldr r1,[r5]
         cmp r1,#1
         moveq r4,#0
         streq r4,[r5]
         beq aberto

         ldr r0,=KEYB_STATE
         ldr r1,[r0]
         cmp r1,#1
         beq digitando
         b loop_fechado
digitando:
         ldr r10, =DM
         ldr r7,=digitos
         eor r11,r11
         eor r12,r12
digitando_loop:
         ldr r2,=KEYB_DATA
         ldr r3,[r2]
         mov r12,r12,lsl#4
         add r12,r3
         ldr r3, [r7,+r3]
         str r3,[r10,+r11]
espera:
         ldr r0,=KEYB_STATE
         ldr r0,[r0]

         ldr r5,=flag_botao
         ldr r1,[r5]
         cmp r1,#1
         moveq r4,#0
         streq r4,[r5]
         beq aberto
         
         cmp r0,#1
         bne espera

         add r11,#1
         ldr r2,=KEYB_DATA
         ldr r3,[r2]

         mov r12,r12,lsl#4
         add r12,r3

         ldr r3, [r7,+r3]
         str r3,[r10,+r11]

         cmp r11,#3
         ldreq r11,=senha
         streq r12,[r11]
         beq travado

         ldr r5,=flag_botao
         ldr r1,[r5]
         cmp r1,#1
         moveq r4,#0
         streq r4,[r5]
         beq aberto

         b espera

travado:
@ Led Vermelho acesso
         ldr r0,=LEDS
         mov r1,#2
         str r1,[r0]

@ Apaga o Display
         mov r1,#0
         ldr r0,=DM
         str r1,[r0]
         ldr r0,=DC
         str r1,[r0]
         ldr r0,=DD
         str r1,[r0]
         ldr r0,=DU
         str r1,[r0]
loop_travado:
         ldr r0,=KEYB_STATE
         ldr r1,[r0]
         cmp r1,#1
         beq digitando2
         b loop_travado
digitando2:
         ldr r10, =DM
         ldr r7,=digitos
         eor r11,r11
         eor r12,r12
digitando_loop2:
         ldr r2,=KEYB_DATA
         ldr r3,[r2]
         mov r12,r12,lsl#4
         add r12,r3
         ldr r3, [r7,+r3]
         str r3,[r10,+r11]
espera2:
         ldr r0,=KEYB_STATE
         ldr r0,[r0]
         cmp r0,#1
         bne espera2

         add r11,#1
         ldr r2,=KEYB_DATA
         ldr r3,[r2]

         mov r12,r12,lsl#4
         add r12,r3

         ldr r3, [r7,+r3]
         str r3,[r10,+r11]

         cmp r11,#3
         bne espera2

         ldr r11,=senha
         ldr r11,[r11]
         cmp r11,r12
         bne travado
@ Senha certa: Apaga o Display e volta para estado fechado
         mov r1,#0
         ldr r0,=DM
         str r1,[r0]
         ldr r0,=DC
         str r1,[r0]
         ldr r0,=DD
         str r1,[r0]
         ldr r0,=DU
         str r1,[r0]
         b fechado

@ Tratadores de interupção
         .align 4
tratador_timer:
tratador_botao:
         ldr r7,=flag_botao
         mov r8,#1
         str r8,[r7]
         movs pc,lr

@ Flags usadas para controle
senha:
         .word 0
flag_botao:
         .word 0
flag_timer:
         .word 0
digitos:
         .byte 0x7e, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7f, 0x7b

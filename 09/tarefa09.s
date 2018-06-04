@ UNICAMP 2018 - MC404 - Lab 09 - Giovanni Bertão - ra173325

.text
@ Exportar _start como ponto de entrada
.global _start

@ Constantes

@ Porta dos botões
.equ B_parada, 0x90000
.equ B_PX_chegada, 0x90001
.equ B_PX_partida, 0x90002
.equ B_PY_chegada, 0x90003
.equ B_PY_partida, 0x90004
.equ B_PZ_chegada, 0x90005
.equ B_PZ_partida, 0x90006

@ Flags para habilitar interrupções
.set FIQ,0x40
.set IRQ,0x80

@ endereço das pilhas
.set STACK, 0x80000
.set STACK_FIQ, 0x72000
.set STACK_IRQ, 0x70000

@ Modos
.set IRQ_MODE, 0x12
.set FIQ_MODE, 0x11
.set USER_MODE, 0x10

@ Vetor de interupções
.org 6*4
b tratador_botao
b tratador_parada

@ Inicio do programa
.org 0x200
_start:
   @ Definir Pilha dos modos
   mov	sp,#0x500	      @ seta pilha do modo supervisor

   mov	r0,#IRQ_MODE	   @ r0 contém codificação do modo IRQ(0x12)
   msr	cpsr,r0		      @ seta Current Process Status Register no modo IRQ
   mov	sp,#STACK_IRQ	   @ seta pilha de interrupção IRQ

   mov	r0,#FIQ_MODE	   @ r0 <- codificação do modo FIQ(0x11)
   msr	cpsr,r0		      @ cpsr <- 0x11. Modo atual é FIQ
   mov	sp,#STACK_FIQ	   @ seta pilha de interrupção FIQ

   mov	r0,#USER_MODE	   @ r0 <- codificação do modo usuário(0x10)
   bic   r0,r0,#(FIQ+IRQ)  @ r0 <- 0x10 and not(FIQ+IRQ)
   msr	cpsr,r0		      @ cpsr: I=0; F=0; MODE=0x10
   mov	sp,#STACK	      @ seta pilha do usuário
   
   @ exit(0)
   mov r0,#0
   mov r7,#1
   svc #0x55

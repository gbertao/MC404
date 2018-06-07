@ UNICAMP 2018 - MC404 - Lab 09 - Giovanni Bertão - ra173325

.data
flag_parada:   .word 0
flag_botao:    .word 0
paradaX:       .ascii "Centro\n"
               .byte 0
paradaY:       .ascii "B. Geraldo\n"
               .byte 0
paradaZ:       .ascii "UNICAMP\n"
               .byte 0
prox:          .ascii "Proxima Parada:"
               .byte 0
atual:         .ascii "Esta e a Parada:"
               .byte 0
solici:        .ascii "Parada Solicitada\n"
               .byte 0
newline:       .ascii "\n"
               .byte 0
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

   b main                  @ Inicia o programa

   @ exit(0)
   mov r0,#0
   mov r7,#1
   svc #0x55

@ Função main
main:
   b deixa_Z

@ Chegou na parada
chega_X:

   bl Limpar_tela          @ Limpa o mostrador

   ldr r1,=atual           @ Escreve mensagem de parada atual
   bl escreve
   ldr r1,=paradaX
   bl escreve

@ Enquanto não deixou a parada X
loop_parada_X:

   ldr r0,=flag_botao      @ Verifica se deixou a parada
   ldr r0,[r0]
   cmp r0,#1               @ Botao de estado=1 -> deixou parada
   bne loop_parada_X

   ldr r0,=B_PX_partida    @ Verificando qual botão foi pressionado
   ldr r0,[r0]             @ Seta flag Z

   bl Clear_Buttons        @ Desativa os outros botoes

   cmp r0,#1               
   bne loop_parada_X       @ Enquanto Z != 1, não chegou na parada

   bl Limpar_tela          @ Limpa o mostrador

@ Deixando a parada
deixa_X:

   ldr r1,=prox            @ Escreve mensagem de prox parada
   bl escreve
   ldr r1,=paradaY
   bl escreve

   mov r10,#0              @ r10 = 0 -> não existe solicitação de parada

   bl Clear_Buttons        @ Desativa os outros botoes

   mov r7,#0               @ Limpando flag dos botões
   ldr r6,=flag_parada
   str r7,[r6]
   ldr r6,=flag_botao
   str r7,[r6]

loop_deixa_X:
                        
   ldr r0,=flag_parada     @ Verifica se parada foi solicitada
   ldr r1,[r0]
   cmp r1,#1

   ldr r1,=paradaY         @ Parada solicitada -> atualizar mostrador
   bleq Solicitar
   mov r1,#0
   str r1,[r0]             @ Reseta botão para 0

   ldr r0,=flag_botao      @ Verificando se chegou na parada de destino
   ldr r1,[r0]
   cmp r1,#1
   bne loop_deixa_X          
   mov r1,#0
   str r1,[r0]

   ldr r0,=B_PY_chegada    @ Verifica se o botão certo foi apertado
   ldr r0,[r0]

   bl Clear_Buttons        @ Desativa os outros botoes

   cmp r0,#1
   bne loop_deixa_X

@ Chegou na parada
chega_Y:

   bl Limpar_tela          @ Limpa o mostrador

   ldr r1,=atual           @ Escreve mensagem de parada atual
   bl escreve
   ldr r1,=paradaY
   bl escreve

@ Enquanto não deixou a parada Y
loop_parada_Y:

   ldr r0,=flag_botao      @ Verifica se deixou a parada
   ldr r0,[r0]
   cmp r0,#1               @ Botao de estado=1 -> deixou parada
   bne loop_parada_Y

   ldr r0,=B_PY_partida    @ Verificando qual botão foi pressionado
   ldr r0,[r0]             @ Seta flag Z

   bl Clear_Buttons        @ Desativa os outros botoes

   cmp r0,#1               
   bne loop_parada_Y       @ Enquanto Z != 1, não chegou na parada

   bl Limpar_tela          @ Limpa o mostrador

@ Deixando a parada
deixa_Y:

   ldr r1,=prox            @ Escreve mensagem de prox parada
   bl escreve
   ldr r1,=paradaZ
   bl escreve

   mov r10,#0              @ r10 = 0 -> não existe solicitação de parada

   bl Clear_Buttons        @ Desativa os outros botoes

   mov r7,#0               @ Limpando flag dos botões
   ldr r6,=flag_parada
   str r7,[r6]
   ldr r6,=flag_botao
   str r7,[r6]

loop_deixa_Y:
                        
   ldr r0,=flag_parada     @ Verifica se parada foi solicitada
   ldr r1,[r0]
   cmp r1,#1

   ldr r1,=paradaZ         @ Parada solicitada -> atualizar mostrador
   bleq Solicitar
   mov r1,#0
   str r1,[r0]             @ Reseta botão para 0

   ldr r0,=flag_botao      @ Verificando se chegou na parada de destino
   ldr r1,[r0]
   cmp r1,#1
   bne loop_deixa_Y          
   mov r1,#0
   str r1,[r0]

   ldr r0,=B_PZ_chegada    @ Verifica se o botão certo foi apertado
   ldr r0,[r0]

   bl Clear_Buttons        @ Desativa os outros botoes

   cmp r0,#1
   bne loop_deixa_Y

@ Chegou na parada
chega_Z:

   bl Limpar_tela          @ Limpa o mostrador

   ldr r1,=atual           @ Escreve mensagem de parada atual
   bl escreve
   ldr r1,=paradaZ
   bl escreve

@ Enquanto não deixou a parada Z
loop_parada_Z:

   ldr r0,=flag_botao      @ Verifica se deixou a parada
   ldr r0,[r0]
   cmp r0,#1               @ Botao de estado=1 -> deixou parada
   bne loop_parada_Z

   ldr r0,=B_PZ_partida    @ Verificando qual botão foi pressionado
   ldr r0,[r0]             @ Seta flag Z

   bl Clear_Buttons        @ Desativa os outros botoes

   cmp r0,#1               
   bne loop_parada_Z         @ Enquanto Z != 1, não chegou na parada

   bl Limpar_tela          @ Limpa o mostrador

@ Deixando a parada
deixa_Z:

   ldr r1,=prox            @ Escreve mensagem de prox parada
   bl escreve
   ldr r1,=paradaX
   bl escreve

   mov r10,#0              @ r10 = 0 -> não existe solicitação de parada

   bl Clear_Buttons        @ Desativa os outros botoes

   mov r7,#0               @ Limpando flag dos botões
   ldr r6,=flag_parada
   str r7,[r6]
   ldr r6,=flag_botao
   str r7,[r6]

loop_deixa_Z:
                        
   ldr r0,=flag_parada     @ Verifica se parada foi solicitada
   ldr r1,[r0]
   cmp r1,#1

   ldr r1,=paradaX         @ Parada solicitada -> atualizar mostrador
   bleq Solicitar
   mov r1,#0
   str r1,[r0]             @ Reseta botão para 0

   ldr r0,=flag_botao      @ Verificando se chegou na parada de destino
   ldr r1,[r0]
   cmp r1,#1
   bne loop_deixa_Z          
   mov r1,#0
   str r1,[r0]

   ldr r0,=B_PX_chegada    @ Verifica se o botão certo foi apertado
   ldr r0,[r0]

   bl Clear_Buttons        @ Desativa os outros botoes

   cmp r0,#1
   bne loop_deixa_Z

   b chega_X               @ Reiniciar trajeto

@ Função para Limpar o mostrador
Limpar_tela:
   push {lr}               @ Empilha registrador
   mov r0, #2
   ldr r1,=newline         @ Escreve \n
loop_tela:
   bl escreve
   subs r0,#1
   bne loop_tela

   pop {lr}                @ Desempilha
   bx lr                   @ Retorna
   
@ Função para Limpar os botões
Clear_Buttons:
   mov r6,#-1
loop_clear:
   add r6,#1               @ r1 é o offset
   ldr r7,=B_parada        @ Endereco inicial do conj de botoes
   add r7,r6               @ READ( end+offset )
   ldr r7,[r7]
   cmp r6,#6               @ Enquanto <6 repete
   bne loop_clear

   bx lr

@ Função para solicitar parada, recebe prox parada em r1, somente se r10 for 0
Solicitar:
   cmp r10,#0
   moveq r11,r1
   ldreq r1,=solici        @ Escreve mensagem de prox parada
   push {lr}               @ Empilha registrador
   bleq escreve
   pop {lr}                @ Desempilha
   moveq r1,r11

   mov r10,#1

   bx lr

@ Função para escrever no console, mensagem passada em r1
escreve:
   mov r2,#-1
escreve1:
   add r2,#1               @ Contando o numero de char
   ldrb r3,[r1,r2]
   cmp r3, #0
   bne escreve1            @ r2 tem o numero de char

   mov r0,#1               @ write(r0, r1, r2) 
   mov r7,#4               @        |   |   |->len
   svc #0x55               @        |   |->string *
                           @        |->stdout

   bx lr                   

@ Tratador IRQ
tratador_botao:
   ldr r8,=flag_botao
   mov r9,#1
   str r9,[r8]
   movs pc,lr

@ Tratador FIQ
tratador_parada:
   ldr r8,=flag_parada
   mov r9,#1
   str r9,[r8]
   movs pc,lr

@ UNICAMP 2018 - MC404 - Lab 08 - Giovanni Bertão - ra173325
@ Este programa simula o funcionamento de um cofre de 4 digitos comumente utilizado em hoteis

         .global _start
@ flag para habilitar interrupções externas no registrador de status
         .set IRQ, 0x80
         .set FIQ, 0x40

@ endereços das pilhar
         .set STACK,     0x80000
         .set STACK_FIQ, 0x72000
         .set STACK_IRQ, 0x70000
	
@ modos de interrupção no registrador de status
         .set IRQ_MODE,0x12
         .set FIQ_MODE,0x11
         .set USER_MODE,0x10
	
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

@ vetor de interrupções
         .org  6*4               @ preenche apenas duas posição do vetor, 6 e 7
         b      tratador_botao
         b      tratador_timer
	
         .org 0x200
_start:
         mov	sp,#0x500	@ seta pilha do modo supervisor
         mov	r0,#IRQ_MODE	@ coloca processador no modo IRQ (interrupção externa)
         msr	cpsr,r0		@ processador agora no modo IRQ
         mov	sp,#STACK_IRQ	@ seta pilha de interrupção IRQ
         mov	r0,#FIQ_MODE	@ coloca processador no modo IRQ (interrupção externa)
         msr	cpsr,r0		@ processador agora no modo FIQ
         mov	sp,#STACK_FIQ	@ seta pilha de interrupção FIQ
         mov	r0,#USER_MODE	@ coloca processador no modo usuário
         bic   r0,r0,#(FIQ+IRQ)@ interrupções FIQ e IRQ habilitadas
         msr	cpsr,r0		@ processador agora no modo usuário
         mov	sp,#STACK	@ pilha do usuário no final da memória 
         
         b aberto

@ Estado aberto: O cofre esta com a porta aberta
@ Proximo estado: fechado
@ - Condição para mudar: Fechar a porta(interrupção no botão).
aberto:
@ Reseta flags e desativa timer
         mov r0,#0
         ldr r1,=TIMER
         str r0,[r1]
         ldr r1,=flag_timer
         str r0,[r1]
         ldr r1,=flag_botao
         str r0,[r1]

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
         ldr r1,=flag_botao      @ Loop aguarda por uma mudança de estado da porta
         ldr r0,[r1]
         cmp r0,#1
         bne loop_aberto
         mov r0,#0
         str r0,[r1]
         b fechado               @ MudarEstadoPorta, quando estado_cofre = aberto -> estado_cofre <- fechado

@ Estado fechado: A porta do cofre esta fechada e ele esta pronto para programar a senha
@ Proximo estado: Aberto
@ - Condição: Abrir a porta(Interrupção do botão)
@ Proximo estado: Travado
@ - Condição: Digitar 4 digítos no teclado(programar senha)
fechado:
@ Reseta flags e desativa timer
         mov r0,#0
         ldr r1,=TIMER
         str r0,[r1]
         ldr r1,=flag_timer
         str r0,[r1]
         ldr r1,=flag_botao
         str r0,[r1]

@ Acende LED verde
         ldr r0,=LEDS
         mov r1,#1
         str r1,[r0]

@ Apagar display e reniciar flag do timer
apaga_fechado:
         mov r1,#0
         ldr r0,=flag_timer
         str r1,[r0]
         ldr r0,=DM
         str r1,[r0]
         ldr r0,=DC
         str r1,[r0]
         ldr r0,=DD
         str r1,[r0]
         ldr r0,=DU
         str r1,[r0]

@ Esperando interupção do botão ou teclado
loop_fechado:
         ldr r5,=flag_botao   @ Verificamos se a porta mudou de estado
         ldr r1,[r5]
         cmp r1,#1
         moveq r4,#0
         streq r4,[r5]
         beq aberto           @ mudarEstadoPorta, quando estado_cofre = fechado -> estado_cofre <- aberto

         ldr r0,=KEYB_STATE   
         ldr r1,[r0]
         cmp r1,#1
         beq digitando        @ Primeiro digito enviado, devemos iniciar o contador
         b loop_fechado

@ O digito da milhar(DM) foi digitado, esperando pelos outros digitos ou exceder o tempo
digitando:
         ldr r10, =DM
         ldr r7,=digitos
         eor r11,r11
         eor r12,r12

         ldr r4,=TIMER
         ldr r5,=intervalo1   @ preparar temporarizador para programar em 10 segundos
         ldr r5,[r5]
         ldr r6,=flag_timer
         
digitando_loop:
         ldr r2,=KEYB_DATA
         ldr r3,[r2]
         mov r12,r12,lsl#4    @ A sequencia de 4 digitos é salva em r12(senha)
         add r12,r3
         ldr r3, [r7,+r3]
         str r3,[r10,+r11]    @ Printando no 7seg, r11 é o offset dos digitos das milhar, centena, dezena e unidade
         
         str r5,[r4]          @ Setando timer para 10s
espera:
         ldr r9,[r6]          @ r9 é o valor da flag_timer
         ldr r0,=KEYB_STATE
         ldr r0,[r0]

         ldr r8,=flag_botao   @ A porta ainda pode abrir durante a digitação
         ldr r1,[r8]
         cmp r1,#1            @ Se a porta abriu, então volte para o estado aberto
         moveq r4,#0
         streq r4,[r8]
         beq aberto 
         
         cmp r9,#1            @ Se a porta esta fechada, checamos se houve timeout do timer
         beq apaga_fechado

         cmp r0,#1            @ Por fim, checamos se algo foi digitado
         bne espera

         add r11,#1           @ Caso algo foi digitado
         ldr r2,=KEYB_DATA
         ldr r3,[r2]

         mov r12,r12,lsl#4    @ r12 é atualizado
         add r12,r3

         ldr r3, [r7,+r3]
         str r3,[r10,+r11]    @ Mostrador atualizado

         cmp r11,#3           @ Verificar número de digitos digitados
         movne r9,#0          @ Se ainda não digitamos todos os 4
         strne r9,[r6]        @ Reiniciamos a flag_timer para 0
         strne r5,[r4]        @ Resetamos o timer para 10s
         bne espera           @ Laço de espera pelo próximo digito

         ldr r11,=senha       @ Senão, guardamos a senha de r12
         str r12,[r11]        @ Na variavel 'senha' e mudamos de estado
         b travado

@ Estado Travado: o cofre esta fechado e protegido por uma senha de 4 digitos
@ Proximo estado: Fechado
@ - Condicao para mudanca de estado: A senha digitada no estado fechado deve ser a mesma da digitada no estado travado
@ Proximo estado: Blocked
@ - Condicao para mudanca de estado: A senha digitada no estado travado deve estar diferente da digitada no estado fechado
@             em 3 vezes consecutivas
travado:
@ Reseta flags e desativa timer
         mov r0,#0
         ldr r1,=TIMER
         str r0,[r1]
         ldr r1,=flag_timer
         str r0,[r1]
         ldr r1,=flag_botao
         str r0,[r1]

@ Led Vermelho acesso
         ldr r0,=LEDS
         mov r1,#2
         str r1,[r0]

@ Apagar o Display
         
         ldr r0,=TIMER
         ldr r1,=intervalo2   @ Intervalo2 de 5 segundos para apagar o mostrador
			ldr r1,[r1]
         str r1,[r0]          @ Seta timer para 5s
         ldr r0,=flag_timer   
			mov r2,#1
cooldown_apagar:
         ldr r1,[r0]
         cmp r1,r2
         bne cooldown_apagar  @ Loop para esperar 5 segundos

@ Apagar mostrador e resetar flag_timer
apagar_travado:        
         mov r1,#0
         ldr r0,=flag_timer
         str r1,[r0]
         ldr r0,=DM
         str r1,[r0]
         ldr r0,=DC
         str r1,[r0]
         ldr r0,=DD
         str r1,[r0]
         ldr r0,=DU
         str r1,[r0]

@ Checar se o número de falhas consecutivas é 3
         ldr r0,=tentativas
         ldr r0,[r0]
         cmp r0,#3
         beq blocked

@ Esperar pelo input de 4 digitos do teclado e atualizar mostrador
loop_travado:
         ldr r0,=KEYB_STATE   
         ldr r1,[r0]
         cmp r1,#1
         beq digitando2       @ Enquando digito da milhar não é escolhido, o laço fica parado
         b loop_travado
digitando2:
         ldr r10, =DM         @ O digito da milhar foi escolhido
         ldr r7,=digitos      @ r7 é o vetor de digitos no mostrador, r7[i] = 'i no mostrador'
         eor r11,r11          @ r11 é o contador de falhas
         eor r12,r12          @ r12 sera a tentativa de senha

         ldr r4,=TIMER
         ldr r5,=intervalo1   @ O mostrador se apaga, se em 10s nada foi digitado
         ldr r5,[r5]
         ldr r6,=flag_timer   @ watch da flag_timer
digitando_loop2:
         ldr r2,=KEYB_DATA
         ldr r3,[r2]
         mov r12,r12,lsl#4    @ r12 é atualizado
         add r12,r3
         ldr r3, [r7,+r3]     @ r3 é a codificação do digito no 7segmentos
         str r3,[r10,+r11]    @ Atualiza mostrador, r11 é o offset
         str r5,[r4]          @ seta timer para 10s

@ Esperando que os outros digitos sejam escolhidos ou uma interupção do timer mude a flag_timer
espera2:
         ldr r9,[r6]          @ r9 tem o valor da flag_timer
         ldr r0,=KEYB_STATE
         ldr r0,[r0]

         cmp r9,#1
         beq apagar_travado   @ Se uma flag_timer = 1, então apague o mostrador e reinicie a digitação

         cmp r0,#1            @ enquanto não foi digitado nada, aguarde
         bne espera2

         add r11,#1
         ldr r2,=KEYB_DATA    @ Algo foi digitado
         ldr r3,[r2]

         mov r12,r12,lsl#4    @ Atualiza senha
         add r12,r3

         ldr r3, [r7,+r3]     
         str r3,[r10,+r11]    @ Atualiza o mostrador, utilizando r10 = end mostrador + r11 = offset

         cmp r11,#3           @ Verificar se os 4 digitos foram escolhidos
         movne r9,#0          @ Se ainda não temos os 4 digitos, mas algo foi digitado e ainda não deu timeout
         strne r9,[r6]        @ seta flag_timer para 0
         strne r5,[r4]        @ Reseta timer para 10segundos
         bne espera2          @ Arguade digitar os 4 digitos

@ Comparar senha digitada e senha salva
         str r9,[r4]          @ Desabilita timer
         ldr r11,=senha       
         ldr r11,[r11]
         cmp r11,r12          @ Comparando senhas
         ldr r2,=tentativas
         ldr r11,[r2]
         addne r11,#1         @ Se diferem então, incremente 1 nas tentativas
         strne r11,[r2]
         bne apagar_travado   @ Reinicia tentativa

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
         ldr r0,=tentativas   @ Como acertou, então ele pode fazer mais 3 tentativas da proxima senha
         str r1,[r0]          @ Resetnado o número de tentativas
         b fechado

@ Estado blocked: Neste estado, 3 falhas consecutivas para abrir o cofre aconteceram. Nenhum input funcionará
@                 E o cofre não pode sair desse estado
blocked:
         b blocked

@ Tratadores de interupção

@ O tratador_timer seta a flag_timer para 1 indicando que o timeout expirou
tratador_timer:
         ldr r7,=flag_timer
         mov r8,#1
         str r8,[r7]
         movs pc,lr           @ iret

@ O tratador_botao seta a flag_botao para 1 indicando que houve uma alteração no estado da porta do cofre
tratador_botao:
         ldr r7,=flag_botao
         mov r8,#1
         str r8,[r7]
         movs pc,lr           @ iret

@ Flags e variaveis usadas para controle
tentativas:
         .word 0
intervalo1:
         .word 10000
intervalo2:
			.word 5000
senha:
         .word 0
flag_botao:
         .word 0
flag_timer:
         .word 0
digitos:
         .byte 0x7e, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7f, 0x7b

@ UNICAMP 2018 - Teste 2 - MC404 - Giovanni Bertão - ra173325
@ Programa simulando o strncpy
@ Recebe em r0 o endereço da cadeia a ser copiada
@ Recebe em r1 o endereço da cadeia será a cópia
@ Recebe em r2 a quantidade de caracteres que deve copiar de r0
@ Devolve em r0 o número de caracteres efetivamente copiadas
@ A cadeia em r1 recebe o bit terminador 0x0

   .global _start
   .org 0x1000
@ Função strncpy
strncpy:
   mov r4, r0           @ r4 recebe o valor de r0 (preservar)
   mov r0, #0x0         @ r0 <- 0, iniciando o contador de caracteres copiados
   cmp r2,#0x0          @ Se len é 0 então saia
   beq fim		
loop:
   ldrb r3,[r4],#0x01   @ Carrega em r3 o valor do caracter e incrementa 1 em r4
   cmp r3,#0x0          @ se 0x0, então saia. Fim da cadeia
   beq fim
   add r0,#0x01         @ Senão, incremente 1 no contador de r0
   strb r3,[r1],#0x01   @ Copia na cadeia alvo o caracter e incrementa 1 posição
   sub r2, r2, #0x01    @ Menos 1 caracter para copiar
   cmp r2,#0x0          @ Repete até que copiado todos os caracteres
   bne loop
fim:                
   mov r3,#0x0          @ Copia terminador para cadeia alvo
   strb r3,[r1]         
   bx lr                @ Retorna da função
	
_start:
   bl strncpy           @ Chamada à função stncpy

   /* syscall exit(int status) */
   mov r0, #0           @ status -> 0
   mov r7, #1           @ exit is syscall #1
   swi #0x55            @ invoke syscall

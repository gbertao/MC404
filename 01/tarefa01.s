@ MC 404 - Lab 01 - Giovanni Bertão - ra173325
@ Dado uma sequencia de números o programa guarda em 'resultado'
@ a quantidade dos números que pertencem a [-100,100]

@ Definindo constantes
COMPR       .equ 8
MAXVAL      .equ 100
MINVAL      .equ -100

@ Reservando espaço para variaveis
            .org 0x400

sequencia:  .skip 4*MAXVAL    @ Espaço suficiente
i:          .skip 4	         @ Variaveis internas
compr:      .skip 4
resultado:  .skip 4
p:          .skip 4           @ Apontador

@ Iniciar
            .org 0x100
inicio:
@ Inicializar variveis
            set r0,0x0
            st resultado,r0
            set r0,sequencia
            st p,r0           @ p <- &(sequencia)

inicio_for:
            set r0,0          @ r0 = iterador
            st i,r0
teste_for:
            ld r1,i           @ r1 e r2 aux para comparaçoes
            ld r2,compr       
            cmp r1,r2
            jge final_for
corpo_for:
            ld r10,p          @ r10<-&(seq[i])
            ld r1,[r10]
            set r2,MINVAL  
            cmp r1,r2         @ sequencia[i] < MIN ?
            jl incremento
            set r2,MAXVAL
            cmp r1,r2         @ sequencia[i] > MAX ?
            jg incremento
            ld r1,resultado   @ update resultado
            add r1,1
            st resultado,r1
incremento:
            ld r1,p           @ verificar sequencia[i+1]
            add r1,4
            st p,r1
            add r0,1          @ r0 + 1 = i + 1
            st i,r0
            jmp teste_for
final_for:
            hlt	            @ Parando

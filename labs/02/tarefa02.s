@ UNICAMP 2018 - MC404 - Lab 02 - Giovanni Bertão - ra173325
@ Esse programa soma os valores de um vetor de inteiros com sinal
@ e divide essa soma por uma portencia de 2

            .org 0x100
divisor:    .skip 4
num_elem:   .skip 4
vetor:
            .org 0x1000
inicio:
            set r10,0xffff0000   @ Mascara para isolar os 4 MSB
            ld r1,num_elem
            set r2,vetor
            xor r0,r0            @ Zerando r0, r0 sera a soma 
parser:
            ld r3,[r2]
            shl r3,16            @ Isolando o primeiro valor da palavra
            sar r3,16            @ mantendo o sinal (4 LSB)
            add r0,r3
            sub r1,1
            jz fim_parser        @ Todos os elementos foram somados?

            ld r4,[r2]           @ Isolando a segunda valor da palavra
            and r4,r10           @ (4 MSB)
            sar r4,16
            add r0,r4
            add r2,4
            sub r1,1
            jnz parser           @ Falta valores para serem somados?
fim_parser:
            ld r1,divisor        @ Dado o divisor = 2^x
            xor r2,r2            @ queremos encontrar o valor de x
calc_div:
            add r2,1
            shr r1,1
            jnz calc_div
            sub r2,1             @ r2<-x
dividir:
            sar r0,r2            @ r0<-r0/2^r2
            hlt                  @ Fim

@ Dado uma estrutura de 32 bit, verifica se os dois ultimos Nible são iguais
estrutura:  .skip 4
sim:        .byte 'S'
nao:        .byte 'N'
resultado:  .skip 1
            .org 0x100
inicio:
            ld r0,estrutura
            set r10,0x0f
            set r11,0xf0

            mov r1,r0
            mov r2,r0

            and r1,r10
            and r2,r11

            shr r2,4

            cmp r1,r2
            jz igual
            ldb r3,nao
            jmp fim
igual:
            ldb r3,sim
fim:
            st resultado,r3
            hlt

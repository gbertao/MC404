            .org 0x100
divisor:    .skip 4
num_elem:   .skip 4
vetor:
            .org 0x1000
inicio:
            set r10,0xffff0000
            set r11,0x0000ffff
            ld r1,num_elem
            set r2,vetor
            xor r0,r0
parser:
            ld r3,[r2]
            and r3,r11
            add r0,r3
            sub r1,1
            jz fim_parser

            ld r4,[r2]
            and r4,r10
            sar r4,16
            add r0,r4
            add r2,4
            sub r1,1
            jnz parser
fim_parser:
            ld r1,divisor
            xor r2,r2
calc_div:
            add r2,1
            shr r1,1
            jnz calc_div
            sub r2,1
dividir:
            shr r0,r2
            hlt

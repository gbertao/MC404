         .org 0x100
cadeia:  .skip 31*8
         .org 0x7000
inicio:
         set r0,0x0     @ r0 <- len(cadeia)
         set r1,cadeia
while:
         ldb r2,[r1]
         cmp r2,0x00
         jz fim_while
         add r0,1
         add r1,1
         jmp while
fim_while:
         mov r10,r0
         set r11,cadeia
         add r10,r11    @ r10<-&(cadeia[len])
         sub r10,1
         set r1,cadeia  @ r1 <- &(cadeia[0])
         set r2,0x00    @ r2 <- i
         shr r0,1
for:
         cmp r2,r0
         jge final_for
         ldb r9,[r1]    @ r9 <- cadeia[i]
         ldb r8,[r10]   @ r8 <- cadeia[len-i]
         xor r9,r8      @ swap(r8,r9)
         xor r8,r9      
         xor r9,r8
         stb [r1],r9
         stb [r10],r8    
         add r1,1
         sub r10,1
         add r2,1
         jmp for
final_for:
         hlt

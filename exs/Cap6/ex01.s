@ Programa para inverter o bit mais significativo com o menos significativo
@ de r0

inicio:
   set r10,0x800000000
   set r11,0x1
   set r12,0x7fffffffe

   mov r1,r0
   mov r2,r0

   and r0,r12
   
   and r1,r11
   jz x_zero
   or r0,r10

x_zero:
   and r2,r10
   jz y_zero
   or r0,r11

y_zero:
   hlt

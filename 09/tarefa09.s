@ UNICAMP 2018 - MC404 - Lab 09 - Giovanni Bertão - ra173325

.text
.global _start

_start:
   
   @ exit(0)
   mov r0,#0
   mov r7,#1
   svc #0x55

@ programa para contar em binário, mostrando valor em painel de leds
	
@ define constantes
     LEDS       .equ 0x20     @ porta de dados do painel de leds
     INTERVALO  .equ 0xfffff  @ valor para contador temporizador

     .org 0x100
_start:
     set  r1,INTERVALO   @ valor inicial do contador
     set  r0,1           @ valor inicial para leds
     outb LEDS,r0        @ escreve valor inicial
loop:
     sub  r1,1           @ decrementa contador temporizador
     jnz  loop           @ espera contador temporizador chegar a zero
     add  r0,1           @ adiciona 1 ao valor a ser mostrado
     outb LEDS,r0        @ escreve valor nos leds
     set  r1,INTERVALO   @ reinicializa contador
     jmp loop            @ e continua

all:
	arm-none-eabi-linux-as -o tarefa10.o tarefa10.s
	arm-none-eabi-linux-ld -o tarefa10 -Tmapa.lds tarefa10.o
run: all
	armsim -l tarefa10 -d devices.txt

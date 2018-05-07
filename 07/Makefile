all:
	arm-none-eabi-linux-as -o tarefa07.o tarefa07.s
	arm-none-eabi-linux-ld -o tarefa07 tarefa07.o
run: all
	armsim -l tarefa07

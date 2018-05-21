all:
	arm-none-eabi-linux-as -o tarefa08.o tarefa08.s
	arm-none-eabi-linux-ld -o tarefa08 tarefa08.o
run: all
	armsim -l tarefa08 -d devices.txt

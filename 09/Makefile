all:
	arm-none-eabi-linux-as -o tarefa09.o tarefa09.s
	arm-none-eabi-linux-ld -o tarefa09 -Tmapa.lds tarefa09.o
run: all
	armsim -c -l tarefa09 -d devices.txt

all:
	arm-none-eabi-linux-as -o teste2.o teste2.s
	arm-none-eabi-linux-ld -o teste2 teste2.o
run: all
	armsim -l teste2

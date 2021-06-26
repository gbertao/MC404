all:
	arm-none-eabi-linux-as -o teste3ab.o teste3ab.s
	arm-none-eabi-linux-ld -o teste3ab teste3ab.o
run: all
	armsim -l teste3ab

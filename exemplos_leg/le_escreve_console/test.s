@ programa para ler e escrever usando a console


@ algumas constantes
READ    .equ    3       @ tipo de chamada ao sistema
WRITE   .equ    4       @ tipo de chamada ao sistema
STDOUT  .equ    1       @ descritor do dispositivo de saída padrão
STDIN   .equ    0       @ descritor do dispositivo de entrada padrão

_start:
@ le uma cadeia de caracteres da console (entrada padrão, STDIN)	
	set  r0,STDIN   @ dispositivo
	set  r1,buffer  @ endereço onde devem ser armazenados os caracteres lidos
	set  r2,256     @ lê no máximo 256 caracteres
	set  r7,READ    @ tipo de chamada é de leitura
	sys  0x55       @ chamada a sistema
                        @ r0 retorna com número de bytes lidos

@ escreve a cadeia lida na console (saída padrão, STDOUT)
	mov  r2,r0      @ bytes lidos em r2
	                @ r1 tem endereço de início da cadeia
	set  r0,STDOUT  @ dispositivo
	set  r7,WRITE   @ tipo de chamada é de escrita
	sys  0x55       @ chamada a sistema

	hlt             @ interrompe a execução

@ área de dados
buffer:
	.skip 256       @ área para armazenar caracteres lidos
	

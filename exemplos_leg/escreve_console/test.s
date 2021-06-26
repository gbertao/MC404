@ Bateria de testes
@ Autor : Ricardo Anido

@*************************
@ algumas constantes
@*************************
LF	.equ	0x0a	@ line feed
CR	.equ	0x0d	@ carriage return
WRITE   .equ    4       @ tipo de chamada ao sistema
CONSOLE .equ    1       @ descritor do dispositivo saída padrão

@ escreve uma  mensagem na console
_start:
	set sp,0x10000  @ prepara pilha
	set r0, msg
        call escreve_cadeia
	hlt

@ **************
@ escreve_cadeia
@ **************
@   Escreve uma cadeia de caracteres terminada por zero na
@   saída padrão (console), usando a chamada de sistema write.
@ entrada:  
@   r0 com endereço da cadeia
@ saída:  
@   r0 com valor negativo em caso de erro
@ destrói:
@   r0, r1 e r2
@ constantes
escreve_cadeia:
    mov   r1,r0           @ r1 tem início da cadeia
    mov   r2,r0           @ vamos usar r2 para procurar final
    sub   r2,1             
escreve_cadeia1:
    add   r2,1
    ldb   r3,[r2]         @ procura final da cadeia
    cmp   r3,0            @ que é indicado por byte 0
    jnz   escreve_cadeia1 @ continua laço se não encontrou final
    set   r7,WRITE        @ tipo de serviço é write; r1 já tem endereço
    set   r0,CONSOLE      @ dispositivo queremos acessar em r0
    sub   r2,r1           @ número de bytes a serem escritos em r2
    sys   0x55            @ executa chamada a sistema
    ret                  

@*************************
@ area de dados
@*************************

@ mensagem
msg:	.byte 'Sou o LEG!',CR,LF,0
fim_cadeia:


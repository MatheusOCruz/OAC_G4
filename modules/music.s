.data
NOTES: 69,500,76,500,74,500,76,500,79,600, 76,1000,0,1200,69,500,76,500,74,500,76,500,81,600,76,1000
NOTES_SIZE: .word 13

.text 
# t1 = Endereco das notas
# t2 = Numero de notas
# t3 = contador de notas

la t1, NOTES # Carrega o endereço das notas
lw t2, NOTES_SIZE # Carrega a word do tamanho das notas
li t3, 0 # Zera o contador de notas
li a2,68		# define o instrumento
li a3,127		# define o volume

LOOP:	
	beq t0,s1, FIM		# contador chegou no final? então  vá para FIM
	lw a0,0(t1)		# le o valor da nota
	lw a1,4(t1)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	mv a0,a1		# passa a duração da nota para a pausa
	li a7,32		# define a chamada de syscal 
	ecall			# realiza uma pausa de a0 ms
	addi t1,t1,8		# incrementa para o endereço da próxima nota
	addi t3,t3,1		# incrementa o contador de notas
	j LOOP			# volta ao loop
	
FIM:	li a0,40		# define a nota
	li a1,1500		# define a duração da nota em ms
	li a2,127		# define o instrumento
	li a3,127		# define o volume
	li a7,33		# define o syscall
	ecall			# toca a nota
	
	li a7,10		# define o syscall Exit
	ecall			# exit

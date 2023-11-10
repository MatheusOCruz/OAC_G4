.data
# FA LA SI 2x
NOTES: .word 65, 250, 69, 250, 71, 500, 65, 250, 69, 250, 71, 500, 65, 250, 69, 250, 71, 500
NUM_OF_NOTES: .word 9 # O numero de notas na verdade � esse valor dividido por 8, pra facilitar a logica
CURRENT_NOTE_INDEX: .word 0 # O indice sempre ser� o numero que devemos adicionar no endere�o original pra encontrar a nota atual

.text
# Play 
MUSIC_PLAY:
	la t0, NOTES		      	 	# Carrega o endereço inicial das notas
	la t1, CURRENT_NOTE_INDEX  	# Carrega o indice da nota atual
	lw t2, 0(t1) 				# Carrega o valor do indice
	add t0, t0, t2 				# Adiciona o valor do indice no endere�o das notas
	
	lw a0, 0(t0)  	# Carrega a nota atual
	lw a1, 4(t0)  	# Carrega a duracao
	li a2 0 		# Define o intrumento MIDI
	li a3 110 		# Define o volume
	li a7 33 		# Define a chamada para o MIDI
	ecall			# toca a nota
	
	addi t2, t2, 8 	# Incrementar o valor do index
	sw t2, 0(t1) 	# Guardar proximo index no CURRENT_NOTE_INDEX
	
	# Se chegamos no indice final reseta a musica
	la t3, NUM_OF_NOTES # Carrega o endere�o do NUM_OF_NOTES
	lw t3, 0(t3)		    # Substitui o t3 pelo valor no endere�o
	li t5, 8			    # Carrega 8 em t5
	mul t4, t3, t5		    # NUM_OF_NOTES * 8
	
	ble  t2, t4, FIM 		    	       # Se o indice atual for maior do que o NUM_OF_NOTES agt zera o indice
	
	la t0, CURRENT_NOTE_INDEX # Carrega o endere�o do index
	sw zero, 0(t0)			      # Zera o valor
	
FIM:	ret

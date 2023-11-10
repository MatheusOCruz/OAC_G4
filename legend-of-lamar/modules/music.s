.data
# https://ciframelodica.com.br/musicas/zelda-saria-s-song-cancao-de-saria-931/
NOTES: .word 65, 250, 69, 250, 71, 500, 65, 250, 69, 250, 71, 500, 65, 250, 69, 250, 71, 500,
			71, 500
NUM_OF_NOTES: .word 9 			# O numero de notas na verdade é esse valor dividido por 8, pra facilitar a logica
CURRENT_NOTE_INDEX: .word 0 		# O indice sempre será o numero que devemos adicionar no endereço original pra encontrar a nota atual
CURRENT_NOTE_DURATION: .word 250 # A duração da nota atual para ser usada na main

.text
# Play 
MUSIC_PLAY:
	la t0, NOTES		      	 		# Carrega o endereÃ§o inicial das notas
	la t1, CURRENT_NOTE_INDEX  		# Carrega o indice da nota atual
	la t3, CURRENT_NOTE_DURATION 	# Carrega o endereço da duraçao da nota
	lw t2, 0(t1) 					# Carrega o valor do indice
	add t0, t0, t2 					# Adiciona o valor do indice no endereço das notas
	
	lw a0, 0(t0)  	# Carrega a nota atual
	lw a1, 4(t0)  	# Carrega a duracao
	li a2 0 		# Define o intrumento MIDI
	li a3 110 		# Define o volume
	li a7 31 		# Define a chamada para o MIDI
	ecall			# toca a nota
	
	addi t2, t2, 8 	# Incrementar o valor do index
	sw t2, 0(t1) 	# Guardar proximo index no CURRENT_NOTE_INDEX
	sw a1, 0(t3)      # Guarda a duração da nota no CURRENT_NOTE_DURATION
	
	# Se chegamos no indice final reseta a musica
	la t3, NUM_OF_NOTES 		# Carrega o endereço do NUM_OF_NOTES
	lw t3, 0(t3)		    		# Substitui o t3 pelo valor no endereço
	li t5, 8			    		# Carrega 8 em t5
	mul t4, t3, t5		    		# NUM_OF_NOTES * 8
	ble  t2, t4, FIM 		    	       	# Se o indice atual for maior do que o NUM_OF_NOTES agt zera o indice
	
	la t0, CURRENT_NOTE_INDEX 		# Carrega o endereço do index
	la t1, CURRENT_NOTE_DURATION 	# Carrega o endereço da nota atual
	sw zero, 0(t0)			      		# Zera o valor
	sw zero, 0(t1)			      		# Zera o valor
FIM:	ret

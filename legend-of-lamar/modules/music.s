.data
# https://ciframelodica.com.br/musicas/zelda-saria-s-song-cancao-de-saria-931/
NOTES: .word 		65, 300, 69, 300, 71, 500, 								 # F4 A4 B4
			65, 300, 69, 300, 71, 500, 								 # F4 A4 B4
			65, 300, 69, 300, 71, 300, 76, 300, 74, 500, 71, 300, 72, 300, 71, 300, 67, 300, 64, 800 # F4 A4 B4 E5 D5 B4 C5 B4 G4 E4
			62, 300, 64, 300, 67, 300, 64, 800, 							# D4 E4 G4 E4	
			65, 300, 69, 300, 71, 500, 								# F4 A4 B4
			65, 300, 69, 300, 71, 500, 												 # F4 A4 B4
			65, 300, 69, 300, 71, 300,  76, 300, 74, 500, 71, 300, 72, 300, 76, 300, 71, 300, 67, 800, # F4 A4 B4 E5 D5 B4 C5 E5 B4 G4
			71, 300, 67, 300, 62, 300, 64, 800 											 # B4 G4 D4 E4
			
NUM_OF_NOTES: .word 45 			# O numero de notas na verdade e esse valor dividido por 8, pra facilitar a logica
CURRENT_NOTE_INDEX: .word 0 		# O indice sempre sera o numero que devemos adicionar no endereco original pra encontrar a nota atual
CURRENT_NOTE_DURATION: .word 300 # A duracao da nota atual para ser usada na main, inicialmente pode ser a primeira

.text




MUSIC_MANAGER:
	la t0, CURRENT_NOTE_DURATION		# So toca uma nota nova passados o tempo da ultima
	lw t0, 0(t0)						# Carrega o valor da duração da nota
	csrr t1, time 						# Carrega o tempo atual
	sub t1, t1, s9 						# Subtrai o tempo atual do tempo da ultima nota
	ble t1, t0, MUSIC_RET				# Não toca se n passou o tempo ms
	b MUSIC_PLAY					# Toca a nota				


# Play
MUSIC_PLAY:
	la t0, NOTES		      	 		# Carrega o endereco inicial das notas
	la t1, CURRENT_NOTE_INDEX  		# Carrega o indice da nota atual
	la t3, CURRENT_NOTE_DURATION 	# Carrega o endereco da duracao da nota
	lw t2, 0(t1) 					# Carrega o valor do indice
	add t0, t0, t2 					# Adiciona o valor do indice no endereco das notas
	
	lw a0, 0(t0)  	# Carrega a nota atual
	lw a1, 4(t0)  	# Carrega a duracao
	li a2 0 		# Define o intrumento MIDI
	li a3 110 		# Define o volume
	li a7 31 		# Define a chamada para o MIDI
	ecall			# toca a nota
	
	addi t2, t2, 8 	# Incrementar o valor do index
	sw t2, 0(t1) 	# Guardar proximo index no CURRENT_NOTE_INDEX
	sw a1, 0(t3)      # Guarda a dura��o da nota no CURRENT_NOTE_DURATION
	
	# Se chegamos no indice final reseta a musica
	la t3, NUM_OF_NOTES 		# Carrega o endereco do NUM_OF_NOTES
	lw t3, 0(t3)		    		# Substitui o t3 pelo valor no endereco
	li t5, 8			    		# Carrega 8 	    	       
	ble  t2, t4, FIM_MUSIC		    	       	# Se o indice atual for maior do que o NUM_OF_NOTES agt zera o indice
	
	la t0, CURRENT_NOTE_INDEX 		# Carrega o endereco do index
	la t1, CURRENT_NOTE_DURATION 	# Carrega o endereco da nota atual
	la t2, NOTES 			# Carrega o endereço das 
	lw t3, 0(t2)			# Carrega a duração da primeira nota
	sw zero, 0(t0)			      		# Zera o valor
	sw t3, 0(t1)			      		# Carrega a duração da primeira nota
FIM_MUSIC:
	csrr s9, time	

MUSIC_RET:	
	ret

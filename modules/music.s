.data
# FA LA SI 2x
NOTES: .word 65, 250, 69, 250, 71, 500, 65, 250, 69, 250, 71, 500, 65, 250, 69, 250, 71, 500
NUM_OF_NOTES: .word 9
CURRENT_NOTE_ADDRESS: .word 0
CURRENT_NOTE_NUM: .word 0

.text
# Carrega todos os valores necessarios
MUSIC_SETUP:
	la t0, NOTES		      
	la t2, CURRENT_NOTE_ADDRESS  # Carrega o endereco da nota atual
	la t3, CURRENT_NOTE_NUM
	
	li a7 33 		# Define a chamada para o MIDI
	li a2 0 		# Define o intrumento MIDI
	li a3 110 		# Define o volume
	
MUSIC_PLAY:
	lw t4, 0(t2)
	beqz t4, SET_NOTE # Vai pra SET_NOTE se n tiver endereco em CURRENT_NOTE
	
	lw a0, 0(t2)  # Pitch
	lw a1, 4(t2)  # Duracao
	ecall 		   # Toca
	
	lw t5, 0(t3)
	addi t5, t5 , 1 # Incrementar o contador
	addi t4, t2, 8  # Incrementar o endereco da nota e salvar em t4
	
	sw t4, 0(t2) # Guardar proxima nota no CURRENT_NOTE_ADDRESS
	sw t5, 0(t3) # Guardar contador no CURRENT_NOTE_NUM
	
	j END
	
SET_NOTE:
	sw t0, 0(t2)
	la t2, CURRENT_NOTE_ADDRESS
	j MUSIC_PLAY
	
MUSIC_RESET:
	sw zero, 0(t2)
	sw zero, 0(t3)
	
END:

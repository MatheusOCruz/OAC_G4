
.data

.include "tiles/mapa_1_1.data"
x_inicial: .byte 0
y_inicial: .byte 64


.text

#futuramente, o proprio mapa tambem estaria em uma matriz, por enquant so quero printar uma tela

# por enquanto so tem 1 pra teste
# arquivo contem o valor dos tiles q serem printados no mapa

# comeca na linha 64 devido ao hud
# s0 = endereco do tile atual
# a0 = endereco da imagem
# a1 = linha
# a2 = coluna
# sempre 176 tiles no caso nao pq vou ter q mudar a resolucao mas faz parte
MAP_MANAGER:
	add s3,sp,zero
	 # salva oq tinha em s0 na pilha 
	mv a3,s0 # bota o frame em a3 antes de botar s0 na pilha
	addi sp,sp,-8
	sw s0,0(sp)
	sw ra,4(sp)
	la s0, tile_map_mundo_aberto # s0 tem o endereco do tile map (na teoria pq ta dando ruim)
	li a1,0
	mv s6,zero
	li a2,64
	addi s0,s0,8
	
PRINT_MAP_LOOP:
	
	la a0, tiles_mundo_aberto
	# a1 ja e definido
	# a2 ja e definido
	# a3 e fixo
	li a4,16 # tamanho do trem
	lb a6,0(s0) # o tile q vai printar
	call PRINT_SPRITE
	
  	
	addi s0,s0,1
	addi s6,s6,1
			# apos printar o tile
	addi a1,a1,16
	li t0,320
	bne a1,t0,PRINT_MAP_LOOP
			#caso esteja no fim da linha, muda pro comeco da proxima
	addi a2,a2,16
	mv a1, zero
	
	li t0, 240
	blt a2,t0,PRINT_MAP_LOOP
	


RETURN_FROM_PRINT_MAP:
	#tira os valores da pilha, e volta para o game_loop
	addi s4,zero,0xff
	lw s0, 0(sp)
	lw ra, 4(sp)
	addi sp,sp,8
	
	ret
	
	
	
	

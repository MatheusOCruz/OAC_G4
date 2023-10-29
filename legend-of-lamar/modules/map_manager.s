
.data

.include "tiles/tilemap_mundo_aberto.data"
.include "tiles/teste_mapa_tilemap.data"
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
	addi sp,sp,-16
	sw ra,0(sp)
	sw s0,4(sp)
	sw s1,8(sp)
	sw s2,12(sp)
	
	la s0, teste_mapa_tilemap # s0 tem o endereco do tile map (na teoria pq ta dando ruim)
	lw s1, 0(s0)   # largura do mapa inteiro, necessario para pular mudar y do mapa
	
	addi s0,s0,8   # atualiza o endereco do s0 pro primeiro que contem info 
	
	
	la t1, map_localtion # var com a posicao da tela atual 
	lb t2,0(t1)  # x da matriz
	lb t3,1(t1)  # y da matriz
	
	li t4,20      # largura fixa dos mapas
	mul t2,t2,t4  # como a largura do tileset e sempre fixa (a largura da tela) n precisamos ler do arquivo
	add s0,s0,t2  # adiciona ao x no endereco inical do tilemap
	
	li t2,11      # t2 ja foi usado, da pra usar aqui, altura do mapa tmb e fixa = 11 
	mul t3,t3,t2  # quantidade de linhas a ser pulada para cheagar no tile inicial
	
	mul t3,t3,s1  # multiplica a quantidade de linhas pela quantidade de elementos na linha
	add s0,s0,t3  # na teoria com fe s0 tem o inicial
	
	
	li a1,0	     # x inicial do print
	li a2,64     # y inicial do print
	mv s2,zero   # contador de tiles por linha (max = 20)
	
PRINT_MAP_LOOP:
	
	la a0, game_tiles
	# a1 ja e definido
	# a2 ja e definido
	# a3 e fixo
	li a4,16 # tamanho do trem
	lb a6,0(s0) # o tile q vai printar
	
	call PRINT_SPRITE
	
  	
	addi s0,s0,1
	addi s2,s2,1
	li t0, 20
	beq s2,t0,PRINT_MAP_NL
PRINT_MAP_P2:				
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
	lw ra,0(sp)
	lw s0,4(sp)
	lw s1,8(sp)
	lw s2,12(sp)
	addi sp,sp,16
	
	ret
	
	
PRINT_MAP_NL:
	
	add s0,s0,s1
	sub s0,s0,s2  # mesma logica do print tile pra achar primeiro da proxima linha
	mv s2,zero    # reseta contador da linha
	j PRINT_MAP_P2
	

	
# a0 -> 0 se for 
	
	
MAP_TRANSITION_ANIMATION:


	ret
	
	

CAVE_MANAGER:
	














		
				
	

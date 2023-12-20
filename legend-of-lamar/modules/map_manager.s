
.data

.include "../assets/tiles/tilemap_com_dg_temp.data"
.include "../assets/tiles/linel.data"
.include "../assets/tiles/warrior.data"
x_inicial: .byte 0
y_inicial: .byte 64
camera:	   .byte 0,0 #40,22

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
	mv a3,s0 # bota o frame em a3 antes de botar s0 na pilha
	li t0,1

	addi sp,sp,-16
	sw ra,0(sp)
	sw s0,4(sp)
	sw s1,8(sp)
	sw s2,12(sp)
	
	la s0, teste_mapa_tilemap	# s0 tem o endereco do tile map (na teoria pq ta dando ruim)
	lw s1, 0(s0)   			# largura do mapa inteiro, necessario para pular mudar y do mapa
	
	addi s0,s0,8  			# atualiza o endereco do s0 pro primeiro que contem info 
	
	la t0, camera
	lb t1,0(t0)	#x
	lb t2,1(t0)	#y
	add s0,s0,t1
	mul t2,t2,s1
	add s0,s0,t2
	
	
	li a1,0	     # x inicial do print
	li a2,64     # y inicial do print
	mv s2,zero   # contador de tiles por linha (max = 20)
	
	

	
	
END_PREP_MAP:	
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
	


	
# a0 = 0 se for pra baixo(esquerda) , 1 se for pra cima(direita)  y
# a1 dps vai indicar a direcao 0 pra vertical e 1 pra horizontal
# tempo de frame = 17ms


MAP_TRANSITION:

	
	mv a3,s0 # bota o frame em a3 antes de botar s0 na pilha
	li t0,1

	addi sp,sp,-28
	sw ra,0(sp)
	sw s0,4(sp)
	sw s1,8(sp)
	sw s2,12(sp)
	sw s3,16(sp)
	sw s4,20(sp)
	sw s5,24(sp)
	mv s4,a0	
	mv s5,a1
	
	la s0, teste_mapa_tilemap 	# s0 tem o endereco do tile map (na teoria pq ta dando ruim)
	lw s1, 0(s0)   			# largura do mapa inteiro, necessario para pular mudar y do mapa
	
	addi s0,s0,8  			# atualiza o endereco do s0 pro primeiro que contem info 
	
	la t0, camera
	lb t1,0(t0)	#x
	lb t2,1(t0)	#y
	add s0,s0,t1
	mul t2,t2,s1
	add s0,s0,t2
	
	
	li a1,0	    	# x inicial do print
	li a2,64    	# y inicial do print
	mv s2,zero   	# contador de tiles por linha (max = 20)
	
	li s3,0 	# contador de frame
	
	
MAP_TRANSITION_VERTICAL_PRINT:
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
	beq s2,t0,PRINT_MAP_TRANSITION_VERTICAL_NL
	
MAP_TRANSITION_VERTICAL_PRINT_P2:				
	addi a1,a1,16
	li t0,320
	bne a1,t0,MAP_TRANSITION_VERTICAL_PRINT
			#caso esteja no fim da linha, muda pro comeco da proxima
	addi a2,a2,16
	mv a1, zero
	
	li t0, 240
	blt a2,t0,MAP_TRANSITION_VERTICAL_PRINT
	


MAP_TRANSITION_VERTICAL_NEXT_RET:
	addi s3,s3,1
	
	#tira os valores da pilha, e volta para o game_loop
	la s0, teste_mapa_tilemap	# s0 tem o endereco do tile map (na teoria pq ta dando ruim)
	lw s1, 0(s0)   			# largura do mapa inteiro, necessario para pular mudar y do mapa
	addi s0,s0,8 
	
	la t0, camera
	lb t1,0(t0)	#x
	lb t2,1(t0)	#y
	
	beq s5,zero,transicao_vertical
	# horizontal
	li t3,20
	beq s4,zero,transicao_esquerda
	add t1,t1,s3
	b proximo
transicao_esquerda:
	sub t1,t1,s3
	b proximo
transicao_vertical:
	li t3,11
	beq s4,zero,transicao_baixo
	sub t2,t2,s3
	b proximo
transicao_baixo:
	add t2,t2,s3
proximo:	
	add s0,s0,t1
	mul t2,t2,s1
	add s0,s0,t2
	
	li a0 100
	li a7,32
	ecall
	li a1,0	    	# x inicial do print
	li a2,64    	# y inicial do print
	mv s2,zero   	# contador de tiles por linha (max = 20)
	
	blt s3,t3,MAP_TRANSITION_VERTICAL_PRINT
	mv a0,s3
	li a7,1
	ecall
	# pra proxima loc
	la t0, camera # camera ja ta em t0
	lb t1,0(t0)	#x
	lb t2,1(t0)	#y
	
	beq s5,zero,poxima_loc_vertical
	
	beq s4,zero,proxima_loc_esquerda
	
	add t1,t1,s3
	sb t1,0(t0)
	b transicao_fim_ret

proxima_loc_esquerda:
	sub t1,t1,s3
	sb t1,0(t0)
	B transicao_fim_ret
	
poxima_loc_vertical:
	beq s4,zero proxima_loc_baixo
	sub t2,t2,s3
	sb t2,1(t0)
	b transicao_fim_ret

proxima_loc_baixo:
	add t2,t2,s3
	sb t2,1(t0)
transicao_fim_ret:	
	
	lw ra,0(sp)
	lw s0,4(sp)
	lw s1,8(sp)
	lw s2,12(sp)
	lw s3,16(sp)
	lw s4,20(sp)
	lw s5,24(sp)
	addi sp,sp,28

	ret

	

PRINT_MAP_TRANSITION_VERTICAL_NL:
	
	add s0,s0,s1
	sub s0,s0,s2  # mesma logica do print tile pra achar primeiro da proxima linha
	mv s2,zero    # reseta contador da linha
	j MAP_TRANSITION_VERTICAL_PRINT_P2
	





		
	

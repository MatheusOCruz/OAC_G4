.text

GET_INPUT_MENU:	
 	li t1,0xFF200000		# carrega o endere?o de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,NO_INPUT   		# Se n?o h? tecla pressionada ent?o vai para FIM
   	sw zero,0(t1)
  	j START_TEXT	
  		

GET_INPUT:	
	la t0,map_location  		#em qual dos mapas o link ta
	lb t1,0(t0)			#x
	lb t2,1(t0)			#y
	li t3,20			#tamanho x de uma tela
	mul t3,t1,t3			#tamanho da tela vezes numero de telas
	li t4,660			#tamanho y da tela
	mul t4,t2,t4			#tamanho em y vezes o numero de telas
	add a1,t3,t4			#posição do link no mapa geral					
	
 	li t1,0xFF200000		# carrega o endere?o de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001 		# mascara o bit menos significativo
   	beq t0,zero,NO_INPUT   	   	# Se n?o h? tecla pressionada ent?o vai para FIM
  	lw t2,4(t1)			# le o valor da tecla tecla
  	li t0,'w'
  	beq t2,t0,MV_UP
	li t0,'a'
	beq t2,t0,MV_LEFT
	li t0,'s'
	beq t0,t2,MV_DOWN_START
	li t0,'d'
	beq t2,t0,MV_RIGHT
			
NO_INPUT:
		
	ret

MV_UP:	
	
	
	la t0,link_pos
	la t3,teste_mapa_tilemap
	addi t3,t3,8 #pegando a matriz da tela e pulando os dados
	
	lh t1,2(t0) # eixo y
	lh t2,0(t0) #eixo x
	
	srli t5,t1,4	#ind�ce na matriz em y
	srli t2,t2,4	#ind�ce na matriz em x
	addi t5,t5,-5
	li t4,60        #calculando a posi��o do quadrado de cima do boneco
	mul t6,t5,t4
	add t3,t3,t6
	add t3,t3,t2
	add t3,t3,a1
	
	li t4,-1
	beq t5,t4,TELA_UP   # t5 = -1 e pq passou do limite da tela, troca de mapa 
	
	lb t4,0(t3)	     #pega o valor do quadrado
	li t5,4
	beq t4,t5,ENTRA_SAI_CAVERNOSA
	bne t4,zero,NO_INPUT #se o quadrado n�o for vazio, ignora o input
	
	addi t1,t1,-16 
	la t0,link_pos
	sh t1,2(t0)
	
ANIM_UP:	# para animacao
	la t0, link_sprite_num  # sprite atual 
	lb t3,0(t0)             # pega o sprite atual
	li t2,4	   	        # 1 srite pra cima
	beq t3,t2,ANIM_2   # se forem igual ele ja estava indo para cima
	sb t2,0(t0) 	
	
	ret
	
TELA_UP:
	la t0,link_pos
	li t2, 224		# move boneco para parte de baixo 
	sh t2, 2(t0)
	li a0,-1
	addi sp,sp,-4
	sw ra,0(sp)
	li a0,1
	li a1,0
	call MAP_TRANSITION
	lw ra,0(sp)
	addi sp,sp,4
	la t0,map_location
	lb t1,1(t0)
	addi t1,t1,-1
	sb t1,1(t0)
	ret
	
	

	
	

	
MV_LEFT:
	la t0,link_pos
	la t3,teste_mapa_tilemap
	addi t3,t3,8 #pegando a matriz da dela e pulando os dados
	
	lh t1,2(t0) # eixo y
	lh t2,0(t0) #eixo x
	
	srli t1,t1,4	#ind�ce na matriz em y
	srli t5,t2,4	#ind�ce na matriz em x
	addi t1,t1,-4
	li t4,60      #calculando a posi��o do quadrado da esquerda do boneco
	mul t1,t1,t4
	add t3,t3,t1
	add t3,t3,t5
	addi t3,t3,-1
	add t3,t3,a1
	
	beq t5,zero,TELA_LEFT
	
	lb t3,(t3)	     #pega o valor do quadrado
	bne t3,zero,NO_INPUT #se o quadrado n�o for vazio, ignora o input
	
	addi t2,t2,-16
	sh t2,0(t0)

ANIM_LEFT:
 	la t0, link_sprite_num
	lb t1,0(t0)
	li t2,6
	beq t1,t2,ANIM_2
	sb t2,0(t0) 
 
	ret
	
TELA_LEFT: 
	la t0, link_pos
	li t2, 304		# move boneco para parte de baixo 
	sh t2, 0(t0)
	addi sp,sp,-4
	sw ra,0(sp)
	li a0,0
	li a1,1
	call MAP_TRANSITION
	lw ra,0(sp)
	addi sp,sp,4
	la t0,map_location
	lb t1,0(t0)
	addi t1,t1,-1
	sb t1,0(t0)
	ret
	

MV_DOWN_START:
	la t0,link_pos
	
	bne s1,zero,MV_DOWN_CAVE_PREP
	
	# depois essa conta pode ser reutilizada pra dungeon
	la t3,teste_mapa_tilemap
	
	b MV_DOWN
MV_DOWN_CAVE_PREP:
	li a0,10
	li a7,1
	ecall	
	la t3, secreta

MV_DOWN:
	addi t3,t3,8 #pegando a matriz da dela e pulando os dados
	
	lh t2,0(t0) #eixo X
	lh t1,2(t0) # eixo Y
	
	srli t5,t1,4	#ind�ce na matriz em y
	srli t2,t2,4	#ind�ce na matriz em x
	addi t5,t5,-3
	li t4,60      #calculando a posi��o do quadrado de baixo do boneco
	mul t6,t5,t4
	add t3,t3,t6
	add t3,t3,t2
	add t3,t3,a1
	
	li t4, 11
	beq t4,t5,TELA_DOWN
	
# t3 deve conter o endereco do trem
	
	lb t3,(t3)	     #pega o valor do quadrado
	li t5,6
	mv a0,t3
	li a7,1
	ecall
	beq t3,t5,ENTRA_SAI_CAVERNOSA
	bne t3,zero,NO_INPUT #se o quadrado n�o for vazio, ignora o input
	
	addi t1,t1,16
	sh t1,2(t0)

 	
	
	
ANIM_DOWN:
	la t0, link_sprite_num
	lb t1,0(t0)
	mv t2,zero
	beq t1,t2,ANIM_2
	sb t2,0(t0)
	ret
	
TELA_DOWN:
	la t0, link_pos
	li t2, 64		# move boneco para parte de baixo 
	sh t2, 2(t0)
	li a0,-1
	addi sp,sp,-4
	sw ra,0(sp)
	li a0,0
	li a1,0
	call MAP_TRANSITION
	lw ra,0(sp)
	addi sp,sp,4
	la t0,map_location
	lb t1,1(t0)
	addi t1,t1,1
	sb t1,1(t0)
	ret

MV_RIGHT:
	la t0,link_pos
	la t3,teste_mapa_tilemap
	addi t3,t3,8 #pegando a matriz da dela e pulando os dados
	
	lh t1,2(t0) # eixo Y
	lh t2,0(t0) #eixo x
	
	srli t1,t1,4    #ind�ce na matriz em y
	srli t5,t2,4	#ind�ce na matriz em x
	addi t1,t1,-4
	li t4,60      
	mul t1,t1,t4
	add t3,t3,t1
	add t3,t3,t5
	addi t3,t3,1  #calculando a posi��o do quadrado da direita do boneco
	add t3,t3,a1

	li t4,19
	beq t5,t4,TELA_RIGHT
	
	lb t3,(t3)	     #pega o valor do quadrado
	bne t3,zero,NO_INPUT #se o quadrado n�o for vazio, ignora o input
	
	addi t2,t2,16
	sh t2,0(t0)

 	


ANIM_RIGHT:
 	la t0, link_sprite_num
	lb t1,0(t0)
	li t2,2
	beq t1,t2,ANIM_2
	sb t2,0(t0) 
 	
	ret
	
TELA_RIGHT: 

	la t0, link_pos
	li t2, 0		# move boneco para parte de baixo 
	sh t2, 0(t0)
	addi sp,sp,-4
	sw ra,0(sp)
	li a0,1
	li a1,1
	call MAP_TRANSITION
	lw ra,0(sp)
	addi sp,sp,4
	la t0,map_location
	lb t1,0(t0)
	addi t1,t1,1
	sb t1,0(t0)
	ret
	
	
ANIM_2:
	addi t2,t2,1
	sb t2,0(t0)
	ret
	
ENTRA_SAI_CAVERNOSA:
	# primeira caverna ta no 2,2
	
	li t0,1
	beq s1,t0,SAI_CAVERNA
	li s1,1				# como n tem dungeon ainda, tem q estar em uma caverna so n sabe qual ainda
	
	la t0, map_location
	lb t1,0(t0)
	li t2,2
	bne t1,t2,CAVERONSA_TESTE_2
	
	lb t1,2(t0)
	bne t1,t2,CAVERONSA_TESTE_2
					# no caso tem q fazer alguma coisa pra diferenciar as cavernas ainda 
					# aqui estaria na da tela 2,2
	ret
	
CAVERONSA_TESTE_2:
	ret
	
SAI_CAVERNA:
	li s1,0
	ret
	
	


	
	

.text

GET_INPUT_MENU:	
 	li t1,0xFF200000		# carrega o endere?o de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,NO_INPUT   		# Se n?o h? tecla pressionada ent?o vai para FIM
   	sw zero,0(t1)
  	j START_TEXT	
  		

GET_INPUT:	
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
	beq t0,t2,MV_DOWN
	li t0,'d'
	beq t2,t0,MV_RIGHT
			
NO_INPUT:
		
	ret

MV_UP:	
	la t3,teste_mapa_tilemap
	addi t3,t3,8 #pegando a matriz da dela e pulando os dados
	
	la t1,general_pos
	lh t2,0(t1) #y
	addi t2,t2,-1
	lh t4,2(t1) #x
	li t5,60
	mul t6,t2,t5
	add t3,t3,t6
	add t3,t3,t4
	lb t3,(t3)
	bne t3,zero,NO_INPUT
	
	sh t2,0(t1)
	
	la t0,link_pos
	
	lh t1,2(t0) # eixo y
	lh t2,0(t0) #eixo x
	
	li t4,64
	beq t1,t4,TELA_UP
	
	addi t1,t1,-16
	sh t1,2(t0)
	li t1,1
	
	
ANIM_UP:	# para animacao
	la t0, link_sprite_num  # sprite atual 
	lb t3,0(t0)             # pega o sprite atual
	li t2,4	   	        # 1 srite pra cima
	beq t3,t2,ANIM_2   # se forem igual ele ja estava indo para cima
	sb t2,0(t0) 	
	
	ret
	
TELA_UP:	
	
	la t2, map_localtion    # pos da matrix de tiles
	lb t3,1(t2)		# eixo y da matriz
	addi t3,t3,-1		# sobe uma tela da matrix
	sb t3,1(t2)
	li t2, 224		# move boneco para parte de baixo 
	sh t2, 2(t0)
	b ANIM_UP
	
	

	
MV_LEFT:
	la t3,teste_mapa_tilemap
	addi t3,t3,8 #pegando a matriz da dela e pulando os dados
	
	la t1,general_pos
	lh t2,0(t1) #y
	lh t4,2(t1) #x
	addi t4,t4,-1
	li t5,60
	mul t6,t2,t5
	add t3,t3,t6
	add t3,t3,t4
	lb t3,(t3)
	bne t3,zero,NO_INPUT
	
	sh t4,2(t1)
	
	la t0,link_pos
	
	lh t1,2(t0) # eixo y
	lh t2,0(t0) #eixo x
	
	beq t2,zero,TELA_LEFT
	
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

	
	la t2, map_localtion    # pos da matrix de tiles
	lb t3,0(t2)		# eixo y da matriz
	addi t3,t3,-1		# sobe uma tela da matrix
	sb t3,0(t2)
	li t2, 304		# move boneco para canto direito
	sh t2, 0(t0)
	b ANIM_LEFT
	

MV_DOWN:
	la t3,teste_mapa_tilemap
	addi t3,t3,8 #pegando a matriz da dela e pulando os dados
	
	la t1,general_pos
	lh t2,0(t1) #y
	addi t2,t2,1
	lh t4,2(t1) #x
	li t5,60
	mul t6,t2,t5
	add t3,t3,t6
	add t3,t3,t4
	lb t3,(t3)
	bne t3,zero,NO_INPUT
	
	sh t2,0(t1)
	
	la t0,link_pos
	
	lh t1,2(t0) # eixo y
	lh t2,0(t0) #eixo x
	
	li t4,224
	beq t1,t4,TELA_DOWN
	
	addi t1,t1,16 
	sh t1,2(t0)
	li t1,1

ANIM_DOWN:
	la t0, link_sprite_num
	lb t1,0(t0)
	mv t2,zero
	beq t1,t2,ANIM_2
	sb t2,0(t0)
	ret
	
TELA_DOWN:
	la t2, map_localtion
	lb t3,1(t2)
	addi t3,t3,1
	sb t3,1(t2)
	li t2, 64
	sh t2, 2(t0)
	b ANIM_DOWN

MV_RIGHT:
	la t3,teste_mapa_tilemap
	addi t3,t3,8 #pegando a matriz da dela e pulando os dados
	
	la t1,general_pos
	lh t2,0(t1) #y
	lh t4,2(t1) #x
	addi t4,t4,1
	li t5,60
	mul t6,t2,t5
	add t3,t3,t6
	add t3,t3,t4
	lb t3,(t3)
	bne t3,zero,NO_INPUT
	
	sh t4,2(t1)
	
	la t0,link_pos
	
	lh t1,2(t0) #eixo y
	lh t2,0(t0) #eixo x
	
	li t6,304
	beq t2,t6,TELA_RIGHT
	
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
	
	la t2, map_localtion    # pos da matrix de tiles
	lb t3,0(t2)		# eixo y da matriz
	addi t3,t3,1		# sobe uma tela da matrix
	sb t3,0(t2)		# move boneco para canto direito
	sh zero, 0(t0)		# joga o boneco pro canto da direita
	b ANIM_RIGHT
	
	
ANIM_2:
	addi t2,t2,1
	sb t2,0(t0)
	ret
	
	

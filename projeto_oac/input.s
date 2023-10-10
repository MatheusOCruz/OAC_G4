.text

GET_INPUT_MENU:	
 	li t1,0xFF200000		# carrega o endere�o de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,NO_INPUT   		# Se n�o h� tecla pressionada ent�o vai para FIM
   	sw zero,0(t1)
  	j START_TEXT	
  		

GET_INPUT:	
 	li t1,0xFF200000		# carrega o endere�o de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001 		# mascara o bit menos significativo
   	beq t0,zero,NO_INPUT   	   	# Se n�o h� tecla pressionada ent�o vai para FIM
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
	la t0,link_pos
	la t3,tile_map_mundo_aberto
	addi t3,t3,8 #pegando a matriz da dela e pulando os dados
	
	lh t1,2(t0) # eixo Y
	lh t2,0(t0) #eixo x
	
	srli t5,t1,4	#indíce na matriz em y
	srli t2,t2,4	#indíce na matriz em x
	addi t5,t5,-5 
	li t4,20      #calculando a posição do quadrado de cima do boneco
	mul t5,t5,t4
	add t3,t3,t5
	add t3,t3,t2
	
	lb t3,(t3)	     #pega o valor do quadrado
	bne t3,zero,NO_INPUT #se o quadrado não for vazio, ignora o input
	
	addi t1,t1,-16
	sh t1,2(t0)
	# para animacao
	la t0, link_sprite_num
	lb t1,0(t0)
	li t2,4
	beq t1,t2,ANIM_2
	sb t2,0(t0) 
	
	ret
	
MV_LEFT:
	la t0,link_pos
	la t3,tile_map_mundo_aberto
	addi t3,t3,8 #pegando a matriz da dela e pulando os dados
	
	lh t1,2(t0) # eixo Y
	lh t2,0(t0) #eixo x
	
	srli t1,t1,4	#indíce na matriz em y
	srli t5,t2,4	#indíce na matriz em x
	addi t1,t1,-4
	li t4,20      #calculando a posição do quadrado da esquerda do boneco
	mul t1,t1,t4
	add t3,t3,t1
	add t3,t3,t5
	addi t3,t3,-1
	
	lb t3,(t3)	     #pega o valor do quadrado
	bne t3,zero,NO_INPUT #se o quadrado não for vazio, ignora o input
	
	addi t2,t2,-16
	sh t2,0(t0)


 	la t0, link_sprite_num
	lb t1,0(t0)
	li t2,6
	beq t1,t2,ANIM_2
	sb t2,0(t0) 
 
	ret

MV_DOWN:
	la t0,link_pos
	la t3,tile_map_mundo_aberto
	addi t3,t3,8 #pegando a matriz da dela e pulando os dados
	
	lh t1,2(t0) # eixo Y
	lh t2,0(t0) #eixo x
	
	srli t5,t1,4	#indíce na matriz em y
	srli t2,t2,4	#indíce na matriz em x
	addi t5,t5,-3
	li t4,20      #calculando a posição do quadrado de baixo do boneco
	mul t5,t5,t4
	add t3,t3,t5
	add t3,t3,t2
	
	lb t3,(t3)	     #pega o valor do quadrado
	bne t3,zero,NO_INPUT #se o quadrado não for vazio, ignora o input
	
	addi t1,t1,16
	sh t1,2(t0)

 	la t0, link_sprite_num
	lb t1,0(t0)
	mv t2,zero
	beq t1,t2,ANIM_2
	sb t2,0(t0)
	
	ret

MV_RIGHT:
	la t0,link_pos
	la t3,tile_map_mundo_aberto
	addi t3,t3,8 #pegando a matriz da dela e pulando os dados
	
	lh t1,2(t0) # eixo Y
	lh t2,0(t0) #eixo x
	
	srli t1,t1,4    #indíce na matriz em y
	srli t5,t2,4	#indíce na matriz em x
	addi t1,t1,-4
	li t4,20      
	mul t1,t1,t4
	add t3,t3,t1
	add t3,t3,t5
	addi t3,t3,1  #calculando a posição do quadrado da direita do boneco
	
	lb t3,(t3)	     #pega o valor do quadrado
	bne t3,zero,NO_INPUT #se o quadrado não for vazio, ignora o input
	
	addi t2,t2,16
	sh t2,0(t0)

 	la t0, link_sprite_num
	lb t1,0(t0)
	li t2,2
	beq t1,t2,ANIM_2
	sb t2,0(t0) 
 	
	ret
 ANIM_2:
	addi t2,t2,1
	sb t2,0(t0)
	ret

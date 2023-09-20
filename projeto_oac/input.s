.text

GET_INPUT_MENU:	
 	li t1,0xFF200000		# carrega o endereço de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,NO_INPUT   		# Se não há tecla pressionada então vai para FIM
   	sw zero,0(t1)
  	j START_TEXT	
  		

GET_INPUT:	
 	li t1,0xFF200000		# carrega o endereço de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001 		# mascara o bit menos significativo
   	beq t0,zero,NO_INPUT   	   	# Se não há tecla pressionada então vai para FIM
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
	lh t1,2(t0) # eixo Y
	addi t1,t1,-16
	sh t1,2(t0)
	
	ret
	
MV_LEFT:
	la t0,link_pos
	lh t1,0(t0) # eixo X
	addi t1,t1,-16
	sh t1,0(t0)
	ret

MV_DOWN:
	la t0,link_pos
	lh t1,2(t0) # eixo Y
	addi t1,t1,16
	sh t1,2(t0)
	ret

MV_RIGHT:
	la t0,link_pos
	lh t1,0(t0) # eixo X
	addi t1,t1,16
	sh t1,0(t0)
	ret
.text

GET_INPUT_MENU:	
 	li t1,0xFF200000		# carrega o endere?o de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,NO_INPUT   		# Se n?o h? tecla pressionada ent?o vai para FIM
   	sw zero,0(t1)
  	j GAME_PREP	
  		

GET_INPUT:	
	la t0,atacando
	lb t0,0(t0)
	bne t0,zero, NO_INPUT
 	li t1,0xFF200000		# carrega o endere?o de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001 		# mascara o bit menos significativo
   	beq t0,zero,NO_INPUT   	   	# Se n?o h? tecla pressionada ent?o vai para FIM
  	lw t2,4(t1)			# le o valor da tecla tecla
  	li t0,'w'
  	beq t2,t0,MV_UP
	li t0,'a'
	beq t2,t0,MV_LEFT
	li t0,'x'
	beq t2,t0,ATACK_1
	
	tail GET_INPUT_PART_2
	

	
NO_INPUT:
	ret


ATACK_1:
	la t0, arma_a
	lb s6, 0(t0)
	la t0, atacando
	li t1,1
	sb t1,0(t0)
	ret
	
MV_UP:	
	addi sp,sp,-4
	sw ra,0(sp)
	# direcao do ataque
	la t0, atacando
	li t1, 0
	sb t1,1(t0)
	li a5,0
	
	call CHECK_COLISAO
	
	call ITEM
	
	lw ra,0(sp)
	addi sp,sp,4
	
	li t4,0
	beq a0,t4,TELA_UP   # t5 = -1 e pq passou do limite da tela, troca de mapa 

	bgt a4,zero,NO_INPUT
	
	addi a2,a2,-16
	la t0,link_pos
	lh t1,2(t0)
	addi t1,t1,-8
	sh t1,2(t0)
	

	la t0,pos_offset
	lb t1,0(t0)
	addi t1,t1,8
	andi t1,t1,8
	sb t1,0(t0)
	
	
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
	addi sp,sp,-4
	sw ra,0(sp)
	#direcao do ataque
	la t0, atacando
	li t1, 2
	sb t1,1(t0)
	
	li a5,2
	call CHECK_COLISAO
	
	call ITEM
	
	lw ra,0(sp)
	addi sp,sp,4
	
	beq a6,zero,TELA_LEFT
	bgt a4,zero,NO_INPUT
	
	addi a3,a3,-16 
	la t0,link_pos
	lh t1,0(t0)
	addi t1,t1,-8
	sh t1,0(t0)
	
	la t0,pos_offset
	lb t1,1(t0)
	addi t1,t1,8
	andi t1,t1,8
	sb t1,1(t0)

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

GET_INPUT_PART_2:		
	li t0,'s'
	beq t0,t2,MV_DOWN
	li t0,'d'
	beq t2,t0,MV_RIGHT
	li t0,'c'
	beq t0,t2,BEBE_CAFE
	li t0,'t'
	beq t0,t2,TESTE	
	ret

MV_DOWN:
	addi sp,sp,-4
	sw ra,0(sp)
	#direcao do ataque
	la t0, atacando
	li t1, 1
	sb t1,1(t0)

	li a5,1
	call CHECK_COLISAO
	
	call ITEM
	
	lw ra,0(sp)
	addi sp,sp,4
	

	li t4,10
	beq a0,t4,TELA_DOWN   # t5 = -1 e pq passou do limite da tela, troca de mapa 
	

	bgt a4,zero,NO_INPUT
	
	addi a2,a2,16 
	la t0,link_pos
	lh t1,2(t0)
	addi t1,t1,8
	sh t1,2(t0)
 	
 	la t0,pos_offset
	lb t1,0(t0)
	addi t1,t1,8
	andi t1,t1,8
	sb t1,0(t0)
	
	
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
	addi sp,sp,-4
	sw ra,0(sp)
	#direcao do ataque
	la t0, atacando
	li t1, 3
	sb t1,1(t0)
	
	li a5,3
	call CHECK_COLISAO
	
	call ITEM
	
	lw ra,0(sp)
	addi sp,sp,4
	
	li t0,19
	beq a6,t0,TELA_RIGHT

	bgt a4,zero,NO_INPUT
	
	addi a3,a3,16 
	la t0,link_pos
	lh t1,0(t0)
	addi t1,t1,8
	sh t1,0(t0)
	
	la t0,pos_offset
	lb t1,1(t0)
	addi t1,t1,8
	andi t1,t1,8
	sb t1,1(t0)


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
	
BEBE_CAFE:
	la t0, link_vida
	lb t3,0(t0)	
	mv a0,t3
	li a7,1
	ecall
	li t1, 8	#vida cheia
	beq t3, t1, NAO_BEBE_CAFE
	la t2, link_cafezin
	lh t4,0(t2)	# ta sem cafe coitado
	mv a0,t4
	ecall
	beq t4, zero, NAO_BEBE_CAFE
	
	addi t3,t3,1
	addi t4,t4,-1
	sb t3, 0(t0)	# vida nova do homem
	sh t4, 0(t2)	# reduz o cafezin

NAO_BEBE_CAFE:	
	ret

TESTE:
	la t0, link_vida
	lb t3,0(t0)	
	addi t3,t3,-1
	sb t3,0(t0)
	ret
















	

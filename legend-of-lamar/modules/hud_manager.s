.data 
.include "../assets/tiles/vida.data"
.include "../assets/tiles/items_temp.data"



pos_vida: .half 224,36 # (x,y)
pos_moedas: .half 136,20 # (x,y)
pos_cafe: .half 136,44 # (x,y)


pos_arma_a: .half 188,28
pos_arma_b: .half 164,28

.text
# s3 = vida
# a6 = 0 full a6 = 1, half a6 = 2 vazi
		

# 128,20 moeda
HUD_MANAGER:
CLEAR_HUD:#essa parte printa 3 quadrados pretos por cima do numero de moedas/cafe pq se nao fica bugado
	addi sp,sp,-4
	sw ra,0(sp)
	
	la a0,game_tiles	
	li a1,136
	li a2,16
	mv a3,s0
	li a4,16
	li a5,16
	li a6,6
	call PRINT_SPRITE
	
	la a0,game_tiles
	li a2,32
	li a4,16
	li a6,6
	call PRINT_SPRITE
	
	la a0,game_tiles
	li a2,48
	li a4,16
	li a6,6
	call PRINT_SPRITE
	
	lw ra,0(sp)
	addi sp,sp,4
	
	
PRINT_VIDA:
	mv a3,s0
	
	addi sp,sp,-12
	sw ra,0(sp)
	sw s0,4(sp)
	sw s1,8(sp)
	
	la t0,link_vida
	lb s1,0(t0)		# int da vida
	
	la t0,pos_vida		# endereco do primeiro coracao
	lh a1,0(t0) 		# X
	lh a2,2(t0)		# Y
	
	la a0,vida		# sprite da vida
	
	li s0,4
	li a4,16
	
	
PRINT_VIDA_LOOP:
	
	li t1,2
	li a6,0
	bge s1,t1,VIDA_LOOP_2 	# vida cheia
	addi a6,a6,1		# endereco meio coracao
	li t1,1
	bge s1,t1,VIDA_LOOP_2
	addi a6,a6,1		# endereco coracao vazio

VIDA_LOOP_2:
	
	call PRINT_SPRITE
	addi s0,s0,-1
	addi s1,s1,-2
	addi a1,a1,16
	bne s0,zero,PRINT_VIDA_LOOP
	
	
	# pra printar os trem no frame certo esse ja volta
	lw s0,4(sp)	
	
	
	
	
	
	
# limite para display e 999, mas pode ter mais 
PRINT_DINDIN:

	la t0,link_moedas
	lhu a0,0(t0)
	li t0,999
	#blt a0,t0,PRINT_DINDIN_2
	#li a0,999  
	# tem mais de 999 moedas, mas para o display em 999
PRINT_DINDIN_2:
	la t0,pos_moedas
	lh a1,0(t0)
	lh a2,2(t0)
	li a3,255
	mv a4,s0
	li a7,101
	ecall
	
PRINT_CAFE:

	la t0,link_cafezin
	lhu a0,0(t0)
	li t0,999
	blt a0,t0,PRINT_CAFE_2
	li a0,999  
	# tem mais de 999 moedas, mas para o display em 999
PRINT_CAFE_2:
	la t0,pos_cafe
	lh a1,0(t0)
	lh a2,2(t0)
	li a3,255
	mv a4,s0
	li a7,101
	ecall
	

	
	
# falta as 2 arminhas 



# id da arma -1 -> deslocamento pra leitura no arquivo
PRINT_ARMA_l:
	la t0, arma_a
	lb t0,0(t0)
	beq t0,zero, PRINT_ARMA_2
	addi t0,t0,-1
	la t1,pos_arma_a
	la a0, items_temp
	lh a1,0(t1)
	lh a2,2(t1)
	mv a3,s0
	li a4,16
	mv a6,t0
	
	call PRINT_SPRITE
	
	

PRINT_ARMA_2:
	la t0, arma_b
	lb t0,0(t0)
	beq t0,zero, HUD_MANAGER_RET	
	
	addi t0,t0,-1
	la t1,pos_arma_b
	la a0, items_temp
	lh a1,0(t1)
	lh a2,2(t1)
	mv a3,s0
	li a4,16
	mv a6,t0
	
	call PRINT_SPRITE




HUD_MANAGER_RET:
	lw ra,0(sp)
	# lw s0 ja rolou la em cima 
	lw s1,8(sp)
	addi sp,sp,12
	ret












# 	TODO
#	printa tudo preto onde ficam os contadores
# 	chama antes de printar contadores 
#	caso ele diminua a quantidade de digitos vai ficar residuo
LIMPA_ESPACO_HUD:
	
	
	
	
	
	
	
	
	

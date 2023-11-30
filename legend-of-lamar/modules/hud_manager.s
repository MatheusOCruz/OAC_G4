.data 

.include "../assets/tiles/vida.data"

pos_vida  : .half 224,36 # (x,y)
pos_moedas: .half 136,20 # (x,y)
pos_chaves: .half 136,36 # (x,y)
pos_bombas: .half 136,44 # (x,y)


.text
# s3 = vida
# a6 = 0 full a6 = 1, half a6 = 2 vazi


# 128,20 moeda
HUD_MANAGER:

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
	
	
	lw ra,0(sp)
	lw s0,4(sp)
	lw s1,8(sp)
	addi sp,sp,12
	
	
	
	
# limite para display e 999, mas pode ter mais 
PRINT_DINDIN:

	la t0,link_moedas
	lhu a0,0(t0)
	li t0,999
	blt a0,t0,PRINT_DINDIN_2
	li a0,999  
	# tem mais de 999 moedas, mas para o display em 999
PRINT_DINDIN_2:
	la t0,pos_moedas
	lh a1,0(t0)
	lh a2,2(t0)
	li a3,255
	mv a4,s0
	li a7,101
	ecall
	
PRINT_CHAVES:

	la t0,link_chaves
	lhu a0,0(t0)
	li t0,999
	blt a0,t0,PRINT_CHAVES_2
	li a0,999  
	# tem mais de 999 moedas, mas para o display em 999
PRINT_CHAVES_2:
	la t0,pos_chaves
	lh a1,0(t0)
	lh a2,2(t0)
	li a3,255
	mv a4,s0
	li a7,101
	ecall
	
PRINT_BOMBAS:

	la t0,link_bombas
	lh a0,0(t0)
	li t0,999
	blt a0,t0,PRINT_BOMBAS_2
	li a0,999  
	# tem mais de 999 moedas, mas para o display em 999
PRINT_BOMBAS_2:
	la t0,pos_bombas
	lh a1,0(t0)
	lh a2,2(t0)
	li a3,255
	mv a4,s0
	li a7,101
	ecall
	
	
# falta as 2 arminhas 

PRINT_ARMASl:
	
	
	ret
	
	
	
	
	
	
	
	
	
	
	
	

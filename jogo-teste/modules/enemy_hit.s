.text
CHECK_ENEMY_HIT:
	addi sp,sp,-44
	sw t0,0(sp)
	sw t1,4(sp)
	sw t2,8(sp)
	sw t3,12(sp)
	sw t4,16(sp)
	sw t5,20(sp)
	sw t6,24(sp)
	sw s10,28(sp)
	sw s0,32(sp)
	sw s1,36(sp)
	sw s2,40(sp)
	
	li s2,0
	la t0,atacando
	lb t1,0(t0)
	lb t2,1(t0)
	
	beq t2,zero,CHECK_ATACK_CIMA
	addi t2,t2,-1
	beq t2,zero,CHECK_ATACK_BAIX
	addi t2,t2,-1
	beq t2,zero,CHECK_ATACK_ESQ
	b CHECK_ATACK_DIR
	
	
CHECK_ATACK_CIMA:
	la t0,link_pos
	lh s1,2(t0)		#pos link y
	lh s0,0(t0)		#pos link x
	addi s1,s1,-16
	b CHECK_ATACK1

CHECK_ATACK_DIR:
	la t0,link_pos
	lh s1,2(t0)		#pos link y
	lh s0,0(t0)		#pos link x
	addi s0,s0,16
	b CHECK_ATACK1

CHECK_ATACK_ESQ:
	la t0,link_pos
	lh s1,2(t0)		#pos link y
	lh s0,0(t0)		#pos link x
	addi s0,s0,-16
	b CHECK_ATACK1

CHECK_ATACK_BAIX:
	la t0,link_pos
	lh s1,2(t0)		#pos link y
	lh s0,0(t0)		#pos link x
	addi s1,s1,16
	b CHECK_ATACK1

CHECK_ATACK1:
	la t0,map_location
	lb t1,0(t0)
	lb t2,1(t0)
	li t3,3
	mul t2,t2,t3
	add t0,t1,t2
	li t1,50
	mul t0,t1,t0
	
	la t1,lista_itens
	addi t1,t1,8
	add t1,t1,t0
	li s10,10  #contador

LOOP_ATACK:
	lb t2,1(t1)
	
	li t3,6
	beq t2,t3,HIT_BOSS0
	
	li t3,3
	blt t2,t3,ATACK_LINE
	
	lb t3,2(t1)
	lb t4,3(t1)
	
BOSS_CALCULO:

	slli t3,t3,4
	slli t4,t4,4
	
	mv t5,s0
	mv t6,s1
	blt t5,t3,X_MENOR_ATAQUE
	sub t5,t5,t3
	
X_ATAQUE_VOLTA:
	
	blt t6,t4,Y_MENOR_ATAQUE
	sub t6,t6,t4
	
Y_ATAQUE_VOLTA:

	add t5,t5,t6
	la t0,pos_offset
	lb t2,0(t0)
	sub t5,t5,t2
	lb t2,1(t0)
	sub t5,t5,t2
	
	
	
	li t2,16
	blt t5,t2,ACERTO
	bnez s2,HIT_BOSS1
	b ATACK_LINE
	
ACERTO:
	lb t2,4(t1)
	addi t2,t2,-1
	sb t2,4(t1)
	beq t2,zero,MATA_E_DROPA
	b ATACK_LINE
	

MATA_E_DROPA:	
	li a7,41
	ecall
	li t2,2
	rem t3,a0,t2
	ecall
	rem t2,a0,t2
	
	and t2,a0,t2
	li t3,32
	mul t3,t3,t2
	sb t2,1(t1)
	sb t3,0(t1)
	
	b ATACK_LINE
	
END_CHECK_ATACK:
	lw t0,0(sp)
	lw t1,4(sp)
	lw t2,8(sp)
	lw t3,12(sp)
	lw t4,16(sp)
	lw t5,20(sp)
	lw t6,24(sp)
	lw s10,28(sp)
	lw s0,32(sp)
	lw s1,36(sp)
	lw s2,40(sp)
	addi sp,sp,44
	
	ret
	
	
X_MENOR_ATAQUE:
	sub t5,t3,t5
	b X_ATAQUE_VOLTA

Y_MENOR_ATAQUE:
	sub t6,t4,t6
	b Y_ATAQUE_VOLTA


ATACK_LINE:
	addi t1,t1,5
	addi s10,s10,-1
	beq s10,zero,END_CHECK_ATACK
	b LOOP_ATACK

HIT_BOSS0:
	li s2,1
	
HIT_BOSS1:
	addi s2,s2,1
	lb t3,2(t1)
	lb t4,3(t1)
	li a7,2
	beq s2,a7,BOSS_CALCULO
	addi t3,t3,1
	li a7,3
	beq s2,a7,BOSS_CALCULO
	addi t4,t4,1
	li a7,4
	beq s2,a7,BOSS_CALCULO
	addi t3,t3,-1
	li a7,5
	beq s2,a7,BOSS_CALCULO
	addi t4,t4,-1
	li s2,0
	b BOSS_CALCULO
	
	
	
.text
#a5 = direção que esta se movimentando
#1 = cima
#2 = esquerda
#3 = baixo
#4 = direita
COLISAO_ENTIDADES:

	la t0,teste_entidades
	addi t0,t0,8
	
	la t1,link_pos
	lh t2,0(t1)
	lh t3,2(t1)
	srli t2,t2,4
	srli t3,t3,4
	
	addi t3,t3,-4
	li t4,20
	mul t4,t4,t3
	add t4,t4,t2
	add t4,t0,t4
	
	li t0,1
	beq a5,t0,CALCULA_CIMA1
	li t0,2
	beq a5,t0,CALCULA_ESQUERDA1
	li t0,3
	beq a5,t0,CALCULA_BAIXO1
	li t0,4
	beq a5,t0,CALCULA_DIREITA1
	

CALCULA_CIMA1:
		addi t0,t0,-20
		j END_ENTIDADE


CALCULA_BAIXO1:
		addi t0,t0,20
		j END_ENTIDADE

CALCULA_DIREITA1:
		addi t0,t0,1
		j END_ENTIDADE
		
CALCULA_ESQUERDA1:
		addi t0,t0,-1
		j END_ENTIDADE


END_ENTIDADE:
	lb s5,0(t4)
	ret
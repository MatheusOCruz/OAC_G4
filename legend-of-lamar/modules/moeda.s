.text
MOEDA:
	
	li t3,13
	beq a7,t3,COLETA_MOEDA
	li t3,14
	beq a7,t3,COLETA_MOEDA
	
	ret
	
COLETA_MOEDA:
	la t0,link_moedas
	lh t1,0(t0)
	addi t1,t1,10
	sh t1,0(t0)
	
	li t6,0
	sb t6,0(s5)
	li a4,0
	ret

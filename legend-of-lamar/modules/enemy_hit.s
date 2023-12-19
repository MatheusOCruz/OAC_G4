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
	addi s1,s1,-16		#pos um pra cima
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
	la t0,map_location	#pega a sala atual pra saber quais inimigos tem
	lb t1,0(t0)
	lb t2,1(t0)
	li t3,3
	mul t2,t2,t3
	add t0,t1,t2		#posiçao absoluta da sala
	li t1,50		#tamanho da lista de itens da sala
	mul t0,t1,t0		#pega a posiçao inicial da lista de itens
	
	la t1,lista_itens	#lista de onde vai pegar os dados dos inimigos
	addi t1,t1,8		
	add t1,t1,t0		#vai pro equivalente da sala atual na lista
	li s10,10  #contador

LOOP_ATACK:			#itera por cada elemento da lista e ve se ele colide com o ataque
	lb t2,1(t1)		
	
	li t3,6
	beq t2,t3,HIT_BOSS0	#o boss é um pouco diferente pq é maior
	
	li t3,3			#se nao for um inimigo passa pro proximo item da lista
	blt t2,t3,ATACK_LINE
	
	lb t3,2(t1)		#pega os dados da posiçao do inimigo
	lb t4,3(t1)
	
BOSS_CALCULO:

	slli t3,t3,4		#muda a posiçao de tile pra pixel
	slli t4,t4,4
	
	mv t5,s0		#calcula a diferença de posiçao entre o ataque o o monstro
	mv t6,s1
	blt t5,t3,X_MENOR_ATAQUE	#o unico jeito q eu achei pra calcular modulo, eu preciso muito de uma funçao pra isso
	sub t5,t5,t3
	
X_ATAQUE_VOLTA:
	
	blt t6,t4,Y_MENOR_ATAQUE
	sub t6,t6,t4
	
Y_ATAQUE_VOLTA:

	add t5,t5,t6		
	la t0,pos_offset	#inclui o offset do link no calculo
	lb t2,0(t0)
	sub t5,t5,t2
	lb t2,1(t0)
	sub t5,t5,t2
	
	
	
	li t2,16
	blt t5,t2,ACERTO	#se a diferença de posiçao for < 16 ele acertou
	bnez s2,HIT_BOSS1	#se for >16 testa se é o boss
	b ATACK_LINE		#se errou e nao é o boss ele resta o proximo inimigo
	
ACERTO:
	lb t2,4(t1)		#se acertou subtrai vida
	addi t2,t2,-1
	sb t2,4(t1)
	beq t2,zero,MATA_E_DROPA	#se a vida for 0 mata o monstro
	b ATACK_LINE
	

MATA_E_DROPA:	
	li a7,41		#pegando uns numeros aleatorios pro drop
	ecall
	li t2,2
	rem t3,a0,t2
	ecall
	rem t2,a0,t2
	
	and t2,a0,t2
	li t3,32
	mul t3,t3,t2		
	sb t2,1(t1)		#coloca um drop aleatorio(moeda ou cafe) no lugar do inimigo
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

Y_MENOR_ATAQUE:			#aquelas paradas de modulo de novo
	sub t6,t4,t6
	b Y_ATAQUE_VOLTA


ATACK_LINE:		#passa pro proximo item na lista
	addi t1,t1,5
	addi s10,s10,-1	#contador(ele vai decrementando no caso)
	beq s10,zero,END_CHECK_ATACK	#encerra caso contador = 0
	b LOOP_ATACK

HIT_BOSS0:		#calculo parecido mas como o boss é grande tem q mudar uns detalhes
	li s2,1		#s2 diferente de 0 indica q é um boss
	
HIT_BOSS1:
	addi s2,s2,1	#s2 meio q serve como um contador tbm
	lb t3,2(t1)	#pega a posiçao pq precisa resetar ela com cada loop
	lb t4,3(t1)
	li a7,2		#no primeiro loop calcula normal a colisao do boss
	beq s2,a7,BOSS_CALCULO
	addi t3,t3,1	#no segundo soma 1 em x e calcula de novo
	li a7,3
	beq s2,a7,BOSS_CALCULO
	addi t4,t4,1	#ai soma 1 em y
	li a7,4
	beq s2,a7,BOSS_CALCULO
	addi t3,t3,-1	#so 1 em y mas nao em x
	li a7,5
	beq s2,a7,BOSS_CALCULO
	addi t4,t4,-1	#reseta os valores pra posiçao certa
	li s2,0		#s2 = 0 significa q vai sair desse loop
	b BOSS_CALCULO
	
	
	

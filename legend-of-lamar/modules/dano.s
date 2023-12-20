.text
CHECK_DANO:
	la t0,escudo
	lw t1,4(t0)
	csrr t2,time
	sub t2,t2,t1
	li t1,1000
	blt t2,t1,NO_INPUT
	
	
	slli t0,a1,4		#pegando posiçao em pixel
	slli t1,a2,4
	
	la  t2,link_pos		#pos x/y do link
	lh t3,2(t2)
	lh t2,0(t2)
	
	la t4,pos_offset	#calcula o valor caso ele esteja ou nao no meio de 2 quadrados
	lb t5,1(t4)
	lb t4,0(t4)
	srli t5,t5,3
	srli t4,t4,3
	
	blt t2,t0,X_MENOR_DANO	#mais coisa pra calcular modulo da diferença
	sub t2,t2,t0
X_VOLTA_DANO:
	
	blt t3,t1,Y_MENOR_DANO
	sub t3,t3,t1

Y_VOLTA_DANO:
	add t2,t2,t3
	sub t2,t2,t5
	sub t2,t2,t4
	
	li t1,16
	bgeu t2,t1,END_DANO	#se adiferença da posiçao for > 16 nao colide
	
	la t0,link_vida		#se colidir subtrai 1 de vida
	lb t1,0(t0)		#essa parte da colisao roda toda vez q alguma informaçao do inimigo atualiza
	addi t1,t1,-1
	sb t1,0(t0)

END_DANO:
	ret
	
X_MENOR_DANO:
	sub t2,t0,t2
	b X_VOLTA_DANO
	
Y_MENOR_DANO:
	sub t3,t1,t3
	b Y_VOLTA_DANO




CHECK_DANO_BOSS: 	#o boss é bem parecido so q no caso ele é 32x32
	la t0,escudo
	lw t1,4(t0)
	csrr t2,time
	sub t2,t2,t1
	li t1,1000
	blt t2,t1,NO_INPUT
	
	
	li t6,0		#define q é um boss
CHECK_DANO_BOSS2:
	
	slli t0,a1,4	#essa primeira parte é igual à checagem normal
	slli t1,a2,4	
	
	la  t2,link_pos
	lh t3,2(t2)
	lh t2,0(t2)
	
	la t4,pos_offset
	lb t5,1(t4)
	lb t4,0(t4)
	srli t5,t5,3
	srli t4,t4,3
	
	blt t2,t0,X_MENOR_DANO_BOSS
	sub t2,t2,t0
X_VOLTA_DANO_BOSS:
	
	blt t3,t1,Y_MENOR_DANO_BOSS
	sub t3,t3,t1

Y_VOLTA_DANO_BOSS:
	add t2,t2,t3
	sub t2,t2,t5
	sub t2,t2,t4
	li t1,16
	blt t2,t1,CAUSA_DANO_BOSS	#testa se colidiu com o link
	
	
	lb a1,2(s2)	#reseta a posiçao normal a cada loop
	lb a2,3(s2)
	addi t6,t6,1
	addi a1,a1,1	
	li t1,1		
	beq t1,t6,CHECK_DANO_BOSS2 #primeira vez checa com x + 1
	addi a2,a2,1
	li t1,2
	beq t1,t6,CHECK_DANO_BOSS2	#segundo checa com x + 1 e y + 1
	addi a1,a1,-1
	li t1,3
	beq t1,t6,CHECK_DANO_BOSS2	#terceira checa com y + 1
	
	lb a1,2(s2)	#volta pra posiçao normal
	lb a2,3(s2)
	ret
	

CAUSA_DANO_BOSS:		#subtrai vida do link
	la t0,link_vida
	lb t1,0(t0)
	addi t1,t1,-1
	sb t1,0(t0)
	
	lb a1,2(s2)
	lb a2,3(s2)
	ret
	
X_MENOR_DANO_BOSS:
	sub t2,t0,t2
	b X_VOLTA_DANO_BOSS
	
Y_MENOR_DANO_BOSS:
	sub t3,t1,t3
	b Y_VOLTA_DANO_BOSS

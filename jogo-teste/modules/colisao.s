.text

CHECK_COLISAO:

		
		la t0,map_location  		#em qual dos mapas o link ta
		lb t1,0(t0)			#x
		lb t2,1(t0)			#y
		li t3,20			#tamanho x de uma tela
		mul t3,t1,t3			#tamanho da tela vezes numero de telas
		li t4,660			#tamanho y da tela
		mul t4,t2,t4			#tamanho em y vezes o numero de telas
		add a1,t3,t4			#posição do link no mapa geral
		
		
		la t0,link_pos
		la t3,teste_mapa_tilemap
		addi t3,t3,8 #pegando a matriz da tela e pulando os dados
	
		lh t1,2(t0) # eixo y
		lh t2,0(t0) #eixo x
		li t6,1
		li t5,16
		# arruma o bloco de colisao pra movimetar <1 tile por move 
		#arruma o eixo y
		li t6,1
		beq a5,t6,pra_baixo_nao_arruma
		rem t6,t1,t5
		add t1,t1,t6
pra_baixo_nao_arruma:
		
		
		li t6,3
		beq a5,t6,pra_direita_nao_arruma
		
		rem t6,t2,t5
		add t2,t2,t6
		
pra_direita_nao_arruma:	
		mv a2,t1
		mv a3,t2	
		srli t5,t1,4	#ind�ce na matriz em y
		srli t2,t2,4	#ind�ce na matriz em x
		addi t5,t5,-4
		li t4,60        #calculando a posi��o do quadrado de cima do boneco
		mul t6,t5,t4
		add t3,t3,t6
		add t3,t3,t2
		add t3,t3,a1 	#t3 = posição do link no bitmap
		mv s10,t3
		
		li t0,0
		beq a5,t0,CALCULA_CIMA
		li t0,2
		beq a5,t0,CALCULA_ESQUERDA
		li t0,1
		beq a5,t0,CALCULA_BAIXO
		li t0,3
		beq a5,t0,CALCULA_DIREITA
		
PULA_CALCULO:		#se ele tiver na posiçao normal do quadrado, deixa ele mover meio quadrado pra cima(faz aquele efeito meio 3d sei la)
		li t4,0
		mv a7,t4
		mv s5,t3
		snez a4,t4
		addi t4,t4,-16
		snez t0,t4
		and a4,a4,t0
		addi t4,t4,16
		
		ret

CALCULA_OFFSET:		#checa se ele ta no meio certinho de um quadrado ou se ta deslocado em 8 pra arrumar a colisao
		lb t4,0(t3)
		lb t5,-1(t3)	#pega o quadrado 1 pra baixo e um pra esquerda
		
		mul t1,t4,t5
		add t1,t1,t4
		sub t1,t1,t5
		
		mv a7,t4	#salva dados
		mv s5,t3
		addi t2,t4,-2
		addi t5,t5,-2
		
		li t0,36
		beq t1,t0,CAVERNOSA1
		
		slt t2,zero,t2
		slt t5,zero,t5
		
		or a4,t2,t5	#se ele estiver entre 2 quadrados horizontalmente e algum dos dois nao for vazio ele nao pode andar
		
		ret
		
CAVERNOSA1:	
		la t0,pos_offset
		sb zero,0(t0)
		sb zero,1(t0)
		b cavernosa	
		
VOLTA_CALCULO:
		lb t4,0(t3)	     	#pega o valor do quadrado
		li t0,5			#valor equivalente da caverna
		mv a7,t4		#guardando alguns valores q vai precisar depois
		mv s5,t3
		addi t4,t4,-1
		slt a4,zero,t4		#se nao for um quadrado vazio a4 = 1, o q significa q ele nao pode andar. caso seja um item coletavel ele ve isso em outra funçao

		beq t0,t4,cavernosa	#faz as paradas pra ir pra caverna
		addi t4,t4,1
		
		ret
		
CALCULA_CIMA:
		
		mv a0,t5
		addi t3,t3,-60		#quadrado em cima do link
		
		la t0 pos_offset	#testa se ta no meio do quadrado verticalmente
		lb t1,0(t0)
		beq t1,zero,PULA_CALCULO
		
		lb t1,1(t0)		#testa se ta no meio do quadrado horizontalmente
		li t2,8
		beq t1,t2,CALCULA_OFFSET
		
		j VOLTA_CALCULO


CALCULA_BAIXO:			#igual o de ir pra cima so q nao precisa calcular se ta no meio do quadrado verticalmente
		mv a0,t5
		addi t3,t3,60
		
		la t0,pos_offset
		lb t1,1(t0)
		li t2,8
		beq t1,t2,CALCULA_OFFSET
		
		j VOLTA_CALCULO

CALCULA_DIREITA:
		mv a6,t2
		addi t3,t3,1
		j VOLTA_CALCULO
		
CALCULA_ESQUERDA:
		mv a6,t2
		addi t3,t3,-1
		j VOLTA_CALCULO
		
		
cavernosa:
	la t0,pos_offset
	sb zero,0(t0)
	sb zero,1(t0)
	
	la t0,map_location
	lb t1,0(t0)
	lb t2,1(t0)
	li t3,3
	mul t2,t2,t3
	add t1,t1,t2
	
	li t2,0
	beq t1,t2,SALA0
	
	li t2,1
	beq t1,t2,SALA1
	
	li t2,8
	beq t1,t2,SALA8
	
	li t2,9
	beq t1,t2,SALA9
	
	li t2,10
	beq t1,t2,SALA10
	
	li t2,12
	beq t1,t2,SALA12
	
SALA0:
	
	li t1,1
	li t2,3
	
	la t3,camera
	li t5,20
	li t6,33
	sb t5,0(t3)
	sb t6,1(t3)
	
	
	sb t1,0(t0)
	sb t2,1(t0)
	li a0,1
	li a4,1
	
	la t0,link_pos	#definindo a posiçao q o link sai da porta
	li t1,144
	sh t1,0(t0)
	li t1,208
	sh t1,2(t0)
	
	ret
	
SALA1:
	li t1,0
	li t2,4
	
	la t3,camera
	li t5,0
	li t6,44
	sb t5,0(t3)
	sb t6,1(t3)
	
	sb t1,0(t0)
	sb t2,1(t0)
	li a0,1
	li a4,1
	
	la t0,link_pos	#definindo a posiçao q o link sai da porta
	li t1,128
	sh t1,0(t0)
	li t1,80
	sh t1,2(t0)
	
	ret

SALA8:
	
	
	la t3,camera	#definindo a posiçao da camera
	li t5,0
	li t6,33
	sb t5,0(t3)
	sb t6,1(t3)
	
	
	li t1,0		#definindo a posiçao correta do mapa_pos
	li t2,3
	sb t1,0(t0)
	sb t2,1(t0)
	li a0,1
	li a4,1
	
	la t0,link_pos	#definindo a posiçao q o link sai da porta
	li t1,144
	sh t1,0(t0)
	li t1,208
	sh t1,2(t0)
	
	ret

SALA9:
	
	
	la t3,camera
	li t5,40
	li t6,22
	sb t5,0(t3)
	sb t6,1(t3)
	
	li t1,2
	li t2,2
	sb t1,0(t0)
	sb t2,1(t0)
	li a0,1
	li a4,1	
	
	la t0,link_pos	#definindo a posiçao q o link sai da porta
	li t1,32
	sh t1,0(t0)
	li t1,160
	sh t1,2(t0)
	
	ret

SALA10:
	la t3,camera
	sb zero,0(t3)
	sb zero,1(t3)
	
	sb zero,0(t0)
	sb zero,1(t0)
	li a0,1
	li a4,1
	
	la t0,link_pos	#definindo a posiçao q o link sai da porta
	li t1,64
	sh t1,0(t0)
	li t1,128
	sh t1,2(t0)
	
	ret	
	
SALA12:
	li t1,1
	li t2,0
	
	la t3,camera
	li t5,20
	li t6,0
	sb t5,0(t3)
	sb t6,1(t3)
	
	sb t1,0(t0)
	sb t2,1(t0)
	li a0,1
	li a4,1
	
	la t0,link_pos	#definindo a posiçao q o link sai da porta
	li t1,112
	sh t1,0(t0)
	li t1,96
	sh t1,2(t0)
	
	ret

	
	

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
		
		li t0,1
		beq a5,t0,CALCULA_CIMA
		li t0,2
		beq a5,t0,CALCULA_ESQUERDA
		li t0,3
		beq a5,t0,CALCULA_BAIXO
		li t0,4
		beq a5,t0,CALCULA_DIREITA
		
VOLTA_CALCULO:
		
		lb t4,0(t3)	     #pega o valor do quadrado
		snez  a4,t4
		ret
		
CALCULA_CIMA:
		mv a0,t5
		addi t3,t3,-60
		j VOLTA_CALCULO


CALCULA_BAIXO:
		mv a0,t5
		addi t3,t3,60
		j VOLTA_CALCULO

CALCULA_DIREITA:
		mv a6,t2
		addi t3,t3,1
		j VOLTA_CALCULO
		
CALCULA_ESQUERDA:
		mv a6,t2
		addi t3,t3,-1
		j VOLTA_CALCULO
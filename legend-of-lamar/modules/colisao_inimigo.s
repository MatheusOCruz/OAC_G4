.text
#s3 = x
#s4 = y
#t5 = tamanho

CHECK_COLISAO_INIMIGO:
		la t0,map_location  		#em qual dos mapas o link ta
		lb t1,0(t0)			#x
		lb t2,1(t0)			#y
		li t3,20			#tamanho x de uma tela
		mul t3,t1,t3			#tamanho da tela vezes numero de telas
		li t4,660			#tamanho y da tela
		mul t4,t2,t4			#tamanho em y vezes o numero de telas
		add a1,t3,t4			#posição do link no mapa geral
		
		li t0,1
		beq a5,t0,CALCULA_CIMA_INIMIGO
		li t0,2
		beq a5,t0,CALCULA_ESQUERDA_INIMIGO
		li t0,3
		beq a5,t0,CALCULA_BAIXO_INIMIGO
		b CALCULA_DIREITA_INIMIGO


CALCULA_CIMA_INIMIGO:

		slli t0,s3,4
		slli t1,t4,4
		li t2,60
		mul t1,t1,t2
		
		add a1,a1,t0
		add a1,a1,t1
		
		addi a1,a1,-60
		b END_CALCULO_INIMIGO
		
CALCULA_ESQUERDA_INIMIGO:

		slli t0,s3,4
		slli t1,t4,4
		li t2,60
		mul t1,t1,t2
		
		add a1,a1,t0
		add a1,a1,t1
		
		addi a1,a1,-1
		b END_CALCULO_INIMIGO

CALCULA_BAIXO_INIMIGO:

		slli t0,s3,4
		slli t1,t4,4
		li t2,60
		mul t1,t1,t2
		
		add a1,a1,t0
		add a1,a1,t1
		
		addi a1,a1,60
		
CALCULA_DIREITA_INIMIGO:

		slli t0,s3,4
		slli t1,t4,4
		li t2,60
		mul t1,t1,t2
		
		add a1,a1,t0
		add a1,a1,t1
		
		addi a1,a1,1
		
END_CALCULO_INIMIGO:
		la t3,teste_mapa_tilemap
		add t3,t3,a1
		lb t4,0(t3)	     #pega o valor do quadrado
		mv a7,t4
		mv s5,t3
		snez a4,t4
		
		ret
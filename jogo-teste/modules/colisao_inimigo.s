.text
#s3 = x
#s4 = y
#a4 = tamanho

CHECK_COLISAO_INIMIGO:

		la t0,map_location  		#em qual dos mapas o link ta
		lb t1,0(t0)			#x
		lb t2,1(t0)			#y
		li t3,20			#tamanho x de uma tela
		mul t3,t1,t3			#tamanho da tela vezes numero de telas
		li t4,660			#tamanho y da tela
		mul t4,t2,t4			#tamanho em y vezes o numero de telas
		add a1,t3,t4			#posição do link no mapa geral
	
		li t2,60
		addi s4,s4,-4
		mul s4,t2,s4
		add a1,a1,s4
		add a1,a1,s3
		
		li t0,1
		beq a5,t0,CALCULA_CIMA_INIMIGO
		li t0,2
		beq a5,t0,CALCULA_ESQUERDA_INIMIGO
		li t0,3
		beq a5,t0,CALCULA_BAIXO_INIMIGO
		b CALCULA_DIREITA_INIMIGO


CALCULA_CIMA_INIMIGO:
		
		addi a1,a1,-60
		beq s4,zero,END_INIMIGO2
		b END_CALCULO_INIMIGO
		
CALCULA_ESQUERDA_INIMIGO:
		addi a1,a1,-1
		beq s3,zero,END_INIMIGO2
		
		b END_CALCULO_INIMIGO

CALCULA_BAIXO_INIMIGO:
		srli t5,a4,4
		addi t5,t5,-1
		li t3,60
		mul t5,t5,t3
		add a1,a1,t5
		addi a1,a1,60
		
		li t1,600

		beq s4,t1,END_INIMIGO2
		b END_CALCULO_INIMIGO
		
CALCULA_DIREITA_INIMIGO:
		addi a1,a1,1
		li t3,19

		beq s3,t3,END_INIMIGO2
		
END_CALCULO_INIMIGO:
		la t3,teste_mapa_tilemap
		addi t3,t3,8
		add t3,t3,a1
		lb t4,0(t3)	     #pega o valor do quadrado
		addi t4,t4,-2
		slt a7,t4,zero
		
		ret

END_INIMIGO2:
	li a7,0
	ret

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
		
		
		mv t0,a0
		la t3,teste_mapa_tilemap
		addi t3,t3,8 #pegando a matriz da tela e pulando os dados
	
		lh t1,2(t0) # eixo y
		lh t2,0(t0) #eixo x
		li t6,1
		li t5,16
		# arruma o bloco de colisao pra movimetar <1 tile por move 
		#arruma o eixo y
		li t6,3
		beq a5,t6,pra_baixo_nao_arruma
		rem t6,t1,t5
		add t1,t1,t6
pra_baixo_nao_arruma:
		
		
		li t6,4
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
		li t0,6
		snez  a4,t4
		beq t0,t4,cavernosa
		
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
		
		
cavernosa:
	addi sp,sp,-4
	sw ra,0(sp)
	call CLEAR_ITEMS
	lw ra,0(sp)
	addi sp,sp,4
	#  decide onde ta, mapa/dungeon/caverna
	li t0,1 
	beq s1,t0, TA_NA_DUNGEON
	bne s1,zero, TA_NA_CAVERNOSA
	#aqui ta no mundo aberto
	# trem opcoes de caverna 
	# 2 2 -> caverna de item 1
	# 0 0 -> caverna de item 2
	# 0 1 -> entrada da dungeon
	la t0, map_location
	lb t1, 0(t0)
	li t2,2
	bne t1,t2, cavernosa_teste2
	# aqui ta na tela 2,2
	
	
	# carrega (0,3) na posicao
	li t1,3
	sb t1,1(t0)
	sb zero,0(t0) 
	
	# carrega na camera // dps fazer transicao pra caverna 
	la t0, camera	  

	sb zero,0(t0)
	li t1,33
	sb t1,1(t0)
	
	# atualiza posicao
	la t0,link_pos
	li t1,144
	sh t1,0(t0)
	li t1,208
	sh t1,2(t0)
	
	li s1,2 # indica que ta na caverna
	
	# nessa sala tem a espada de madeira pra pickup
	li a0,4 	# id da espada
	li a1,128	# x q a espada aparece
	li a2,144 	# y que a espada aparece
	
	tail ADD_ITEM # nao faz mais nada aqui, pode dar return de dentro do add
	

cavernosa_teste2:
	lb t1,0(t0)
	bne t1,zero, ENTRA_DUNGEON
	
	# carrega (1,3) na posicao
	li t1,3
	sb t1,0(t0)
	li t1,1
	sb t1,1(t0) 
	
	# carrega na camera // dps fazer transicao pra caverna 
	la t0, camera	   
	li t1,20
	sb t1,0(t0)
	li t1,33
	sb t1,1(t0)
	li s1,2 # indica que ta na caverna
	ret



ENTRA_DUNGEON:
	# carrega (0,4) na posicao
	li t1,4
	sb t1,1(t0)
	sb zero,0(t0) 
	
	# carrega na camera // dps fazer transicao pra caverna 
	la t0, camera	  
	sb zero,0(t0)
	li t1,44
	sb t1,1(t0)
	ret


TA_NA_DUNGEON:
	ret
	
TA_NA_CAVERNOSA:
	# se estamos em 0,3 -> 2,2
	# se estamos em 1,3 -> 0,0
	la t0 map_location
	lb t1,0(t0)
	bne t1,zero TA_NA_CAVERNOSA2
	# atualiza no map de colisao
	li t1,2
	sb t1,0(t0)
	sb t1,1(t0)
	# atualiza camera
	la t0,camera
	li t1,40
	sb t1,0(t0)
	li t1,22
	sb t1,1(t0)
	# atualiza posicao
	la t0,link_pos
	li t1, 32
	sh t1,0(t0)
	li t1,160
	sh t1,2(t0)
	
	li s1,0 #salva que ta no mundo aberto
	ret

TA_NA_CAVERNOSA2:
	ret













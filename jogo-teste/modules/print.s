.data 
.include "../assets/tiles/itens1.data"
.include "../assets/tiles/entidades.data"
.include "../assets/tiles/zelda_hud.data"
.include "../assets/tiles/link_teste.data"
.include "../assets/tiles/link_walk.data"
.include "../assets/tiles/tiles_tela_1.data"

.text

PRINT:

	slli a2,a2,8		# slli por 8 = a2*256 (largura) endereco inicial do print
	li t0,0xFF0		# endereco incial da memoria FFx0 0000 onde x e o frame
	add t0,t0,a1 		# selecao do frame (0 ou 1)
	slli t0,t0,20		# endereco incial da memoria
	
	li t1, 0x12C00
	add t1,t1,t0		# endereco final da memoria
			
	addi a0,a0,8		# primeiro pixels depois das informa��es de nlin ncol
PRINT_LOOP: 			
	lw t3,0(a0)		# le um conjunto de 4 pixels : word
	sw t3,0(t0)		# escreve a word na mem�ria VGA
	addi t0,t0,4		# soma 4 ao endere�o da memoria
	addi a0,a0,4		# soma 4 ao endereco da imagem
	bne t0,t1,PRINT_LOOP	# Se for o �ltimo endere�o ent�o sai do loop
	ret

#	a0 = endereco da imagem
#	a1 = eixo x
#	a2 = eixo y
#	a3 = frame ( 0 ou 1 )
#	a4 = largura do sprite
#	a5 = futuramente altura do sprite no arquivo
#	a6 = qual pos do sprite
# 	a7 = contem o x,y da tela atual na matriz de tilemap	
#
#	t0 = endereco do bitmap display	
#	t1 = endereco da imagem
#	t2 = contador de linha
#	t3 = contador de coluna
#	t4 = altura
#	t5 = largura	
	
PRINT_SPRITE:
	#carrega endereco base do bitmap + frame
	li  t0, 0xFF0 
	add t0,t0,a3 
	slli t0,t0,20 
	#endereco inicial do print
	add t0,t0,a1   
	
	li t1, 320
	mul t1,a2,t1
	
	add t0,t0,t1
	#carrega endereco da imagem (tirando tamanho)
	addi t1,a0,8
	# usa o a6 para achar inicio do sprite a ser usado
	slli a6,a6,4
	add t1,t1,a6
	#zera contadores
	mv t2,zero
	mv t3,zero
	#carrega tamanho 
	lw t4,0(a0) # largura imagem
	lw t5,4(a0) # altura 
	
PRINT_SPRITE_LINE:
	# move a imagem pro endereco do display (4 bytes)
	lw t6,0(t1)
	sw t6,0(t0)
	
	addi t0,t0,4 # bitmap
	addi t1,t1,4 # imagem
	#continua ate terminar 
	addi t3,t3,4
	blt t3,a4,PRINT_SPRITE_LINE
	
	#posicao do primeiro pixel da proxima linha 
	addi t0,t0,320
	sub t0,t0,a4
	# posicao do primeiro piexl da proxima linha na imagem
	sub t6,t4,a4 # deslocamento da memoria em pixeis (largura do arquivo - largura da sprite)
	add t1,t1,t6
	
	mv t3,zero # zera o contador da colina
	addi t2,t2,1 # incrementa o contador da linha
	bgt t5,t2, PRINT_SPRITE_LINE # se n tiver printado todas as linhas continua
	
	ret



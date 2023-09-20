.data
.include "MACROSv21.s"
.text
j MAIN
	
.data

map_x: .byte 7
map_y: .byte 7	
link_pos: .half 128,144


.data 
.include "input.s"
.include "SYSTEMv21.s"
.text	
#	s0 = frame atual
#
#
#
MAIN:
	li s0,0
	la a0,menu_1
	li a1,0
	li a2,0
	call PRINT
	li a1,1 
	call PRINT
	
MENU_LOOP:
	
	call GET_INPUT_MENU

	j MENU_LOOP
	
START_TEXT:
	la a0,zelda_text
	li a1,0
	call PRINT
	li a1,1
	CALL PRINT
	li a7,32
  	li a0,2000
  	
 # tela comeca na linha 64	
GAME_PREP:
	la a0,hud
	li a1,0
	call PRINT
	la a0,hud
	li a1,1
	call PRINT
	la a0,tela_1
	li a1,0
	li a2,64
	LI a3,0
	call PRINT_SPRITE
	la a0,tela_1
	li a1,0
	li a2,64
	li a3,1
	call PRINT_SPRITE
	
GAME_LOOP:
	xori s0,s0,1  # troca frame
	la a0,tela_1
	li a1,0
	li a2,64
	mv a3,s0
	call PRINT_SPRITE
	la a0,link_teste
	la t0,link_pos
	lh a1,0(t0)
	lh a2,2(t0)
	mv a3,s0
	call PRINT_SPRITE
	
	li t0,0xFF200604 #altera o frame
	sw s0,0(t0)
	call GET_INPUT
	j GAME_LOOP
	




.data 
.include "tiles/menu_1.data"
.include "tiles/zelda_text.data"
.include "tiles/zelda_hud.data"
.include "tiles/tela_1_teste.data"
.include "tiles/link_teste.data"
.text
	
PRINT:
	slli a2,a2,8		# slli por 8 = a2*256 (largura) endereco inicial do print
	li t0,0xFF0		# endereco incial da memoria FFx0 0000 onde x e o frame
	add t0,t0,a1 		# selecao do frame (0 ou 1)
	slli t0,t0,20		# endereco incial da memoria
 
	li t1,0xF000		#  final -> FFX0 F000 onde x e o frame
	add t1,t0,t1		# endereco final da memoria
	add t0,t0,a2
	
	addi a0,a0,8		# primeiro pixels depois das informações de nlin ncol
PRINT_LOOP: 			
	lw t3,0(a0)		# le um conjunto de 4 pixels : word
	sw t3,0(t0)		# escreve a word na memória VGA
	addi t0,t0,4		# soma 4 ao endereço da memoria
	addi a0,a0,4		# soma 4 ao endereco da imagem
	bne t0,t1,PRINT_LOOP	# Se for o último endereço então sai do loop
	ret

#	a0 = endereco da imagem
#	a1 = eixo x
#	a2 = eixo y
#	a3 = frame ( 0 ou 1 )
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
	slli t1,a2,8
	add t0,t0,t1
	#carrega endereco da imagem (tirando tamanho)
	addi t1,a0,8
	#zera contadores
	mv t2,zero
	mv t3,zero
	#carrega tamanho e largrua
	lw t4,0(a0)
	lw t5,4(a0)
	
PRINT_SPRITE_LINE:
	# move a imagem pro endereco do display (4 bytes)
	lw t6,0(t1)
	sw t6,0(t0)
	
	addi t0,t0,4
	addi t1,t1,4
	#continua ate terminar 
	addi t3,t3,4
	blt t3,t4,PRINT_SPRITE_LINE
	#posicao do primeiro pixel da proxima linha 
	addi t0,t0,256
	sub t0,t0,t4
	
	mv t3,zero
	addi t2,t2,1
	ble t2,t5 PRINT_SPRITE_LINE
	
	ret
	
	
	
	
	
	









		
	
	
	
	
	
	
	
	
	
	
	
	
	
	

.data
#.include "MACROSv21.s"
.text
j GAME_PREP
	
.data


link_pos: .half 128,144   # pos do link na tela
link_sprite_num: .byte 5  # char da animacao da andanda

map_localtion: .half 1,2  # qual dos mapas na matrix dos tilemaps o bicho ta 


.data 
.include "input.s"
.include "print.s"
.include "map_manager.s"
#.include "SYSTEMv21.s"
.text	
#	s0 = frame atual
#
#
#	s11 = temporizador pros frames
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
  	ecall
  	
 # tela comeca na linha 64	
GAME_PREP:
	la a0,hud
	li a1,0
	call PRINT
	la a0,hud
	li a1,1
	call PRINT
	
	csrr s11, time # time 
	
	li t0, 1000
	li t1, 60
	fcvt.s.w ft0, t0 
	fcvt.s.w ft1, t1 
	fdiv.s fs11, ft0, ft1      #tempo do frame (1000/60)
	
	
GAME_LOOP:
	# mantem o jogo em 60 frames 
	li t0, 16
	
	csrr t1, time
	sub t1,t1,s11
	
	ble t1,t0, GAME_LOOP # caso o codigo seja todo executado mais rapido q a duracao do frame
	
	csrr s11, time
	
	
	xori s0,s0,1  # troca frame
	call MAP_MANAGER 
	
	# carrega o link no frame
	la a0,link_walk
	la t0, link_sprite_num 
	lb t0,0(t0)
	mv a6,t0    # a6 tem qual sprite da animacao o homi ta
	
	la t0,link_pos
	lh a1,0(t0) # x do link
	lh a2,2(t0) # y do link
	mv a3,s0    # carrega o frame atual
	li a4,16    # largura do sprite
	li a5,16    # futuramente usa altura pq tem sprite com mais de 16 (ataque)
	mv a7,zero  # a7 e usado so pelo tilemap
	call PRINT_SPRITE
	
	# pega input e move o homi
	li t0,0xFF200604 # endereco para mudar frame
	sw s0,0(t0)      # muda pro frame atual
	la a0,link_walk  # pra animacao
	addi a0,a0,8	 # pula tamanho 
	call GET_INPUT   
	
	j GAME_LOOP
	




	

	
	
	
	
	
	









		
	
	
	
	
	
	
	
	
	
	
	
	
	
	

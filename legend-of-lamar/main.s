.data
#.include "MACROSv21.s"
.text
j GAME_PREP
	
.data


link_pos: .half 128,144   # pos do link na tela y/x
link_sprite_num: .byte 5  # char da animacao da andanda
link_vida: .byte 8
link_moedas: .half 1000
link_chaves: .half 15
link_bombas: .half 3
map_localtion: .half 2,2  # qual dos mapas na matrix dos tilemaps o bicho ta x/y

general_pos: .half 5,8  #posiÃ§Ã£o do boneco no tilemap


.data 
.include "./modules/input.s"
.include "./modules/print.s"
.include "./modules/map_manager.s"
.include "./modules/music.s"
.include "./modules/hud_manager.s"
#.include "SYSTEMv21.s"
.text	
#	s0 = frame atual
#
#	s9 = temporizador pra musica
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
	li t0, 16				# Esse é o periodo em ms no qual o frame tem que ficar em tela para manter em 60fps
	csrr t1, time 			# Carrega o tempo atual
	sub t1, t1, s11 			# Subtrai o tempo atual do tempo do ultimo frame
	ble t1,t0, GAME_LOOP 	# se o tempo do ultimo frame for menor que 16 volta pro inicio do loop
	
	# limite de notas da musica
	la t0, CURRENT_NOTE_DURATION		# So toca uma nota nova passados o tempo da ultima
	lw t0, 0(t0)						# Carrega o valor da duração da nota
	csrr t1, time 						# Carrega o tempo atual
	sub t1, t1, s9 						# Subtrai o tempo atual do tempo da ultima nota
	ble t1, t0, NAO_TOCA				# Não toca se n passou 500 ms
	call MUSIC_PLAY					# Toca a nota
	csrr s9, time						# Salva o tempo da ultima nota em s10
NAO_TOCA:
	csrr s11, time	# Salva o tempo atual
	
	xori s0,s0,1  # troca frame
	call MAP_MANAGER 
	#call HUD_MANAGER (algo ta quebrado :( )
	# carrega o link no frame
	la a0,link_walk
	la t0, link_sprite_num 
	lb t0,0(t0)
	mv a6,t0    		# a6 tem qual sprite da animacao o homi ta
	
	la t0,link_pos
	lh a1,0(t0) 		# x do link
	lh a2,2(t0) 		# y do link
	mv a3,s0    		# carrega o frame atual
	li a4,16    			# largura do sprite
	li a5,16    			# futuramente usa altura pq tem sprite com mais de 16 (ataque)
	mv a7,zero  		# a7 e usado so pelo tilemap
	call PRINT_SPRITE
	
	# pega input e move o homi
	li t0,0xFF200604 	# endereco para mudar frame
	sw s0,0(t0)      		# muda pro frame atual
	la a0,link_walk  	# pra animacao
	addi a0,a0,8	 	# pula tamanho 
	call GET_INPUT   
	
	j GAME_LOOP

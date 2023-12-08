.data
.include "modules/MACROSv21.s"

.text
j GAME_PREP
	
.data
arma_a: .byte 4
arma_b: .byte 0		  # depois tem q definir o id de cada arma pra fazer isso
dano_items: .byte 0,0,20,0,1,10 # 0 nao sao itens, depende do id
general_pos: .half 5,8 

item_counter: .byte 0	#quantidade de itens na tela atual 
enemy_counter: .byte 0	# quantidade de inimigos na tela atual
	 
atacando: .byte 0,0	  #frame de ataque | direcao que o amigao tava olhando
# 0 1 2 3 
# w s a d
direcao:  .byte 0 	# direcao que o jovem ta durante o ataque


.text	
.include "modules/input.s"
.include "modules/print.s"
.include "modules/map_manager.s"
.include "modules/music.s"
.include "modules/hud_manager.s"

.include "modules/SYSTEMv21.s"

#	s0 = frame atual
#	s1 = 0 mundo aberto 1 dungeon 2 cavernosa
#   s5 -> duracao frame de ataque do link (os outros usam memoria)
#   s6 -> id arma do ataque
#	s7 = usado pelo item manager 
#	s8 = usado pelo enemy_manager
#	s9 = temporizador pra musica
#	s11 = temporizador pros frames
.macro muda_frame()
	li t0,0xFF200604 	# endereco para mudar frame
	sw s0,0(t0)      		# muda pro frame atual
.end_macro

.macro frame_delay(%r)
	li t0, 16				# Esse é o periodo em ms no qual o frame tem que ficar em tela para manter em 60fps
	csrr t1, time 			# Carrega o tempo atual
	sub t1, t1, %r 			# Subtrai o tempo atual do tempo do ultimo frame
	ble t1,t0, GAME_LOOP 	# se o tempo do ultimo frame for menor que 16 volta pro inicio do loop
.end_macro

.macro set_frame_duration(%fr)
li t0, 1000
	li t1, 60
	fcvt.s.w ft0, t0 
	fcvt.s.w ft1, t1 
	fdiv.s %fr, ft0, ft1      #tempo do frame (1000/60)
.end_macro

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
	
	set_frame_duration(fs11)

	li s1,0			   # comeca no mundo aberto
	
GAME_LOOP:
	
	frame_delay(s11) #cap de 60fps

	# limite de notas da musica
	la t0, CURRENT_NOTE_DURATION		# So toca uma nota nova passados o tempo da ultima
	lw t0, 0(t0)						# Carrega o valor da duração da nota
	csrr t1, time 						# Carrega o tempo atual
	sub t1, t1, s9 						# Subtrai o tempo atual do tempo da ultima nota
	ble t1, t0, NAO_TOCA				# Não toca se n passou 500 ms
	call MUSIC_PLAY					# Toca a nota
	csrr s9, time						# Salva o tempo da ultima nota em s9
NAO_TOCA:
	csrr s11, time	# Salva o tempo atual
	
	xori s0,s0,1  # troca frame
	call MAP_MANAGER 
	call HUD_MANAGER #(algo ta quebrado :( )
	call ITEM_MANAGER
	call ENEMY_MANAGER
	call UPDATE_LINK
	
	muda_frame()
	
	call GET_INPUT   
	
	j GAME_LOOP
	

.include "modules/enemy_manager.s"
.include "modules/item_manager.s"
.include "modules/link.s"
.include "modules/colisao.s"

.data
arma_ataque: .word
ataque_madeira

ataque_madeira: .word 
link_atack_up_madeira,
link_atack_down_madeira,
link_atack_left_madeira,
link_atack_right_madeira



duracao_frame: .byte 5 # duracao por frame e nao por tempo 
link_pos: .half 128,144   # pos do link na tela (x,y)
link_sprite_num: .byte 5  # char da animacao da andanda
link_vida: .byte 8
invul_frames: .byte 0 

link_espada: .half 0
link_moedas: .half 0
link_cafezin: .half 50
link_bombas: .half 0

.text

UPDATE_LINK:
	la t0,link_vida
	lb t1,0(t0)
	beq t1,zero,GAME_OVER
	la t0, invul_frames
	lb t1,0(t0)
	beq t1,zero,UPDATE_LINK_2
	addi t1,t1,-1
	sb t1,0(t0)


UPDATE_LINK_2:
	addi sp,sp,-12
	sw ra,0(sp)
	sw s1,4(sp)
	sw s2,8(sp)
	# checa se ta atacando 
	
	la t0,atacando
	lb t1,0(t0)
	mul t1,t1,s6
	bne t1,zero LINK_ATACK

	sb zero, 0(t0)
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
	call PRINT_SPRITE
	lw ra,0(sp)
	addi sp,sp,4
	ret
	
#  a0 contem o dano (1 e meio coracao)                                             
DAMAGE_LINK:
	la t0,link_vida
	lb t1,0(t0)
	sub t1,t1,a0
	sb t1,0(t0)
	ret
	
LINK_ATACK:
	# ve qual a arma (aqui ja sabe que e alguma arma de vdd eba)
	addi t0,s6,-4
	la t1,arma_ataque
	slli t0,t0,2 # cada id ocupa uma word (0->0, 1->4)
	add t1,t1,t0

	lw a0,0(t1)  # enderecos da arma atual

	la t0,atacando
	lb t1,0(t0)	# direcao do ataque
	lb t2,1(t0)
	mv a6,t1

	# nao usa mais t0,t1
	la t0,link_pos
	lh a1,0(t0)		# x do link
	lh a2,2(t0) 	# y do link
	mv s1,a1
	mv s2,a2
	mv a3,s0    	# frame atual
	li a4,16	# largura sprite
	beq t2,zero,LINK_ATAQUE_UP
	li t3,1
	beq t2,t3,LINK_ATAQUE_DOWN
	slli a6,a6,1
	li a4,32	# largura sprite horizontal
	li t3,2
	beq t2,t3,LINK_ATAQUE_LEFT
# se n for nenhum desses e o right

#   x = s1 y = s2
LINK_ATAQUE_RIGHT:
	lw a0,12(a0)
	addi s1,s1,16
	j LINK_ATACK_END

LINK_ATAQUE_UP:	
	lw a0,0(a0)
	addi a2,a2,-16
	addi s2,s2,-16
	j LINK_ATACK_END
	
LINK_ATAQUE_DOWN:	
	lw a0,4(a0)
	li a4,16
	addi s2,s2,16
	j LINK_ATACK_END
	
LINK_ATAQUE_LEFT:
	lw a0,8(a0)
	addi a1,a1,-16
	addi s1,s1,-16

	# n precisa do jump aqui ne zeca
LINK_ATACK_END:
	call PRINT_SPRITE
	la t0, duracao_frame
	lb t1,0(t0)
	addi t1,t1,-1
	sb t1,0(t0)
	bgt t1,zero,CHECK_FOR_ATACK_DAMAGE
	# aqui e pq acabou a duracao do pedaco do ataque
	li t1,5
	sb t1,0(t0) # reinicia
	
	la t0,atacando
	lb t1,0(t0)
	li t4,4
	addi t1,t1,1
	rem t1,t1,t4
	sb t1,0(t0)

CHECK_FOR_ATACK_DAMAGE:
	la t0,atacando
	lb t1,0(t0)
	li t2,1 # so causa dano no 1 frame do ataque
	bgt t1,t2,LINK_ATACK_RET
	mv a1,s1
	mv a2,s2
	la a3,dano_items
	add a3,a3,s6 #id da arma de ataque 
	lb a3,0(a3) # dano do ataque
	# a1,a2 -> x,y da hitbox do atack do link
	call CHECK_ENEMY_HIT
	
LINK_ATACK_RET:

	

	lw ra,0(sp)
	lw s1,4(sp)
	lw s2,8(sp)
	addi sp,sp,12
	ret	
	
	
	
	
.data
.include "../assets/tiles/link_atack_up_madeira.data"
.include "../assets/tiles/link_atack_down_madeira.data"
.include "../assets/tiles/link_atack_left_madeira.data"
.include "../assets/tiles/link_atack_right_madeira.data"

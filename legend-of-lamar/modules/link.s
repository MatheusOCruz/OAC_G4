.text

UPDATE_LINK:	
	addi sp,sp,-4
	sw ra,0(sp)
	# checa se ta atacando 
	la t0,atacando
	lb t1,0(t0)
	bne t1,zero LINK_ATAQUE
	
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
	
LINK_ATAQUE:
	
	
	la t0,atacando
	lb t1,0(t0)	# direcao do ataque
	lb t2,1(t0)
	mv a6,t1
	addi t1,t1,1
	li t4,4
	rem t1,t1,t4
	sb t1,0(t0)
	# nao usa mais t0,t1,t4
	la t0,link_pos
	lh a1,0(t0)	# x do link
	lh a2,2(t0) 	# y do link
	
	mv a3,s0    	# frame atual
	li a4,16	# largura sprite
	beq t2,zero,LINK_ATAQUE_UP
	li t3,1
	beq t2,t3,LINK_ATAQUE_DOWN
	slli a6,a6,1
	li t3,2
	li a4,32	# largura sprite horizontal
	beq t2,t3,LINK_ATAQUE_LEFT
# se n for nenhum desses e o right
LINK_ATAQUE_RIGHT:
	la a0,link_atack_right_madeira
	j LINK_ATACK_END
LINK_ATAQUE_UP:	
	la a0,link_atack_up_madeira
	addi a2,a2,-16
	j LINK_ATACK_END
	
LINK_ATAQUE_DOWN:	
	la a0,link_atack_down_madeira
	li a4,16
	j LINK_ATACK_END
	
LINK_ATAQUE_LEFT:
	la a0,link_atack_left_madeira
	addi a1,a1,-16
	# n precisa do jump aqui ne zeca
LINK_ATACK_END:
	call PRINT_SPRITE
	li a0,100
	li a7,32
	ecall
	lw ra,0(sp)
	addi sp,sp,4
	ret	
	
	
	
	
.data
.include "../assets/tiles/link_atack_up_madeira.data"
.include "../assets/tiles/link_atack_down_madeira.data"
.include "../assets/tiles/link_atack_left_madeira.data"
.include "../assets/tiles/link_atack_right_madeira.data"

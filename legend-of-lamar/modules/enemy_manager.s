.data 
.include "../assets/tiles/enemy1_temp.data"

inimigos_tela: .half 
0,0,0,0,
0,0,0,0,
0,0,0,0,
0,0,0,0,
0,0,0,0,
0,0,0,0,
0,0,0,0,
0,0,0,0,
0,0,0,0,
0,0,0,0

.text




# a0 -> id inimigo que bateu as botas
# a1 -> x 
# a2 -> y

# #####################
#  id dos inimigos
# #####################
# 1 -> anim spawn
# 2 -> bicho 1(n tem nome ainda nem nada)
# 3 -> 
#...
# 6 -> anim morte
# #####################

# #####################
#         struct 
# #####################
# byte 0 -> id
# byte 1 -> vida
# half 2 -> x
# half 4 -> y
# byte 6 -> duracao
# byte 7 -> frame_animacao|direcao
ENEMY_MANAGER:
    mv a3,s0
    addi sp,sp,-32
    sw ra,0(sp)
    sw s0,4(sp)
    sw s1,8(sp)
    sw s2,12(sp)
    sw s3,16(sp)
    sw s4,20(sp)
    sw s5,24(sp)
    #sw s6,28(sp)

    li s0,10    # iterador (nao vou usar agr)
    #la s7,inimigos_tela

    #lb s1,0(s7) # id
    #lb s2,1(s7) # vida
    #lh s3,2(s7) # x
    #lh s4,4(s7) # y
    #lb s5,6(s7) # duracao frame de animacao
    #lb s6,7(s7) # direcao que o guerreiro ta olhando
    li s1,1
    li s2,2
    li s3,112
    li s4,144
    li s6,0
    mv a1,s3
    mv a2,s4
    call COLISAO_INIMIGO
    call PRINT_INIMIGO
    # fazer aqui pro do id 1

    
    

ENEMY_RET:
    lw ra,0(sp)
    lw s0,4(sp)
    lw s1,8(sp)
    lw s2,12(sp)
    lw s3,16(sp)
    lw s4,20(sp)
    lw s5,24(sp)
    lw s6,28(sp)
    addi sp,sp,32
    ret 


# , frame animacao, duracao direcao q ta olhano

GERA_DROP:

# RNG PRA DROPAR ITENZINHO

ENEMY_HIT_LINK_CHECK:
    la t2, invul_frames
    lb t3,0(t2)
    beq t3,zero,ENEMY_HIT_LINK
    b ENEMY_RET


#      TODO
#      knockback no link (segundo byte do atacando ja guarda a info da direcao, so jogar na contraria)
ENEMY_HIT_LINK:
    la t0,link_vida
    # supondo que sempre seja meio coracao de dano
    lb t1,0(t0)
    addi t1,t1,-1
    sb t1,0(t0)
    li t3,20
    sb t3,0(t2) # frames de invencibilidade
    b ENEMY_RET 


COLISAO_INIMIGO:
	la t0,link_pos
	lh t1,0(t0)
	lh t2,2(t0)
	addi t0,t1,16
	slt t3, a1,t0 # item.x < link.x + link.w
	addi t0,a1,16
	slt t4,t1,t0  # link.x < item.x + item.w
	and t3,t3,t4  # ja faz o and dos dois pra liberar o t4
	addi t0,t2,16
	slt t4,a2,t0  # item.y < link.y + link.h
	and t3,t3,t4  # libera t4 ja
	addi t0,a2,16
	slt t4,t2,t0  # link.t < item.y + item.h
	and t3,t3,t4
	
	bne t3,zero,ENEMY_HIT_LINK_CHECK
	ret
   
# TODO
PRINT_INIMIGO:
    la a0,enemy1_temp
    mv a1,s3
    mv a2,s4
    li a4,16
    li a6,0
    addi sp,sp,-4
    sw ra,0(sp)
    call PRINT_SPRITE
    lw ra,0(sp)
    addi sp,sp,4
    ret 



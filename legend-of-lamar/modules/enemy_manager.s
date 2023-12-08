.data 
.include "../assets/tiles/goblin.data"



inimigos_tela: .half 
300,112,160,1280,
525,208,144,0,
0,0,0,0,
0,0,0,0,
0,0,0,0,
0,0,0,0,
0,0,0,0,
0,0,0,0,
0,0,0,0,
0,0,0,0

walk_delay: .byte 120
# 0101 0000
.text

.macro inimigo_salva_pilha()
    addi sp,sp,-32
    sw ra,0(sp)
    sw s0,4(sp)
    sw s1,8(sp)
    sw s2,12(sp)
    sw s3,16(sp)
    sw s4,20(sp)
    sw s5,24(sp)
    sw s6,28(sp)
    
.end_macro

.macro inimigo_volta_pilha()
    lw ra,0(sp)
    lw s0,4(sp)
    lw s1,8(sp)
    lw s2,12(sp)
    lw s3,16(sp)
    lw s4,20(sp)
    lw s5,24(sp)
    lw s6,28(sp)
    addi sp,sp,32
.end_macro


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
   
    inimigo_salva_pilha()

    li s0,10    # iterador (nao vou usar agr)
    la s7,inimigos_tela
    lh t0,0(s7)
    slli s1,t0,8    # id
    andi s2,t0,0xff # vida
    lh s3,2(s7)     # x
    lh s4,4(s7)     # y
    lh t0,6(s7)
    slli s5,t0,8    # duracao frame de animacao
    andi s6,t0,0xff # frame atual da animacao |direcao que o guerreiro ta olhando 
    beq s1,zero,ENEMY_RET
    mv a1,s3
    mv a2,s4
    call PRINT_INIMIGO
    call COLISAO_INIMIGO
    call ENEMY_WALK
    
    
    
    # fazer aqui pro do id 1

    
    

ENEMY_RET:
    inimigo_volta_pilha()
    ret 


# , frame animacao, duracao direcao q ta olhano
ENEMY_WALK:
    la t0, walk_delay
    lb t1,0(t0)
    addi t1,t1,-1
    sb t1,0(t0)
    bgt t1,zero,ENEMY_RET
    li t1,120
    sb t1,0(t0)
    li a7,41
    ecall
    li t1,4
    rem a5,a0,t1 #direcao
    addi a5,a5,1
    addi a0,s7,2
    mv s0,a5
    call CHECK_COLISAO_INIMIGO
    bgt a4,zero ENEMY_RET

    li t0,1
    beq s0,t0,ENEMY_UP
    li t0,2
    beq s0,t0,ENEMY_LEFT
    li t0,3
    beq s0,t0,ENEMY_DOWN
#ENEMY_RIGHT
    addi s3,s3,16
    sh s3,2(s7)
    tail ENEMY_RET

ENEMY_UP:
    addi s4,s4,-16
    sh s4,4(s7)
    tail ENEMY_RET

ENEMY_LEFT:
    addi s3,s3,-16
    sh s3,2(s7)
    tail ENEMY_RET

ENEMY_DOWN:
    addi s4,s4,16
    sh s4,4(s7)
    tail ENEMY_RET  




GERA_DROP:
    csrr t0,time
    li t1,10
    rem t2,t0,t1
    li t1,6
    bgt t2,t1,ENEMY_RET
    li t1,3
    rem a0,t0,t1
    addi a0,a0,1
    mv a1,s3
    mv a2,s4
    CALL ADD_ITEM
    tail ENEMY_RET

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
# considerar direcao pra escolher sprite certa
# trem pro boss q e grandao

PRINT_INIMIGO:
 la a0,goblin
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

PRINT_INIMIGO_QUEBRADO:
    la a0,goblin
    srli s1,s1,2
    #add a0,a0,s1  # endereco do sprite do inimigo em relacao ao id
    lw a0,0(a0)
    #slli t0,s6,4 # frame atual da animacao (0 e 1)
    #andi t1,s6,0xf # direcao que o campeao ta olhando 
    #addi s5,s5,-1
    #sb s5,6(s7)
    #bne s5,zero,PRINT_INIMIGO_2
    #xori t0,t0,1 # inverte o frame
    #srli t0,t0,4
    #mv s6,t0
    #add s6,s6,t1 
    
PRINT_INIMIGO_2:
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

# a1 = x ataque 
# a2 = y ataque
# a3 = dano 
# TODO : adaptar para olhar todos os inimigos
CHECK_ENEMY_HIT:
    inimigo_salva_pilha()
    
    la s7,inimigos_tela
    lb s1,0(s7) # id
    lb s2,1(s7) # vida
    lh s3,2(s7) # x
    lh s4,4(s7) # y
    lb s5,6(s7) # duracao frame de animacao
    lb s6,7(s7) # direcao que o guerreiro ta olhando

    mv t1,s3    # x inimigo
    mv t2,s4    # y inimigo

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
    bne t3,zero,ENEMY_HIT
    tail ENEMY_RET
    
ENEMY_HIT:
    sub s2,s2,a3
    sb s2,1(s7)
    ble s2,zero,REMOVE_ENEMY
    tail ENEMY_RET


REMOVE_ENEMY:
    sw zero,0(s7)
    tail GERA_DROP

    

.data 
.include "../assets/tiles/goblin.data"
.include "..//assets/tiles/boss_temp.data"
sprite_inimigo: .word 
goblin,
0,
0,
0,
0,
0,
0,
boss_temp
# 0x0710,112,160,0,
# 0x010b,112,160,0x7806,
inimigos_tela: .half 
0x0710,112,160,0,
0,0,0,0,
0,0,0,0,
0,0,0,0, 
0,0,0,0,
0,0,0,0,
0,0,0,0,
0,0,0,0,
0,0,0,0,
0,0,0,0

walk_delay: .byte 
1

# 0101 0000
.text


.macro inimigo_salva_pilha()
    addi sp,sp,-36
    sw ra,0(sp)
    sw s0,4(sp)
    sw s1,8(sp)
    sw s2,12(sp)
    sw s3,16(sp)
    sw s4,20(sp)
    sw s5,24(sp)
    sw s6,28(sp)
    sw s8,32(sp)
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
    lw s8,32(sp)
    addi sp,sp,36
.end_macro

.macro load_enemy(%enemy_address)
    lh t0,0(%enemy_address) # s1/s2+
    srli s1,t0,8    # id
    andi s2,t0,0xff # vida
    lh s3,2(%enemy_address)     # x
    lh s4,4(%enemy_address)     # y
    lh t0,6(%enemy_address)     # s5/s6
    srli s5,t0,8    # duracao frame de animacao 
    andi s6,t0,0xff # frame atual da animacao |direcao que o guerreiro ta olhando 

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
ENEMY_MANAGER_LOOP:
    # s1 = id, s2 = vida, s3 = x s4 = y s5 = duracao frame s6 = frame atual|direcao q o homi ta de olho
    load_enemy(s7)

    beq s1,zero,ENEMY_MANAGER_LOOPER
    mv a1,s3
    mv a2,s4
    call PRINT_INIMIGO
    call COLISAO_INIMIGO
    call ENEMY_WALK
    
ENEMY_MANAGER_LOOPER:
    addi s7,s7,8
    addi s0,s0,-1
    bgt s0,zero,ENEMY_MANAGER_LOOP
    

ENEMY_RET:
    inimigo_volta_pilha()
    ret 


# , frame animacao, duracao direcao q ta olhano
ENEMY_WALK:
    addi s5,s5,-1
    
    bne s5,zero,ENEMY_MOVE_END
    #la t0,walk_delay
    #addi t1,t1,-1
    #slli t1,t1,2
    #add t0,t0,t1
    li s5,30

    li a7,41
    ecall
    # numero
    li t1,4
    rem a5,a0,t1
    addi a5,a5,1  #direcao

    addi a0,s7,2
    mv s8,a5            # S0 JA E O CONTADOR, TEM Q MUDAR QUANDO FOR TER LOOP
    call CHECK_COLISAO_INIMIGO
    bgt a4,zero ENEMY_MOVE_END

    srli t1,s6,4    # frame
    andi t1,s6,0xf  # dir

    li t0,1
    beq s8,t0,ENEMY_UP
    li t0,2
    beq s8,t0,ENEMY_LEFT
    li t0,3
    beq s8,t0,ENEMY_DOWN
#ENEMY_RIGHT
    addi s3,s3,16
    sh s3,2(s7)

    li t0,3 
    srli t1,s6,1
    bne t1,t0,ENEMY_ENEMY_RIGHT_0
    xori s6,s6,1 # caso ja esteja pra direita muda o frame so
    tail ENEMY_MOVE_END
ENEMY_ENEMY_RIGHT_0:
    li s6,6
    tail ENEMY_MOVE_END
ENEMY_UP:
    addi s4,s4,-16
    sh s4,4(s7)
    
    li t0,0
    srli t1,s6,1
    bne t1,t0,ENEMY_ENEMY_UP_0
    xori s6,s6,1 # caso ja esteja pra direita muda o frame so
    tail ENEMY_MOVE_END
ENEMY_ENEMY_UP_0:
    li s6,0
    tail ENEMY_MOVE_END

ENEMY_LEFT:
    addi s3,s3,-16
    sh s3,2(s7)
    
    li t0,2
    srli t1,s6,1
    bne t1,t0,ENEMY_ENEMY_LEFT_0
    xori s6,s6,1 # caso ja esteja pra direita muda o frame so
    tail ENEMY_MOVE_END
ENEMY_ENEMY_LEFT_0:
    li s6,4
    tail ENEMY_MOVE_END

ENEMY_DOWN:
    addi s4,s4,16
    sh s4,4(s7)

    li t0,1
    srli t1,s6,1
    bne t1,t0,ENEMY_ENEMY_DOWN_0
    xori s6,s6,1 # caso ja esteja pra direita muda o frame so
    tail ENEMY_MOVE_END
ENEMY_ENEMY_DOWN_0:
    li s6,2
    

ENEMY_MOVE_END:
    slli t4,s5,8
    add t4,t4,s6
    sh t4,6(s7)
    b ENEMY_MANAGER_LOOPER



# TODO
# muda o ret para continuar o loop agr meu rei
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
    li t0,7
    li a0,16
    bne s1,t0,COLISAO_INIMIGO_2
    addi a0,a0,16
COLISAO_INIMIGO_2:
	la t0,link_pos
	lh t1,0(t0)
	lh t2,2(t0)
	addi t0,t1,16
	slt t3, a1,t0 # item.x < link.x + link.w
	add t0,a1,a0
	slt t4,t1,t0  # link.x < item.x + item.w
	and t3,t3,t4  # ja faz o and dos dois pra liberar o t4
	addi t0,t2,16
	slt t4,a2,t0  # item.y < link.y + link.h
	and t3,t3,t4  # libera t4 ja
	add t0,a2,a0
	slt t4,t2,t0  # link.t < item.y + item.h
	and t3,t3,t4
	
	bne t3,zero,ENEMY_HIT_LINK_CHECK
	ret
   
# TODO 
# considerar direcao pra escolher sprite certa
# trem pro boss q e grandao

PRINT_INIMIGO:
    li t0,7
    li a4,16
    la a0,sprite_inimigo
    slli t1,s1,2 # id*4 
    add a0,a0,t1
    lw a0,0(a0)
    mv a6,s6
    bne s1,t0,PRINT_INIMIGO_2
# MUDANCAS DO PRINT PRO BOSS

    addi a4,a4,16 
    li a6,0 #eventualmente isso aqui vai mudar, mas so durante o ataque do homem
PRINT_INIMIGO_2:
   
    
    mv a1,s3
    mv a2,s4
    # pega o frame do s6 e bota no a6
    
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
    li s0,10
    la s7,inimigos_tela
CHECK_ENEMY_HIT_LOOP:  
    # s1 = id, s2 = vida, s3 = x s4 = y s5 = duracao frame s6 = frame atual|direcao q o homi ta de olho
    load_enemy(s7) 
    
    mv t1,s3    # x inimigo
    mv t2,s4    # y inimigo
    li t0,7
    li a0,16
    bne t0,s1,CHECK_ENEMY_HIT_LOOP_2
    addi a0,a0,16 # tamanho do boss
CHECK_ENEMY_HIT_LOOP_2:
    add t0,t1,a0
	slt t3, a1,t0 # item.x < link.x + link.w
	addi t0,a1,16
	slt t4,t1,t0  # link.x < item.x + item.w
	and t3,t3,t4  # ja faz o and dos dois pra liberar o t4
	add t0,t2,a0
	slt t4,a2,t0  # item.y < link.y + link.h
	and t3,t3,t4  
	addi t0,a2,16
	slt t4,t2,t0  # link.t < item.y + item.h
	and t3,t3,t4
    bne t3,zero,ENEMY_HIT
CHECK_ENEMY_HIT_LOOPER:  
    addi s7,s7,8
    addi s0,s0,-1
    bgt s0,zero,CHECK_ENEMY_HIT_LOOP
    tail ENEMY_RET
ENEMY_HIT:
    sub s2,s2,a3
    slli t0,s1,8
    add t0,t0,s2    # por algum motivo usar byte simplesmente nao funciona
    sh t0,0(s7)
    ble s2,zero,REMOVE_ENEMY
    tail ENEMY_RET


REMOVE_ENEMY:
    sw zero,0(s7)
    tail GERA_DROP

    















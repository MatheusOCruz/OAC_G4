.data
.include "../assets/tiles/goblin.data"
.include "..//assets/tiles/boss.data"
.include "../assets/tiles/fogo.data"

.text
#pra modificar os itens é so mexer no arquivo lista_itens.s em assets
#cada linha representa um item com 5 propriedades(a quinta nem ta usando, depois eu tiro)
#a cada 5 linhas é uma tela(por enquanto so tem como ter 5 itens por tela)
#primeiro byte: define qual item printa, -1 = nao printa
#segundo: indica o que acontece quando colide
#terceiro e quarto: posicao (x,y). vai de (0,4) até (19,14) 
############## pra facilitar o codigo o boss fica sempre na 9. se tiver um boss na tela atual, a 10 posiçao é usada pra fazer a bola de fogo
.macro salva_pilha()
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

.macro volta_pilha()
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

.macro salva_pilha_colisao()
	addi sp,sp,-32,
	sw ra,0(sp),
	sw a1,4(sp),
	sw a5,8(sp),
	sw s3,12(sp),
	sw s5,16(sp),
	sw s7,20(sp),
	sw s2,24(sp),
	sw s4,28(sp)
.end_macro

.macro volta_pilha_colisao()
	lw ra,0(sp),
	lw a1,4(sp),
	lw a5,8(sp),
	lw s3,12(sp),
	lw s5,16(sp),
	lw s7,20(sp),
	lw s2,24(sp),
	lw s4,28(sp),
	addi sp,sp,32
.end_macro
	
ENTIDADES:	

	salva_pilha()
	la t0,anim_frame	#qual parte da animaçao fazer
	lw s4,0(t0)	 #frame atual
	lw s5,4(t0)	#tempo da ultima animaçao
	csrr s11,time	#atualiza tempo atual
	sub t1,s11,s5	#diferença de tempo
	li t2,500	#delay da animaçao
	li s10,1	#valor salvo pra editar a animaçao
	blt t1,t2,NAO_ANIMA_ITEM
	li s10,0	#modifica o valor caso deva animar
	xori s4,s4,1	#muda o frame
	sw s4,0(t0)
	sw s11,4(t0)
	
	
	
NAO_ANIMA_ITEM:	

	la t0,lista_itens	#.data com as informaçoes de cada item por tela
	addi t0,t0,8		#pula dados
	la t1,map_location	#mapa atual
	lb t2,0(t1)	#pos x
	lb t3,1(t1)	#pos y
	li t4,3			#mapas por linha
	mul t3,t3,t4
	add t2,t2,t3		#calcula a posiçao atual
	li t4,50		#qtd de bytes por mapa
	mul s2,t2,t4
	add s2,s2,t0		
	li s1,10		#contador
	
LOOP_ITEM:
	
	lb t0,0(s2)		#pega id do item
	blt t0,zero,PROXIMO_ITEM	#se for -1 passa pro proximo
	
	lb t1,1(s2)		#pega tipo de item
	lb a1,2(s2)		#pos x
	lb a2,3(s2)		#pos y
	
	mv s7,t1		#salva o tipo em s7 pra determinar açoes depois
	la a0,itens1		#endereço do bitmap dos itens
	mv a3,s0		#frame atual
	li a4,16		#tamanho
	li a5,16
	mv a6,t0		#id
	
	
	addi t1,t1,-3		#checa se é algum inimigo
	beq t1,zero,GOBLIN
	addi t1,t1,-1
	beq t1,zero,LINEL
	addi t1,t1,-1
	beq t1,zero,WARRIOR
	addi t1,t1,-1
	beq t1,zero,BOSS
	addi t1,t1,-1
	beq t1,zero,FOGO0

	la t0,link_pos		#se nao for inimigo testa a colisao do coletavel
	lh t1,0(t0)		#x do link
	lh t2,2(t0)		#y
	slli a1,a1,4
	slli a2,a2,4
	
	blt t1,a1,X_MENOR	#faz uma subtraçao com modulo(x do link - x do item, mas nao pode ser negativo, entao inverte caso de < 0)
	sub t1,t1,a1
X_VOLTA:
	blt t2,a2,Y_MENOR
	sub t2,t2,a2
Y_VOLTA:
	
	la t0,pos_offset	#testa se o link ta entre 2 quadrados
	lb t3,0(t0)
	lb t4,1(t0)
	srli t3,t3,3
	srli t4,t4,3
	add t1,t1,t2		#calcula a diferença de posiçao total
	sub t1,t1,t3		#tira o offset
	sub t1,t1,t4
	li t2,16
	bge t1,t2,NAO_COLIDE0	#se a diferença for > 16 nao colide
	
	la t0,link_moedas 	#caso colida decide qual item ta coletando
	beq s7,zero,PULA
	
	la t0,link_cafezin
	addi s7,s7,-1
	beq s7,zero,PULA
	
	la t0,link_espada
	addi s7,s7,-1
	beq s7,zero,PULA
	
	
PULA:				#remove o item da tela e adiciona no valor do item coletado
	
	lh t1,0(t0)
	addi t1,t1,1
	sh t1,0(t0)
	li t2,-1
	sb t2,0(s2)
NAO_COLIDE0:
	srli a1,a1,4
	srli a2,a2,4	
NAO_COLIDE:
	srli a6,a6,4		#
	srli a4,a4,4
	mul s4,s4,a4
	slli a4,a4,4
	add a6,a6,s4		#divide id por 16 e soma o frame da animaçao pra pegar a posiçao do sprite dentro do arquivo
	slli a1,a1,4
	slli a2,a2,4
	call PRINT_SPRITE	#printa o item na tela

PROXIMO_ITEM:			#passa pro proximo item
	addi s1,s1,-1
	beq s1,zero,END_ITEM	#se tiver feito todos termina a funçao
	addi s2,s2,5

	b LOOP_ITEM

END_ITEM:

	volta_pilha()
	ret

X_MENOR:
	sub t1,a1,t1
	b X_VOLTA

Y_MENOR:
	sub t2,a2,t2
	b Y_VOLTA
	
GOBLIN:
	la a0,goblin
	b INIMIGO
	
LINEL:
	la a0,linel
	b INIMIGO
	
WARRIOR:
	la a0,warrior
	
	
INIMIGO:
	li t0,1
	beq s10,t0,NAO_COLIDE
	
	addi sp,sp,-4
	sw ra,0(sp)
	call CHECK_DANO
	lw ra,0(sp)
	addi sp,sp,4


	addi sp,sp,-4
	sw a0,0(sp)
	
	li a7,41
	ecall
	li t0,4
	remu t0,a0,t0
	
	lw a0,0(sp)
	addi sp,sp,4

	beq t0,zero,INIMIGO_CIMA
	li t1,1
	beq t0,t1,INIMIGO_ESQ
	li t1,2
	beq t0,t1,INIMIGO_BAIX
	li t1,3
	beq t0,t1,INIMIGO_DIR

FOGO0:
	tail FOGO
	
INIMIGO_CIMA:

	salva_pilha_colisao()
	li a5,1
	mv s3,a1
	mv s4,a2
	call CHECK_COLISAO_INIMIGO
	volta_pilha_colisao()
	beq a7,zero,NAO_COLIDE
	
	sb zero,0(s2)
	addi a2,a2,-1
	sb a2,3(s2)
	

	
	b NAO_COLIDE
	
INIMIGO_ESQ:
	
	salva_pilha_colisao()
	li a5,2
	mv s3,a1
	mv s4,a2
	call CHECK_COLISAO_INIMIGO
	volta_pilha_colisao()
	beq a7,zero,NAO_COLIDE
	
	addi a6,zero,32
	sb a6,0(s2)
	
	addi a1,a1,-1
	sb a1,2(s2)

	b NAO_COLIDE
	
INIMIGO_BAIX:
	
	salva_pilha_colisao()
	li a5,3
	mv s3,a1
	mv s4,a2
	call CHECK_COLISAO_INIMIGO
	volta_pilha_colisao()
	beq a7,zero,NAO_COLIDE
	
	addi a6,zero,64
	sb a6,0(s2)
	addi a2,a2,1
	sb a2,3(s2)
	
	b NAO_COLIDE
	
INIMIGO_DIR:
	
	salva_pilha_colisao()
	li a5,4
	mv s3,a1
	mv s4,a2
	call CHECK_COLISAO_INIMIGO
	volta_pilha_colisao()
	beq a7,zero,NAO_COLIDE
	
	addi a6,zero,96
	sb a6,0(s2)
	addi a1,a1,1
	sb a1,2(s2)

	b NAO_COLIDE

BOSS:	
	li a7,41
	ecall
	li t0,3
	rem t0,a0,t0
	
	la a0,boss
	li a4,32
	li a5,32
	
	li t1,1
	beq s10,t1,NAO_COLIDE
	
	addi sp,sp,-8
	sw t0,0(sp)
	sw ra,4(sp)
	
	call CHECK_DANO_BOSS
	
	lw ra,4(sp)
	lw t0,0(sp)
	addi sp,sp,8
	
	beq t0,zero,BOSS_CIMA
	addi t0,t0,-1
	beq t0,zero,BOSS_BAIXO
	addi t0,t0,-1
	beq t0,zero,BOSS_COSPE
	
BOSS_CIMA:

	salva_pilha_colisao()
	li a5,1
	mv s3,a1
	mv s4,a2
	call CHECK_COLISAO_INIMIGO
	volta_pilha_colisao()
	beq a7,zero,NAO_COLIDE
	
	addi a2,a2,-1
	sb a2,3(s2)
	
	b NAO_COLIDE

BOSS_BAIXO:
	salva_pilha_colisao()
	li a5,3
	mv s3,a1
	mv s4,a2
	call CHECK_COLISAO_INIMIGO
	volta_pilha_colisao()
	
	beq a7,zero,NAO_COLIDE
	addi a2,a2,1
	sb a2,3(s2)
BOSS_COSPE:	
	
	la t0,fogo_bool
	lb t1,0(t0)
	bne t1,zero,NAO_COLIDE
	
	li t1,1
	sb t1,0(t0)
	sb zero,5(s2)
	li t1,7
	sb t1,6(s2)
	addi t1,a1,2
	sb a1,7(s2)
	sb a2,8(s2)
	li t1,20
	sb t1,9(s2)

	b NAO_COLIDE
	
FOGO:	
	srli s4,s4,1
	la a0,fogo
	li t0,1
	beq s10,t0,NAO_COLIDE
	
	addi a1,a1,1
	sb a1,2(s2)
	

	addi sp,sp,-4
	sw ra,0(sp)
	call CHECK_DANO
	lw ra,0(sp)
	addi sp,sp,4
	
	
	li t0,19
	sb zero,0(s2)
	la a0,fogo

	blt a1,t0,NAO_COLIDE
	
	li t1,-1
	sb t1,0(s2)
	
	la t0,fogo_bool
	sb zero,0(t0)

	tail NAO_COLIDE

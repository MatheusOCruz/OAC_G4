.text
#pra modificar os itens é so mexer no arquivo lista_itens.s em assets
#cada linha representa um item com 5 propriedades(a quinta nem ta usando, depois eu tiro)
#a cada 5 linhas é uma tela(por enquanto so tem como ter 5 itens por tela)
#primeiro byte: define qual item printa, -1 = nao printa
#segundo: indica o que acontece quando colide
#terceiro e quarto: posicao (x,y). vai de (0,4) até (19,14) 
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

ITENS:	

	salva_pilha()
	la t0,anim_frame
	lw s4,0(t0)	 #frame atual
	lw s5,4(t0)
	csrr s11,time
	sub t1,s11,s5	#diferença de tempo
	li t2,200
	blt t1,t2,NAO_ANIMA_ITEM
	xori s4,s4,1
	sw s4,0(t0)
	sw s11,4(t0)
	
	
	
NAO_ANIMA_ITEM:	

	la t0,lista_itens
	addi t0,t0,8
	la t1,map_location
	lb t2,0(t1)	#pos x
	lb t3,1(t1)	#pos y
	li t4,3
	mul t3,t3,t4
	add t2,t2,t3
	li t4,25
	mul s2,t2,t4
	add s2,s2,t0
	li s1,5
	
LOOP_ITEM:	
	lb t0,0(s2)
	blt t0,zero,PROXIMO_ITEM
	lb t1,1(s2)
	lb t2,2(s2)
	lb t3,3(s2)
	
	mv s7,t1
	la a0,itens1
	slli a1,t2,4
	slli a2,t3,4
	mv a3,s0
	li a4,16
	li a5,16
	mv a6,t0
	srli a6,a6,4
	add a6,a6,s4
	
	la t0,link_pos
	lh t1,0(t0)
	lh t2,2(t0)
	
	blt t1,a1,X_MENOR
	sub t1,t1,a1
X_VOLTA:
	blt t2,a2,Y_MENOR
	sub t2,t2,a2
Y_VOLTA:
	
	la t0,pos_offset
	lb t3,0(t0)
	lb t4,1(t0)
	srli t3,t3,3
	srli t4,t4,3
	
	add t1,t1,t2
	sub t1,t1,t3
	sub t1,t1,t4
	li t2,16
	bge t1,t2,NAO_COLETA
	
	la t0,link_moedas
	beq s7,zero,PULA
	
	la t0,link_cafezin
	addi s7,s7,-1
	beq s7,zero,PULA
	
	la t0,link_espada
	addi s7,s7,-1
	beq s7,zero,PULA
	
PULA:	
	lh t1,0(t0)
	addi t1,t1,1
	sh t1,0(t0)
	li t2,-1
	sb t2,0(s2)
	
NAO_COLETA:
	call PRINT_SPRITE

PROXIMO_ITEM:
	addi s1,s1,-1
	beq s1,zero,END_ITEM
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

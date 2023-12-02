.data
.include "../assets/tiles/items_temp.data"


items_tela:.half
	 0,
	 0,0,
	 0,
	 0,0,
	 0,
	 0,0,
	 0,
	 0,0,
	 0,
	 0,0,
	 0,
	 0,0,
	 0,
	 0,0,
	 0,
	 0,0,
	 0,
	 0,0,
	 0,
	 0,0,



.text


#   			TODO
#   provavelmente vou mudar pra olhas as 10 posicoes independente de contador (remover contador)
#   quando pega item salva tudo 0 e libera a posicao
#   mais facil pra gerenciar os trem dps 

# ################################
#    "struct" do item na pilha
# ################################
#	0 - id
#	1 - x
#	2 - y
# ################################

ITEM_MANAGER:
	mv a3,s0 #frame
	addi sp,sp,-8
	sw ra,0(sp)
	sw s0,4(sp)
	la a0,items_temp 
	la t0,items_tela
	mv s0,t0   # futuramente usar pra saber qual item atual pra limpar no pickup
	lh a1,2(t0)
	lh a2,4(t0)
	li a4,16
	lh a6,0(t0)
	beq a6,zero ITEM_RET
	addi a6,a6,-1
	call COLISAO_ITEM
	
	call PRINT_SPRITE
	

ITEM_RET:
	lw ra,0(sp)
	lw s0,4(sp)
	addi sp,sp,8
	ret
	
#	TODO
#   1 - adicionar na proxima posicao livre
#   2 - verificar se ja tem 10 	
#   3 - gerenciar adicao de itens em caso de ja terem sido usadas as 10 posicoes e algum foi pego

ADD_ITEM:

	la t0,item_counter
	lb t1,0(t0)
	li t2,6
	mul t2,t2,t1	# deslocamento pra proxima posicao livre
	la t3,items_tela
	add t3,t3,t2
	sh a0,0(t3)
	sh a1,2(t3)
	sh a2,4(t3)
	addi t1,t1,1
	sb t1,0(t0)
	ret
	


CLEAR_ITEMS:
	la t0,item_counter
	sb zero,0(t0)
	li t1,10
	la t2, items_tela
CLEAR_ITEMS_LOOP:
	sh zero,0(t2)
	sh zero,2(t2)
	sh zero,4(t2)
	addi t2,t2,6
	addi t1,t1,-1
	bgt t1,zero,CLEAR_ITEMS_LOOP
	ret
	





# a1 x a2 y tamanho == 16x16

COLISAO_ITEM:
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
	
	bne t3,zero,PEGA_ITEM
	ret
	
	
	

PEGA_ITEM:
	la t0,arma_a
	li t1,4
	sb t1,0(t0)
	sh zero,0(s0)
	sh zero,2(s0)
	sh zero,4(s0)
	ret










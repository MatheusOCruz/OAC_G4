.text
ITEM:
	la t3,map_location
	lb t0,1(t3)
	addi t0,t0,-3
	li t6,0
	bgt t0,zero,DG
	
VOLTA_DG:	

	li t3,16
	beq a7,t3,COLETA_MOEDA  #define o item que vai coletar
	li t3,17
	beq a7,t3,COLETA_MOEDA
	li t3,18
	beq a7,t3,CAFE
	li t3,19
	beq a7,t3,CAFE
	
	ret
	
COLETA_MOEDA:

	la t0,pos_offset	#essa parte do codigo evita bugs ja q ele anda de 8 em nao nao 16
	lb t1,1(t0)		#indica se tem ou nao o offset de 8 horizontal
	srli t1,t1,3		#passa a informaçao pro primeiro bit pra usar como se fosse uma mascara
	li t4,16		#usando 15 pq todos os coletaveis tem indice maior q 16
	addi s10,s10,59		#posiçao do quadrado 1 fileira pra baixo e esquerda do link
	lb t5,0(s10)		#oq tem nesse quadrado
	slt t2,t5,t4		#testa se t5<16
	addi t5,t5,-1
	slt t5,zero,t5		#testa se t5>1
	and t5,t5,t2
	
	slt t2,a7,t4	
	and t2,t2,a4
	
	or t5,t2,t5
	and a4,t1,t5
	
	bgt a4,zero,END_ITEM 	#basicamente evita qum bug q deixava andar par dentro do terreno se tivesse coletavel do lado
	
	la t0,link_moedas	#incrementa as moedas
	lh t1,0(t0)
	addi t1,t1,10
	sh t1,0(t0)
	
	li a4,0			#tira a moeda do mapa e permite q ele ande
	sb t6,0(s5)
	
	ret

CAFE:				#literamente igual a moeda so q com cafe

	la t0,pos_offset
	lb t1,1(t0)
	srli t1,t1,3
	li t4,13
	addi s10,s10,59
	lb t5,0(s10)
	slt t4,t5,t4
	slt t5,zero,t5
	
	and t2,t1,t4
	and t2,t2,t5
	
	bgt t2,zero,END_ITEM
	
	la t0,link_cafezin
	lh t1,0(t0)
	addi t1,t1,1
	sh t1,0(t0)
	
	li a4,0
	sb t6,0(s5)
	
	li a4,0
	ret

END_ITEM:
	ret

DG:
	li t6,13
	b VOLTA_DG

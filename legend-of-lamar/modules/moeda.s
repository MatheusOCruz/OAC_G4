.text
ITEM:
	
	li t3,13
	beq a7,t3,COLETA_MOEDA  #define o item que vai coletar
	li t3,14
	beq a7,t3,COLETA_MOEDA
	li t3,15
	beq a7,t3,CAFE
	li t3,16
	beq a7,t3,CAFE
	
	ret
	
COLETA_MOEDA:

	la t0,pos_offset	#essa parte do codigo evita bugs ja q ele anda de 8 em nao nao 16
	lb t1,1(t0)		#indica se tem ou nao o offset de 8
	srli t1,t1,3		#passa a informaçao pro primeiro bit pra usar como se fosse uma mascara
	li t4,13		#usando 13 pq todos os coletaveis tem indice maior q 13
	addi s10,s10,59		#posiçao do quadrado 1 fileira pra baixo e esquerda do link
	lb t5,0(s10)		#oq tem nesse quadrado
	slt t4,t5,t4		#testa se 0<t5<13
	slt t5,zero,t5
	
	and t2,t1,t4		#testa todas as condiçoes 
	and t2,t2,t5		
	
	bgt t2,zero,END_ITEM 	#basicamente evita qum bug q deixava andar par dentro do terreno se tivesse coletavel do lado
	
	la t0,link_moedas	#incrementa as moedas
	lh t1,0(t0)
	addi t1,t1,10
	sh t1,0(t0)
	
	li a4,0			#tira a moeda do mapa e permite q ele ande
	sb zero,0(s5)
	
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
	sb zero,0(s5)
	
	li a4,0
	ret

END_ITEM:
	ret

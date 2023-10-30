EXPLOSAO:
	csrr s7,time  #s7 = tempo inicial da animação
	
	li a7,148
	li a0,0		#limpa a frame
	li a1,0
	ecall
	
	la t0,nave_posx
	lw a5,0(t0)  
	slli a5,a5,2  #x da nave
	
	lw a2,4(t0)  
	li t1,320
	mul a2,a2,t1  #y da nave
	
	li a4, 150  #cor
	
	li s1,4 #espaço entre colunas
	li s2, 640 #espaço entre linhas
	
	li a6,3 #numero de frames
	
	li s3,3
	mv t2,a2
	
ANIM:
	mv t1,a5
	jal ANIM_PRINT  
	add t1,t1,s1
	jal ANIM_PRINT
	add t1,t1,s1
	jal ANIM_PRINT   #printa cada um dos 3 pixeis da linha atual
	
	add t2,t2,s2   #passa pra proxima linha
	addi s3,s3,-1  #contador
	bge s3,zero,ANIM  
	
	li s3,3  #reseta contador 
	mv t2,a2 #reseta posiçao inicial
	
	slli s1,s1,1  #aumenta o tamanho da bagui
	slli s2,s2,1
	

	
	addi a6,a6,-1   #mais contador
TIME:
	csrr t5,time #tempo da animaçao
	li t4,500   #se quiser mudar a duraçao dos frames muda aqui
	sub t5,t5,s7    #t5 = tempo decorrido
	blt t5,t4,TIME
	
	csrr s7,time
	
	li a7,148
	li a0,0		#limpa a frame
	li a1,0
	ecall
	
	bge a6,zero,ANIM  #proximo frame
	b END_ANIMAÇAO
		
ANIM_PRINT:
	li t0,0xFF000000
	
	add t0,t0,t1 #adiciona x
	add t0,t0,t2 #adiciona y
	sb a4,0(t0)  #printa na tela
	ret

END_ANIMAÇAO:
	j NAVE_SETUP

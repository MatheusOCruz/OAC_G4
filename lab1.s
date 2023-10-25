.data
PI: .float 3.141592
G: .float 9.81    
sencos45: .float 0.7071 # angulo fixo pra teste

ba: .string "\n"

.text 

# valores fixos so pra testar essa joca
# V0 = 50
# angle = 45
#s0 = angle
#s1 = velocity

# fs0 Vx
# fs1 Vy
# 320 x 240
# s10 = frame
# por enquanto incia em 0 x 240

#
#
#fs11 tempo de frame



MAIN:
	li s0, 45	#ang inicial
	li s1, 50	#vel inicial
	
	#call get_input  como so lanca dps de precionar e input com hold
	call GET_INPUT
	
	fcvt.s.w ft0, s0
	
	# convente pra rad pra calc sen (n precisa agr)
	
	la t0, sencos45
	
	flw ft0, 0(t0)
	
	fcvt.s.w ft1, s1 # V0
	fmul.s fs0, ft1, ft0 # Vx
	fmv.s fs1, fs0      #    nesse caso os dois sao iguas ent ta valendo   Vy
	li s10,0
	
	# tempo de 1 frame
	li t0, 1
	li t1, 120
	fcvt.s.w ft0, t0 
	fcvt.s.w ft1, t1 
	fdiv.s fs11, ft0, ft1   
	
	li s3,0   # x na tela
	li s4,230 # y na tela
	
	fcvt.s.w fs3, s3  # x flufu
	fcvt.s.w fs4, s4  # y flufu
	
	
	la t0,G
	
	flw fs7, 0(t0)        # G
	
	csrr s11, time 	
	
	
MAIN_LOOP:
	# mantem o jogo em 60 frames 
	li t0, 8
	
	csrr t1, time
	sub t1,t1,s11
	
	ble t1,t0, MAIN_LOOP # caso o codigo seja todo executado mais rapido q a duracao do frame
	
	csrr s11, time

	xori s10,s10,1 
	mv a3, s10
	call TELA_BRANCA
	
	fcvt.w.s a0, fs3  # x 
	fcvt.w.s a1, fs4  # y 
	
	call PRINT_TRECO		# fs0 e Vx e fs1 e Vy
	

	# fs0 xv fs1 vy
	# fs7 grav fs11 delta_t
	# y
	
	fmul.s ft0,fs7,fs11  #  ft0 = g*delta_t
	fsub.s fs1,fs1,ft0   # vy -= ft0
	
	fmul.s ft0,fs1,fs11  # ft0 = vy*delta_t
	fsub.s fs4,fs4,ft0   # y += ft0
	
	
	fmul.s ft0,fs0,fs11  # ft0 = vx*delta_t
	
	fadd.s fs3, fs3, ft0 # x +=ft0
	
	
	
	li t0,0xFF200604 # endereco para mudar frame
	sw s10,0(t0) 
	
	
	

	
	
	j MAIN_LOOP
	
	



TELA_BRANCA:
	#carrega endereco base do bitmap + frame
	li  t0, 0xFF0 
	add t0,t0,a3 
	slli t0,t0,20 	# endereco final 
	li t1, 0x12C00
	add t1,t1,t0	
	
	li t3,0xFFFFFFFF	# cor vermelho|vermelho|vermelhor|vermelho
LOOP: 	beq t0,t1,FORA		# Se for o último endereço então sai do loop
	sw t3,0(t0)		# escreve a word na memória VGA
	addi t0,t0,4		# soma 4 ao endereço
	j LOOP			# volta a verificar
FORA:
	ret
	



# a0 = x
# a1 = y

PRINT_TRECO:

	li  t0, 0xFF0 
	add t0,t0,a3 
	slli t0,t0,20 
	#endereco inicial do print
	add t0,t0,a0   # adiciona x
	
	li t1, 320
	mul t1,a1,t1
	add t0,t0,t1  # adiciona y

	li t3,0	     # preto
	sb t3,0(t0)
	ret


GET_INPUT:

 	li t1,0xFF200000		# carrega o endereço de controle do KDMMIO
LOOP_INPUT: 	
	# print angle
	mv a0,s0   
	li a7,1
	ecall
	# print vel
	mv a0,s1
	ecall
	# pula linha
	la a0,ba
	li a7,4
	ecall
WAIT_INPUT:
	lw t0,0(t1)			# Le bit de Controle Teclado
   	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,WAIT_INPUT 		# não tem tecla pressionada então volta ao loop
   	lw t2,4(t1)			# le o valor da tecla
  	li t3, 'w'
  	beq t2,t3,UP_CANHAO
  	li t3,'s'
  	beq t2,t3, DOWN_CANHAO
  	
  	li t3, 'q'
  	beq t2,t3, V_AUMENTA
  	li t3,'a'
  	beq t2,t3 V_DIMINUI
  	
	ret   				# por enquanto qualquer outro input e retorno
# s0 = angle
# s1 = vel
UP_CANHAO:

	li t4, 90
	beq s0,t4, LOOP_INPUT
	addi s0,s0,1
	b LOOP_INPUT
	
DOWN_CANHAO:

	beq s0,zero, LOOP_INPUT
	addi s0,s0,-1
	b LOOP_INPUT
	

V_AUMENTA:
	li t4,255
	beq s1,t4, LOOP_INPUT
	addi s1,s1,1
	b LOOP_INPUT

V_DIMINUI:
	
	beq s1,zero, LOOP_INPUT
	addi s1,s1,-1
	b LOOP_INPUT
	



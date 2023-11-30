.data

.include "seno.data"
angulo: .byte 48
velocidade: .word 100
G: .float 4.905
nave_posx: .word 0,0 #x/y
teste: .string "\n"



.include "MACROSv21.s"

.text 
j MAIN

.include "animaçao.s"

.text
MAIN:	
	li s0,0  #frame atual

NAVE_SETUP:
	la t1,nave_posx
	
	li a7, 41
	li a0,0
	li a1, 160  #pega numero aleatorio
	ecall
	srli a0,a0,24
	bgt a0,a1,NAVE_SETUP
	blt a0,zero,NAVE_SETUP
	sw a0,4(t1)
	
REDO:
	li a0,0
	li a1,260
	ecall
	srli a0,a0,24
	bgt a0,a1,REDO
	blt a0,zero,REDO
	sw a0,0(t1)
	
LOOP:
	jal CHECK_INPUT  #faz a parte dos inputs
	jal PRINT_LINE_DATA
	jal PRINT_NAVE_SETUP
	b LOOP
	

PRINT_NAVE_SETUP:
	la t0,nave_posx  #pegando os dados que precisa pra printar a nave
	lw t1,4(t0)   #y da nave
	lw t2,0(t0)   #x da nave
	li t3,320
	mul t1,t1,t3  #pula y linhas
	add t1,t1,t2
	li a2,0xff000000  #memoria inicial do display
	add a2,a2,t1   #a2= posição da nave
	
	
	mv t5,s0
	slli t5,t5,20
	add a2,a2,t5
	
	addi a3,a2,643  #fim d
	
	li a1,3
	li a4,0
	li t0,150  #cor
	
PRINT_NAVE: #a0 = endereço nave,a1 = largura nave, a2 = posição inicial no display, a3 = posição final no display, a4 = contador

	sb t0,0(a2)
	addi a0,a0,1
	addi a2,a2,1
	addi a4,a4,1
	bge a2,a3,END_NAVE
	beq a4,a1,PULA_LINHA
	b PRINT_NAVE

PULA_LINHA:
	addi a2,a2,317  #passa pra proxima linha
	li a4,0
	b PRINT_NAVE
	
END_NAVE:
	ret
	
	

CHECK_INPUT:
	li s1,0xFF200000  #endereço da memoria do teclado
	lw t0,0(s1)		
	andi t0,t0,0x0001 	#mascara o bit menos significativo
   	beq t0,zero,NO_INPUT   #pega os inputs
   	
   	mv s11,ra
   	jal LIMPA 
   	mv ra,s11
   	
  	lw t2,4(s1)			
  	li t0,'w'
  	beq t2,t0,CIMA
	li t0,'q'
	beq t2,t0,FORTE
	li t0,'s'
	beq t0,t2,BAIXO
	li t0,'a'
	beq t2,t0,FRACO
	li t0,32
	beq t2,t0,TIRO_PREP
	ret
	
CIMA:
	la t0,angulo  #mira pra cima(aumenta angulo)
	lb t2,0(t0)
	li t1,90
	beq t1,t2,LOOP
	addi t2,t2,1
	sb t2,0(t0)
	li a2,32
	ret

BAIXO:
	la t0,angulo  #mira pra baixo
	lb t2,0(t0)
	beq zero,t2,LOOP
	addi t2,t2,-1
	sb t2,0(t0)
	li a2,32
	ret

FORTE:
	la t0,velocidade  #aumenta força
	lw t2,0(t0)
	li t1,255
	beq t1,t2,LOOP
	addi t2,t2,1
	sw t2,0(t0)
	li a2,50
	ret

FRACO:
	la t0,velocidade  #diminui força
	lw t2,0(t0)
	beq zero,t2,LOOP
	addi t2,t2,-1
	sw t2,0(t0)
	li a2 50
	ret

NO_INPUT:
	ret


PRINT_LINE_DATA:
	la t1,velocidade 
	lw a0,0(t1)  #a0 = velocidade atual
	srli a0,a0,2
	fcvt.s.w fa1,a0
	
	
	la t1,angulo 
	lb t2,0(t1)  #t2 = angulo atual
	li t3,90
	sub t3,t3,t2  #t3 = 90 - angulo atual(pro cos)
	
	slli t2,t2,2  #multiplica por 8 pq é uma word
	slli t3,t3,2
	
	la t1,seno
	addi t1,t1,4  #pula os dados. ta pulando so 4 e nao 8 pq teria q subtrair depois ja q começa do 0 e nao do 1, ai fiz tudo de uma vez
	add t4,t1,t2
	flw fa0,0(t4)  #pega seno do angulo do arquivo
	
	add t4,t1,t3
	flw fa2,0(t4)  #cos do angulo
	

PRINT_LINE:  #fa1 = velocidade, fa0 = seno do angulo, fa2 = cos do angulo
	
	fmul.s ft0,fa1,fa0  #ft0 = tamanho em y
	fmul.s ft1,fa2,fa1  #ft1 = tamanho em x
	
	li a7,147
	
	li a0,0  #canto esquerdo da tela em x
	li a1,240  #canto esquerdo em y
	fcvt.wu.s a2,ft1
	fcvt.wu.s a3,ft0
	sub a3,a1,a3
	li a4,152   #definindo os valores de acordo com o ecall
	slli t5,s0,20
	mv a5,t5
	ecall
	 
	ret
	
TIRO_PREP:

	li a0,46		#  nota
	li a1,500		#  tempo
	li a2,127		#  instrumento
	li a3,127		#  volume
	li a7,31		
	ecall	
	
	la t1,velocidade
	lw t0,0(t1)
	fcvt.s.w ft0,t0  #ft0 = velocidade
	
	la t1,angulo 
	lb t2,0(t1)  #t2 = angulo atual
	li t3,90
	sub t3,t3,t2  #t3 = 90 - angulo atual(pra pegar cos)
	
	slli t2,t2,2  #multiplica por 8 pq é uma word
	slli t3,t3,2
	
	la t1,seno
	addi t1,t1,4
	add t4,t1,t2
	flw ft1,0(t4)  #pega seno do angulo do arquivo
	
	add t4,t1,t3
	flw ft2,0(t4)  #cos do angulo
	
	fmul.s fa1,ft1,ft0  #fa1 = vetor vertical
	fmul.s fa2,ft2,ft0  #fa2 = vetor horizontal
	
	li a7,30
	ecall
	mv a6,a0  #a6 = tempo inicial
	
	la t0,G
	flw fa3,0(t0)  #fa3 = G
	
	
TIRO_LOOP:
	li a7, 30
	ecall
	sub t0,a0,a6  #t0 = tempo atual em ms(int)
	fcvt.s.w ft5,t0  #ft5 = tempo atual em ms(float)
	li t1,1000
	fcvt.s.w ft6,t1
	fdiv.s ft5,ft5,ft6  #ft5 = tempo atual em s
	
	fmul.s ft2,ft5,fa1 #ft2 = V0y * t
	fmul.s ft4,ft5,fa2 #ft4 = V0x * t
	
	fmul.s  ft3,fa3,ft5
	fmul.s ft3,ft3,ft5  #ft3 = (G/2 * t^2)
	
	fsub.s  ft3,ft2,ft3 #ft3 = V0y * t - (G/2 * t^2)
	
	fcvt.w.s a1,ft3  #a1 = pos y
	fcvt.wu.s a0,ft4  #a0 = pos x
	
	blt a1,zero,CHAO  #checa se bateu no chao
	li t0,320
	bge a0,t0,CHAO  #checa se saiu da tela pela direita
	li t0,240
	bge a1,t0,TIRO_LOOP #checa se saiu da tela por cima
	
	mv s11,ra
	jal COLISAO
	mv ra,s11
	

TIRO_PRINT:  #a1 = posição y, a0 = posição x
	li t0,240
	sub a1,t0,a1  #posição y
	
	li t0,0xff000000  #memoria do display
	slli t1,s0,20
	add t0,t0,t1  #frame atual
	
	li t2,320
	mul t2,t2,a1  #y do ponto
	
	add t0,t0,t2  #posição final na tela
	add t0,t0,a0
	
	li t5,0xcc  #cor
	sb t5,0(t0)	#salva a cor no display
	
	b TIRO_LOOP

END:
	ret

LIMPA:
	li a7,148
	li a0,0		#limpa a frame
	li a1,0
	ecall
	
	mv s9,ra
	jal PRINT_NAVE_SETUP #volta a nave
	mv ra,s9
	
	ret

COLISAO: #a0 = pos x, a1 = pos 240 - y
	la t0,nave_posx
	lw t1,0(t0) #t1 = nave x0
	lw t2,4(t0)  #t2 = nave y0
	li t3,240
	sub t3,t3,a1
	
	blt a0,t1,NAO_COLIDE
	addi t1,t1,2
	bgt a0,t1,NAO_COLIDE
	blt t3,t2,NAO_COLIDE
	addi t2,t2,2
	bgt t3,t2,NAO_COLIDE
	
	b EXPLOSAO

	
NAO_COLIDE:
	ret	

CHAO:
	#pega 4 numeros aleatorio, soma e subtrai eles da posiçao da nave pra aleatorizar a pozição quando erra
	#t1,t2,sao numeros aleatorios
	la t0,nave_posx
	
	li a7,41
	li a0,0
	li a1 6
	ecall
	srli a0,a0,28
	bgt a0,a1,CHAO
	blt a0,zero,CHAO
	mv t1,a0

REDO2:	
	ecall
	srli a0,a0,28
	bgt a0,a1,REDO2
	blt a0,zero,REDO2
	mv t2,a0
	li t3, 3
	
	sub t1,t1,t3
	sub t2,t2,t3
	
	lw t5,0(t0)
	lw t6,4(t0)
	
	add t5,t5,t1
	add t6,t6,t2
	sw t5,0(t0)
	sw t6,4(t0)
	
	li a7,148
	li a0,0
	li a1,0
	ecall
	
	ret
	
	
.include "SYSTEMv21.s"

; Hello World - Escreve mensagem armazenada na memoria na tela


; ------- TABELA DE CORES -------
; adicione ao caracter para Selecionar a cor correspondente

; 0 branco							0000 0000
; 256 marrom						0001 0000
; 512 verde							0010 0000
; 768 oliva							0011 0000
; 1024 azul marinho					0100 0000
; 1280 roxo							0101 0000
; 1536 teal							0110 0000
; 1792 prata						0111 0000
; 2048 cinza						1000 0000
; 2304 vermelho						1001 0000
; 2560 lima							1010 0000
; 2816 amarelo						1011 0000
; 3072 azul							1100 0000
; 3328 rosa							1101 0000
; 3584 aqua							1110 0000
; 3840 branco						1111 0000



jmp main


mensagem : var #21 ; aloca na memoria variavel com 21 bytes
static mensagem + #0, #'A' ;preenche a variavel alocada
static mensagem + #1, #'A'
static mensagem + #2, #'A'
static mensagem + #3, #'a'
static mensagem + #4, #'B'
static mensagem + #5, #'C'
static mensagem + #6, #'E'
static mensagem + #7, #'N'
static mensagem + #8, #'T'
static mensagem + #9, #'E'
static mensagem + #10, #'R'
static mensagem + #11, #' '
static mensagem + #12, #'T'
static mensagem + #13, #'O'
static mensagem + #14, #' '
static mensagem + #15, #'S'
static mensagem + #16, #'T'
static mensagem + #17, #'A'
static mensagem + #18, #'R'
static mensagem + #19, #'T'
static mensagem + #20, #'\0'

posMario: var #1
posAntMario: var #1


mensagem2 : string "Xupa Federal!!!"
mensagem3 : string "Raca Caaso!!!"




;---- Inicio do Programa Principal -----

main:
	
	loadn r1, #tela2Linha00
	loadn r2, #2304
	call ImprimeTela
	
	loadn r1, #tela3Linha00 
	loadn r2, #3584
	call ImprimeTela
	
	loadn R0, #964			
	store posMario, R0		; Zera Posicao Atual do Mario
	store posAntMario, R0	; Zera Posicao Anterior do Mario
	
	;Loadn R0, #240
	;store posAlien, R0		; Zera Posicao Atual do Alien
	;store posAntAlien, R0	; Zera Posicao Anterior do Alien
	
	loadn R0, #0			; Contador para os Mods	= 0
	loadn R2, #0			; Para verificar se (mod(c/10)==0

	Loop:
	
		loadn R1, #10
		mod R1, R0, R1
		cmp R1, R2		; if (mod(c/10)==0
		ceq MoveMario	; Chama Rotina de movimentacao do Mario
	
		;loadn R1, #30
		;mod R1, R0, R1
		;cmp R1, R2		; if (mod(c/30)==0
		;ceq MoveAlien	; Chama Rotina de movimentacao do Alien
	
		;call Delay
		;inc R0 	;c++
		jmp Loop
	
	
	
	halt
	
	
MoveMario:
	push r0
	push r1
	
	call MoveMario_RecalculaPos		; Recalcula Posicao da Mario

; So' Apaga e Redezenha se (pos != posAnt)
;	If (posMario != posAntMario)	{	
	load r0, posMario
	load r1, posAntMario
	cmp r0, r1
	jeq MoveMario_Skip
	
	;Se Próxima instrucao do mario for o chao ou parede, nao move
		call MoveMario_Apaga
		call MoveMario_Desenha		;}
  MoveMario_Skip:
	
	pop r1
	pop r0
	rts

;--------------------------------
	
MoveMario_Apaga:		; Apaga o Mario preservando o Cenario!
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5

	load R0, posAntMario	; R0 = posAnt
	
	; --> R2 = Tela1Linha0 + posAnt + posAnt/40  ; tem que somar posAnt/40 no ponteiro pois as linas da string terminam com /0 !!

	loadn R1, #tela3Linha00	; Endereco onde comeca a primeira linha do cenario!!
	add R2, R1, r0	; R2 = Tela1Linha0 + posAnt
	loadn R4, #40
	div R3, R0, R4	; R3 = posAnt/40
	add R2, R2, R3	; R2 = Tela1Linha0 + posAnt + posAnt/40
	
	loadi R5, R2	; R5 = Char (Tela(posAnt))
	
	outchar R5, R0	; Apaga o Obj na tela com o Char correspondente na memoria do cenario
	
	pop R5
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts
;----------------------------------	
	
MoveMario_RecalculaPos:		; Recalcula posicao da Mario em funcao das Teclas pressionadas
	push R0
	push R1
	push R2
	push R3

	load R0, posMario
	
	inchar R1				; Le Teclado para controlar a Mario
	loadn R2, #'a'
	cmp R1, R2
	jeq MoveMario_RecalculaPos_A
	
	loadn R2, #'d'
	cmp R1, R2
	jeq MoveMario_RecalculaPos_D
		
	loadn R2, #'w'
	cmp R1, R2
	jeq MoveMario_RecalculaPos_W
		
	loadn R2, #'s'
	cmp R1, R2
	jeq MoveMario_RecalculaPos_S
	
	;loadn R2, #' '
	;cmp R1, R2
	;jeq MoveMario_RecalculaPos_Tiro
	
  MoveMario_RecalculaPos_Fim:	; Se nao for nenhuma tecla valida, vai embora
	store posMario, R0
	pop R3
	pop R2
	pop R1
	pop R0
	rts

  MoveMario_RecalculaPos_A:	; Move Mario para Esquerda
	loadn R1, #40
	loadn R2, #0
	mod R1, R0, R1		; Testa condicoes de Contorno 
	cmp R1, R2
	jeq MoveMario_RecalculaPos_Fim
	dec R0	; pos = pos -1
	jmp MoveMario_RecalculaPos_Fim
		
  MoveMario_RecalculaPos_D:	; Move Mario para Direita	
	loadn R1, #40
	loadn R2, #39
	mod R1, R0, R1		; Testa condicoes de Contorno 
	cmp R1, R2
	jeq MoveMario_RecalculaPos_Fim
	inc R0	; pos = pos + 1
	jmp MoveMario_RecalculaPos_Fim
	
  MoveMario_RecalculaPos_W:	; Move Mario para Cima
	loadn R1, #40
	cmp R0, R1		; Testa condicoes de Contorno 
	jle MoveMario_RecalculaPos_Fim
	sub R0, R0, R1	; pos = pos - 40
	jmp MoveMario_RecalculaPos_Fim

  MoveMario_RecalculaPos_S:	; Move Mario para Baixo
	loadn R1, #1159
	cmp R0, R1		; Testa condicoes de Contorno 
	jgr MoveMario_RecalculaPos_Fim
	loadn R1, #40
	add R0, R0, R1	; pos = pos + 40
	jmp MoveMario_RecalculaPos_Fim	
	
MoveMario_Desenha:	; Desenha caractere do mario
	push R0
	push R1
	
	Loadn R1, #'X'	; Mario
	load R0, posMario
	outchar R1, R0
	store posAntMario, R0	; Atualiza Posicao Anterior da Mario = Posicao Atual
	
	pop R1
	pop R0
	rts

	
	
ImprimeTela: 	;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	loadn R6, #tela3Linha00	; Endereco onde comeca a primeira linha do cenario!!
	
   ImprimeTela2_Loop:
		call ImprimeStr2
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		add r6, r6, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela2_Loop	; Enquanto r0 < 1200

	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
				
;---------------------

	
;---- Inicio das Subrotinas -----
	
ImprimeStr2:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina
	
	
	loadn r3, #'\0'	; Criterio de parada
	loadn r5, #' '	; Espaco em Branco
	ImprimeStr2_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr2_Sai
		cmp r4, r5		; If (Char == ' ')  vai Pula outchar do espaco para na apagar outros caracteres
		jeq ImprimeStr2_Skip
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
		storei r6, r4
   ImprimeStr2_Skip:
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		inc r6			; Incrementa o ponteiro da String da Tela 0
		jmp ImprimeStr2_Loop
	
   ImprimeStr2_Sai:	
	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	

;------------------------
;--------Tela em branco-----------------
tela0Linha00 : string "                                        "
tela0Linha01 : string "                                        "
tela0Linha02 : string "                                        "
tela0Linha03 : string "                                        "
tela0Linha04 : string "                                        "
tela0Linha05 : string "                                        "
tela0Linha06 : string "                                        "
tela0Linha07 : string "                                        "
tela0Linha08 : string "                                        "
tela0Linha09 : string "                                        "
tela0Linha10 : string "                                        "
tela0Linha11 : string "                                        "
tela0Linha12 : string "                                        "
tela0Linha13 : string "                                        "
tela0Linha14 : string "                                        "
tela0Linha15 : string "                                        "
tela0Linha16 : string "                                        "
tela0Linha17 : string "                                        "
tela0Linha18 : string "                                        "
tela0Linha19 : string "                                        "
tela0Linha20 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "                                        "
tela0Linha27 : string "                                        "
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "


;------It's me Mario------------
tela2Linha00 : string "                                        "
tela2Linha01 : string "                                        "
tela2Linha02 : string "                                        "
tela2Linha03 : string "                                        "
tela2Linha04 : string "                                        "
tela2Linha05 : string "                                        "
tela2Linha06 : string "                                        "
tela2Linha07 : string "                                        "
tela2Linha08 : string "                                        "
tela2Linha09 : string "                                        "
tela2Linha10 : string "                                        "
tela2Linha11 : string "                                        "
tela2Linha12 : string "                                        "
tela2Linha13 : string "                                        "
tela2Linha14 : string "                                        "
tela2Linha15 : string "                                        "
tela2Linha16 : string "                                        "
tela2Linha17 : string "                                        "
tela2Linha18 : string "                                        "
tela2Linha19 : string "                                        "
tela2Linha20 : string "                                        "
tela2Linha21 : string "                                        "
telaH2Linha22 : string "                                        "
tela2Linha23 : string "                                        "
tela2Linha24 : string "                                        "
tela2Linha25 : string "                                        "
tela2Linha26 : string "                                        "
tela2Linha27 : string "                                        "
tela2Linha28 : string "                                        "
tela2Linha29 : string "                                        "

;------Plataforma1---------
tela3Linha00 : string "                                        "
tela3Linha01 : string "                                        "
tela3Linha02 : string "                                        "
tela3Linha03 : string "                                        "
tela3Linha04 : string "                                        "
tela3Linha05 : string "                                        "
tela3Linha06 : string "                                        "
tela3Linha07 : string "                                        "
tela3Linha08 : string "                                        "
tela3Linha09 : string "                                        "
tela3Linha10 : string "                                        "
tela3Linha11 : string "                                        "
tela3Linha12 : string "                                        "
tela3Linha13 : string "                                        "
tela3Linha14 : string "                                        "
tela3Linha15 : string "                                        "
tela3Linha16 : string "                                        "
tela3Linha17 : string "                                        "
tela3Linha18 : string "                                        "
tela3Linha19 : string "                                        "
tela3Linha20 : string "                                        "
tela3Linha21 : string "                                        "
tela3Linha22 : string "                                        "
tela3Linha23 : string "                                        "
tela3Linha24 : string "                                        "
tela3Linha25 : string "  ###################################   "
tela3Linha26 : string "                                        "
tela3Linha27 : string "                                        "
tela3Linha28 : string "                                        "
tela3Linha29 : string "                                        "
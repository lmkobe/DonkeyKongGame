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

posMario: var #1
posAntMario: var #1
posDK: var #1
posAntDK: var #1
posBarril: var #1
posAntBarril: var #1
FlagBarril: var #1
countBarril: var #1
countBarril2: var #1
flagDK: var #1


mensagem2 : string "Xupa Federal!!!"
mensagem3 : string "Raca Caaso!!!"

Msn0: string "V O C E   P E R D E U !!!"
Msn1: string "Quer jogar novamente? <s/n>"


;---- Inicio do Programa Principal -----

main:
	
	loadn r1, #tela2Linha00
	loadn r2, #2304
	call ImprimeTela
	
	loadn r1, #tela3Linha00 
	loadn r2, #3584
	call ImprimeTela
	
	loadn R0, #962			
	store posMario, R0		; Posicao Atual do Mario
	store posAntMario, R0	; Posicao Anterior do Mario
	
	loadn R0, #98
	store posDK, R0
	store posAntDK, R0
	
	store posBarril, R0
	store posAntBarril, R0
	loadn R0, #1
	store FlagBarril, R0
	store flagDK, R0
	loadn R0, #1
	store countBarril, R0
	loadn R0, #2500
	store countBarril2, R0
	
	loadn R0, #0			; Contador para os Mods	= 0
	loadn R2, #0			; Para verificar se (mod(c/10)==0

	Loop:
	
		loadn R1, #10
		mod R1, R0, R1
		cmp R1, R2		; if (mod(c/10)==0
		ceq MoveMario	; Chama Rotina de movimentacao do Mario
	
		;----------Contador para que o DK jogue o barril periodicamente--------
		load R4, countBarril
		load R3, countBarril2 
		dec R3
		jnz Count_fim
		loadn R3, #2500
		dec R4
		jnz Count_fim
		
		loadn R4, #1
		loadn R5, #1
		store FlagBarril, R5
		load R6, posDK
		store posBarril, R6
		store posAntBarril, R6
		
		Count_fim:
			store countBarril, R4
			store countBarril2, R3
	
	
		loadn R1, #40
		mod R1, R0, R1
		cmp R1, R2		; if (mod(c/40)==0
		ceq MoveBarril	; Chama Rotina de movimentacao do barril
	
		loadn R1, #30
		mod R1, R0, R1
		cmp R1, R2		; if (mod(c/10)==0
		ceq MoveDK	; Chama Rotina de movimentacao do Donkey Kong
		
		
		;loadn R1, #30
		;mod R1, R0, R1
		;cmp R1, R2		; if (mod(c/30)==0
		;ceq MoveAlien	; Chama Rotina de movimentacao do Alien
	
		;call Delay
		inc R0 	;c++
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
		call MoveMario_Apaga2
		call MoveMario_Desenha		;}
		call MoveMario_Desenha2
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
	
MoveMario_Apaga2:		; Apaga o Mario preservando o Cenario!
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5

	load R0, posAntMario	; R0 = posAnt
	loadn R4, #40
	sub R0, R0, R4
	
	; --> R2 = Tela1Linha0 + posAnt + posAnt/40  ; tem que somar posAnt/40 no ponteiro pois as linas da string terminam com /0 !!

	loadn R1, #tela3Linha00	; Endereco onde comeca a primeira linha do cenario!!
	add R2, R1, r0	; R2 = Tela1Linha0 + posAnt
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
	push R4
	push R5
	push R6

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
	pop R6
	pop R5
	pop R4
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
	loadn R1, #0
	loadn R3, #tela3Linha00
	loadn R4, #0
	loadn R2, #40
	;----Testa se saiu do chao--------
	loadn R5, #' '
	add R4, R0, R2 
	div R1, R4, R2  ;R1 = posMario / 40
	add R3, R3, R1  ;R3 = R3 + R1
	add R3, R3, R4  ;R3 = R3 + 41
	loadi R6, R3
	cmp R5, R6		;if (' ' == R6)
	jeq Queda_Mario
	jmp MoveMario_RecalculaPos_Fim
		
  MoveMario_RecalculaPos_D:	; Move Mario para Direita	
	loadn R1, #40
	loadn R2, #39
	mod R1, R0, R1		; Testa condicoes de Contorno 
	cmp R1, R2
	jeq MoveMario_RecalculaPos_Fim
	inc R0	; pos = pos + 1
	loadn R1, #0
	loadn R3, #tela3Linha00
	loadn R4, #0
	loadn R2, #40
	;----Testa se saiu do chao--------
	loadn R5, #' '
	add R4, R0, R2 
	div R1, R4, R2  ;R1 = posMario / 40
	add R3, R3, R1  ;R3 = R3 + R1
	add R3, R3, R4  ;R3 = R3 + 41
	loadi R6, R3
	cmp R5, R6		;if (' ' == R6)
	jeq Queda_Mario
	jmp MoveMario_RecalculaPos_Fim
	
  MoveMario_RecalculaPos_W:	; Move Mario para Cima
	loadn R1, #0
	loadn R2, #40
	loadn R3, #tela2Linha00
	loadn R4, #0
	loadn R5, #'H'
	
	add R4, R4, R0 
	div R1, R4, R2 ;Encontra a posicao atual do Mario / 40
	add R3, R3, R1 ;A posicao inicial da tela recebe o R1
	add R3, R3, R4 ;A posicao recebe o fator de correcao da tela para a memoria de video
	loadi R6, R3
	cmp R5, R6
	jne MoveMario_RecalculaPos_Fim
	loadn R1, #40
	sub R0, R0, R1	; pos = pos - 40
	jmp MoveMario_RecalculaPos_Fim

  MoveMario_RecalculaPos_S:	; Move Mario para Baixo
	loadn R1, #0
	loadn R3, #tela3Linha00
	loadn R4, #0
	loadn R2, #40
	
	;cmp R0, R1		; Testa condicoes de Contorno 
	;jgr MoveMario_RecalculaPos_Fim
	;----Testa colisão com o chão--------
	loadn R5, #3619
	add R4, R0, R2 
	div R1, R4, R2  ;R1 = posMario / 40
	add R3, R3, R1  ;R3 = R3 + R1
	add R3, R3, R4  ;R3 = R3 + 41
	loadi R6, R3
	cmp R5, R6		;if ('#' == R6)
	jeq MoveMario_RecalculaPos_Fim
	add R0, R0, R2	; pos = pos + 40
	jmp MoveMario_RecalculaPos_Fim	
	
MoveMario_Desenha:	; Desenha caractere do mario
	push R0
	push R1
	;Loadn R1, #00000000	; Mario
	load R0, posMario
	loadn R3, #3072
	outchar R3, R0
	store posAntMario, R0	; Atualiza Posicao Anterior da Mario = Posicao Atual
	
	pop R1
	pop R0
	rts
	
MoveMario_Desenha2:	; Desenha caractere do mario
	push R0
	push R1
	push R2
	push R3
	loadn R1, #40	; Mario
	loadn R2, #0
	load R0, posMario
	sub R2, R0, R1
	loadn R3, #2305
	outchar R3, R2
	store posAntMario, R0	; Atualiza Posicao Anterior da Mario = Posicao Atual
	
	pop R3
	pop R2
	pop R1
	pop R0
	rts

Queda_Mario:
	loadn R1, #0
	loadn R3, #tela3Linha00
	loadn R4, #0
	loadn R2, #40
	;----Testa colisão com o chão--------
	loadn R5, #3619
	add R4, R0, R2 
	div R1, R4, R2  ;R1 = posMario / 40
	add R3, R3, R1  ;R3 = R3 + R1
	add R3, R3, R4  ;R3 = R3 + 41
	loadi R6, R3
	cmp R5, R6		;if ('#' == R6) para de cair
	jeq MoveMario_RecalculaPos_Fim
	loadn R1, #40
	add R0, R0, R1
	store posMario, R0
	;call Delay
	call MoveMario_Apaga
	call MoveMario_Apaga2
	call MoveMario_Desenha
	call MoveMario_Desenha2
	jmp Queda_Mario
	
MoveDK:
	push r0
	push r1
	
	call MoveDK_RecalculaPos
	
; So' Apaga e Redezenha se (pos != posAnt)
;	If (pos != posAnt)	{	
	load r0, posDK
	load r1, posAntDK
	cmp r0, r1
	jeq MoveDK_Skip
		call MoveDK_Apaga
		call MoveDK_Desenha		;}
  MoveDK_Skip:
	
	pop r1
	pop r0
	rts
		
; ----------------------------

MoveDK_Apaga:
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5

	load R0, posAntDK	; R0 == posAnt
	load R1, posAntMario		; R1 = posAnt
	cmp r0, r1
	jne MoveDK_Apaga_Skip
		loadn r5, #'X'		; Se o Tiro passa sobre a Nave, apaga com um X, senao apaga com o cenario 
		jmp MoveDK_Apaga_Fim

  MoveDK_Apaga_Skip:	
  
	; --> R2 = Tela1Linha0 + posAnt + posAnt/40  ; tem que somar posAnt/40 no ponteiro pois as linas da string terminam com /0 !!
	loadn R1, #tela3Linha00	; Endereco onde comeca a primeira linha do cenario!!
	add R2, R1, r0	; R2 = Tela1Linha0 + posAnt
	loadn R4, #40
	div R3, R0, R4	; R3 = posAnt/40
	add R2, R2, R3	; R2 = Tela1Linha0 + posAnt + posAnt/40
	
	loadi R5, R2	; R5 = Char (Tela(posAnt))
  
  MoveDK_Apaga_Fim:	
	outchar R5, R0	; Apaga o Obj na tela com o Char correspondente na memoria do cenario
	
	pop R5
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts
	
MoveDK_RecalculaPos:
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5
	push R6

	load R0, posDK
	;---Se flagDK == 0, move para a esquerda, se flagDK == 1 move para a direita
	load r1, flagDK
	loadn r2, #0
	cmp r1, r2
	jeq MoveDK_RecalculaPos_Left 
	
	loadn r2, #1
	cmp r1, r2
	jeq MoveDK_RecalculaPos_Right
	
	MoveDK_RecalculaPos_Left:
		dec R0	; pos = pos -1
		
		loadn R1, #0
		loadn R3, #tela3Linha00
		loadn R4, #0
		loadn R2, #40
		;----Testa se saiu do chao--------
		loadn R5, #' '
		add R4, R0, R2 
		div R1, R4, R2  ;R1 = posMario / 40
		add R3, R3, R1  ;R3 = R3 + R1
		add R3, R3, R4  ;R3 = R3 + 41
		loadi R6, R3
		cmp R5, R6		;if (' ' == R6)
		jeq MoveDK_RecalculaPos_FimLeft
		jmp MoveDK_RecalculaPos_Fim
	
	MoveDK_RecalculaPos_Right:
		inc r0
		loadn R1, #0
		loadn R3, #tela3Linha00
		loadn R4, #0
		loadn R2, #40
		;----Testa se saiu do chao--------
		loadn R5, #' '
		add R4, R0, R2 
		div R1, R4, R2  ;R1 = posMario / 40
		add R3, R3, R1  ;R3 = R3 + R1
		add R3, R3, R4  ;R3 = R3 + 41
		loadi R6, R3
		cmp R5, R6		;if (' ' == R6)
		jeq MoveDK_RecalculaPos_FimRight
		jmp MoveDK_RecalculaPos_Fim
		
	;---Caso a posicao do DK tenha saido do chao, entao a acao eh desfeita e na proxima movimentacao
	;---o DK ira se mover na direcao oposta
	MoveDK_RecalculaPos_FimLeft:
		inc r0
		loadn r1, #1
		store flagDK, r1
		jmp MoveDK_RecalculaPos_Fim
	
	MoveDK_RecalculaPos_FimRight:
		dec r0
		loadn r1, #0
		store flagDK, r1
	
	MoveDK_RecalculaPos_Fim:	
		store posDK, R0	; Grava a posicao alterada na memoria
		pop R6
		pop R5
		pop R4
		pop R3
		pop R2
		pop R1
		pop R0
		rts


;----------------------------------
MoveDK_Desenha:
	push R0
	push R1
	
	Loadn R1, #259	; DK
	load R0, posDK
	outchar R1, R0
	store posAntDK, R0
	
	pop R1
	pop R0
	rts

;----------------------------------
;----------------------------------
;----------------------
	
MoveBarril:
	push r0
	push r1
	
	call MoveBarril_RecalculaPos

; So' Apaga e Redezenha se (pos != posAnt)
;	If (pos != posAnt)	{	
	load r0, posBarril
	load r1, posAntBarril
	cmp r0, r1
	jeq MoveBarril_Skip
		call MoveBarril_Apaga
		call MoveBarril_Desenha		;}
  MoveBarril_Skip:
	
	pop r1
	pop r0
	rts

;-----------------------------

MoveBarril_Apaga:
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5

	; Compara Se (posAntBarril == posAntNave)
	load R0, posAntBarril	; R0 = posAnt
	load R1, posAntMario	; R1 = posAnt
	cmp r0, r1
	jne MoveBarril_Apaga_Skip1
		loadn r5, #'X'		; Se o Barril passa sobre o Mario, apaga com um X, senao apaga com o cenario 
		jmp MoveBarril_Apaga_Fim
		
  MoveBarril_Apaga_Skip1:	
	; --> R2 = Tela1Linha0 + posAnt + posAnt/40  ; tem que somar posAnt/40 no ponteiro pois as linas da string terminam com /0 !!
	loadn R1, #tela3Linha00	; Endereco onde comeca a primeira linha do cenario!!
	add R2, R1, r0	; R2 = Tela1Linha0 + posAnt
	loadn R4, #40
	div R3, R0, R4	; R3 = posAnt/40
	add R2, R2, R3	; R2 = Tela1Linha0 + posAnt + posAnt/40
	
	loadi R5, R2	; R5 = Char (Tela(posAnt))

  MoveBarril_Apaga_Fim:	
	outchar R5, R0	; Apaga o Obj na tela com o Char correspondente na memoria do cenario
	
	pop R5
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts
;----------------------------------	

MoveBarril_RecalculaPos:
	push R0
	push R1
	push R2
	
	load R1, FlagBarril	; Se movimentacao do Barril esta ativa!
	loadn R2, #1
	cmp R1, R2			; If FlagBarril == 1  Movimenta o Barril
	jne MoveBarril_RecalculaPos_Fim2	; Se nao vai embora!
	
	load R0, posBarril	; Testa se o Barril Pegou no Alien (Mario)
	load R1, posMario
	cmp R0, R1			; IF posBarril == posAlien  BOOM!!
	jeq MoveBarril_RecalculaPos_Boom
	
	loadn R1, #1160		; Testa condicoes de Contorno 
	;loadn R2, #39
	;mod R1, R0, R1		
	cmp R0, R1			; Se Barril chegou na ultima linha
	jle MoveBarril_RecalculaPos_Fim
	call MoveBarril_Apaga
	loadn R0, #0
	load R1, posDK
	store FlagBarril, R0	; Zera FlagBarril
	;store posBarril, R1	; Zera e iguala posBarril e posAntBarril
	;store posAntBarril, R1
	jmp MoveBarril_RecalculaPos_Fim2	
	
  MoveBarril_RecalculaPos_Fim:
	loadn R1, #40
	add R0, R0, R1
	;inc R0
	store posBarril, R0
  MoveBarril_RecalculaPos_Fim2:	
	pop R2
	pop R1
	pop R0
	rts

  MoveBarril_RecalculaPos_Boom:	
	; Limpa a Tela !!
  	loadn R1, #tela0Linha00	; Endereco onde comeca a primeira linha do cenario!!
	loadn R2, #0  			; cor branca!
	call ImprimeTela   		;  Rotina de Impresao de Cenario na Tela Inteira
  
	;imprime Voce Venceu !!!
	loadn r0, #526
	loadn r1, #Msn0
	loadn r2, #0
	call ImprimeStr2
	
	;imprime quer jogar novamente
	loadn r0, #605
	loadn r1, #Msn1
	loadn r2, #0
	call ImprimeStr2
	
	;call DigLetra
	;loadn r0, #'s'
	;load r1, Letra
	;cmp r0, r1				; tecla == 's' ?
	;jne MoveBarril_RecalculaPos_FimJogo	; tecla nao e' 's'
	
	; Se quiser jogar novamente...
	call ApagaTela
	
	pop r2
	pop r1
	pop r0

	pop r0	; Da um Pop a mais para acertar o ponteiro da pilha, pois nao vai dar o RTS !!
	jmp main

  MoveBarril_RecalculaPos_FimJogo:
	call ApagaTela
	halt

;----------------------------------

MoveBarril_Desenha:
	push R0
	push R1
	
	Loadn R1, #258	; Barril
	load R0, posBarril
	outchar R1, R0
	store posAntBarril, R0
	
	pop R1
	pop R0
	rts

	
	
ApagaTela:
	push r0
	push r1
	
	loadn r0, #1200		; apaga as 1200 posicoes da Tela
	loadn r1, #' '		; com "espaco"
	
	   ApagaTela_Loop:	;;label for(r0=1200;r3>0;r3--)
		dec r0
		outchar r1, r0
		jnz ApagaTela_Loop
 
	pop r1
	pop r0
	rts	

;Delay para a animacao de queda do mario quando passa da plataforma	
Delay:	
	push R1
	push R2
	
	loadn R1, #5
	loopj:
		loadn R2, #3000
	loopi:
		dec R2
		jnz loopi
		dec R1
		jnz loopj
		
	pop R2
	pop R1
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


;------Escadas------------
tela2Linha00 : string "                                        "
tela2Linha01 : string "                                        "
tela2Linha02 : string "                                        "
tela2Linha03 : string "        H                   H           "
tela2Linha04 : string "        H                   H           "
tela2Linha05 : string "        H                   H           "
tela2Linha06 : string "        H                   H           "
tela2Linha07 : string "        H                   H           "
tela2Linha08 : string "        H                   H           "
tela2Linha09 : string "      H                        H        "
tela2Linha10 : string "      H                        H        "
tela2Linha11 : string "      H                        H        "
tela2Linha12 : string "      H          H             H        "
tela2Linha13 : string "      H          H             H        "
tela2Linha14 : string "      H          H             H        "
tela2Linha15 : string "      H          H             H        "
tela2Linha16 : string "      H          H             H        "
tela2Linha17 : string "      H          H             H        "
tela2Linha18 : string "        H                 H             "
tela2Linha19 : string "        H                 H             "
tela2Linha20 : string "        H                 H             "
tela2Linha21 : string "        H                 H             "
tela2Linha22 : string "        H                 H             "
tela2Linha23 : string "        H                 H             "
tela2Linha24 : string "        H                 H             "
tela2Linha25 : string "                                        "
tela2Linha26 : string "                                        "
tela2Linha27 : string "                                        "
tela2Linha28 : string "                                        "
tela2Linha29 : string "                                        "

;------Plataforma1---------
tela3Linha00 : string "                                        "
tela3Linha01 : string "                                        "
tela3Linha02 : string "                                        "
tela3Linha03 : string "    #### ################### ########   "
tela3Linha04 : string "                                        "
tela3Linha05 : string "                                        "
tela3Linha06 : string "                                        "
tela3Linha07 : string "                                        "
tela3Linha08 : string "                                        "
tela3Linha09 : string "    ## ####             ####### #####   "
tela3Linha10 : string "                                        "
tela3Linha11 : string "                                        "
tela3Linha12 : string "              ### ###                   "
tela3Linha13 : string "                                        "
tela3Linha14 : string "                                        "
tela3Linha15 : string "                                        "
tela3Linha16 : string "                                        "
tela3Linha17 : string "                                        "
tela3Linha18 : string "     ### ################# #######      "
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
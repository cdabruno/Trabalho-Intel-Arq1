         assume cs:codigo,ds:dados,es:dados,ss:pilha

CR        EQU    0DH ; caractere ASCII "Carriage Return" (tecla ENTER)
LF        EQU    0AH ; caractere ASCII "Line Feed"
BKSPC     EQU    08H ; caractere ASCII "Backspace"
ESCP      EQU    27  ; caractere ASCII "Escape" (tecla ESC)

; SEGMENTO DE DADOS DO PROGRAMA
dados     segment
nome      db 64 dup (?)
crAd      db CR
lfAd	  db LF
buffer    db 128 dup (?)
pede_nome db 'Nome do arquivo: ','$'
erro      db 'Arquivo invalido',CR,LF,'$'
msg_final db 'Fim do programa.',CR,LF,'$'
msg_Nome  db '***** Aluno: Bruno Correa ***** Cartao: 00313550 *****', CR,LF,'$'
msg_ArquivoLegenda	db 'Arquivo $'
msg_LegendaLadrilho	db ' - Total de ladrilhos por cor: $'
posX1	  dw ?
posX2     dw ?
posY1	  dw ?
posY2	  dw ?
quadX1	  dw ?
quadX2    dw ?
quadY1    dw ?
quadY2    dw ?
lado      dw ?
contador  dw ?
corRejunte		  dw 0C0Fh
corVariavel	dw ?
corQuadrado dw ?
preto	dw 0
azul dw 0
verde dw 0
ciano dw 0
vermelho dw 0
magenta dw 0
marrom dw 0
cinzaClaro dw 0
cinzaEscuro dw 0
azulClaro dw 0
verdeClaro dw 0
cianoClaro dw 0
vermelhoClaro dw 0
magentaClaro dw 0
amarelo dw 0
temp dw ?
pulouLinha db 0
posX db 0
posY db 0
posXTemp db 0
String	db		10 dup (?)
String2	db		10 dup (?)
H2D		db		10 dup (?)
nomeSemPar      db 64 dup (?)
fimPalavra dw 0
sw_n	dw	0
sw_f	db	0
sw_m	dw	0

pretoString         db 'Preto: ',0
azulString          db 'Azul: ',0
verdeString         db 'Verde: ',0
cianoString         db 'Ciano: ',0
vermelhoString      db 'Vermelho: ',0
magentaString       db 'Magenta: ',0
marromString        db 'Marrom: ',0
cinzaClaroString    db 'Cinza claro: ',0
cinzaEscuroString   db 'Cinza escuro: ',0
azulClaroString     db 'Azul claro: ',0
verdeClaroString    db 'Verde claro: ',0
cianoClaroString    db 'Ciano claro: ',0
vermelhoClaroString db 'Vermelho claro: ',0
magentaClaroString  db 'Magenta claro: ',0
amareloString       db 'Amarelo: ',0

tamanhoPalavra dw 0

handlerEscrever dw ?


															;; quadX2
															;; quadY1
															;; quadY2
															;; lado




handler   dw ?
dados     ends

; SEGMENTO DE PILHA DO PROGRAMA
pilha    segment stack            ; permite inicializacao automatica de SS:SP
         dw     128 dup(?)
pilha    ends
         
; SEGMENTO DE C�DIGO DO PROGRAMA
codigo   segment
inicio:         ; CS e IP sao inicializados com este endereco
         mov    ax,dados           ; inicializa DS
         mov    ds,ax              ; com endereco do segmento DADOS
         mov    es,ax              ; idem em ES
; fim da carga inicial dos registradores de segmento
;


; INICIO PROGRAMA

iniciozao:

		mov ah, 0h
		mov al, 12h
		int 10h
		
		
		lea		dx, msg_Nome
		mov		ah, 9
		int 	21h

		
		
		
	



; pede nome do arquivo

		



de_novo: lea    dx,pede_nome       ; endereco da mensagem em DX
         mov    ah,9               ; funcao exibir mensagem no AH
         int    21h                ; chamada do DOS
; le nome do arquivo
         lea    di, nome
entrada: mov    ah,1
         int    21h                ; le um caractere com eco

         cmp    al,ESCP            ; compara com ESCAPE (tecla ESC)
         jne    depois 
         jmp    terminar
depois:
         cmp    al,CR              ; compara com carriage return (tecla ENTER)
         je     continua

         cmp    al,BKSPC           ; compara com 'backspace'
         je     backspace

         mov    [di],al            ; coloca caractere lido no buffer
         inc    di
         jmp    entrada

backspace:
         cmp    di,offset nome
         jne    adiante
         mov    dl,' '              ; avanca cursor na tela
         mov    ah,2
         int    21h
         jmp    entrada
adiante:
         mov    dl,' '              ; apaga ultimo caractere digitado
         mov    ah,2
         int    21h
         mov    dl,BKSPC            ; recua cusor na tela
         mov    ah,2
         int    21h
         dec    di
         jmp    entrada

continua: 
         mov    byte ptr [di],0     ; forma string ASCIIZ com o nome do arquivo
         mov    dl,LF               ; escreve LF na tela
         mov    ah,2
         int    21h
;
; abre arquivo para leitura COME�A PROGRAMA


		lea bx, nome
		cmp byte ptr[bx], 0
		jne nTermina

		call limpaTela
		mov posX, 0
		mov posY, 0
		call movCursorInicio

		lea dx, msg_final
		mov    ah,9               
        int    21h

		jmp terminar



; .par
nTermina:
		lea di, nome
		xor cx, cx
colocaPar:
		cmp byte ptr[di], '.'
		je colocaParFinal
		cmp byte ptr[di], 0
		je colocaParFinal
		inc di
		inc cx
		jmp colocaPar

colocaParFinal:
		mov byte ptr[di], '0'

		mov tamanhoPalavra, cx

		mov byte ptr[di], '.'
		inc di
		mov byte ptr[di], 'p'
		inc di
		mov byte ptr[di], 'a'
		inc di
		mov byte ptr[di], 'r'
		inc di
		mov byte ptr[di], 0

		
		


		
		call limpaTela
		mov posX, 0
		mov posY, 0
		call movCursorInicio


         mov    ah,3dh
         mov    al,0
         lea    dx,nome
         int 21h
         jnc    abriu_ok
         lea    dx,erro             ; endereco da mensagem em DX
         mov    ah,9                ; funcao exibir mensagem no AH
         int    21h                 ; chamada do DOS
         jmp    de_novo
;

		 
		 
;; LEU ARQUIVO, MODO GRAFICO		 
		 
		 
		 
		 
		 
abriu_ok: 


		lea si, nome
		lea di, nomeSemPar
		rep movs byte ptr[si], byte ptr[di]
		inc di
		mov byte ptr[di], '$'
		mov fimPalavra, di



		
		
		mov pulouLinha, 0
		
		 	
		mov handler,ax
		 
		 
		mov quadX1, 5
		mov quadX2, 29
		mov quadY1, 20
		mov quadY2, 44
		 
		 
laco:    mov ah,3fh                 ; l� um caractere do arquivo
         mov bx,handler
         mov cx,1
         lea dx,buffer
         int 21h
         cmp ax,cx
         jne vaiFim
		 
		 mov dl, buffer             ; escreve na tela at� encontrar um LF (fim de linha)
		 cmp dl, CR
		 je laco
		 cmp dl, LF
		 jne ladrilhoValido

		cmp pulouLinha, 0
		je dimensoes
		 
		add quadY1, 24
		add quadY2, 24
dimensoes:
		mov quadX1, 5
		mov quadX2, 29
		mov pulouLinha, 1

		
		jmp laco
		 
vaiFim:
		jmp fim
         
		
ladrilhoValido:	

		cmp pulouLinha, 0
		jne Pulou
		jmp laco
		
Pulou:
		 mov corQuadrado,0C00h	
			
		 cmp dl, 'A'
		 jb decimal1
		 
		 
		add corQuadrado, dx
		sub corQuadrado, 55
		jmp continua1
		 
decimal1: 
		
		
		
		add corQuadrado, dx
		sub corQuadrado, 48
		 
continua1: 
		 cmp corQuadrado, 0C00h
		 je pretoADD
		 cmp corQuadrado, 0C01h
		 je azulADD
		 cmp corQuadrado, 0C02h
		 je verdeADD
		 cmp corQuadrado, 0C03h
		 je cianoADD
		 cmp corQuadrado, 0C04h
		 je vermelhoADD
		 cmp corQuadrado, 0C05h
		 je magentaADD
		 cmp corQuadrado, 0C06h
		 je marromADD
		 cmp corQuadrado, 0C07h
		 je cinzaClaroADD
		 cmp corQuadrado, 0C08h
		 je cinzaEscuroADD
		 cmp corQuadrado, 0C09h
		 je azulClaroADD
		 cmp corQuadrado, 0C0Ah
		 je verdeClaroADD
		 cmp corQuadrado, 0C0Bh
		 je cianoClaroADD
		 cmp corQuadrado, 0C0Ch
		 je vermelhoClaroADD
		 cmp corQuadrado, 0C0Dh
		 je magentaClaroADD
		 cmp corQuadrado, 0C0Eh
		 je amareloADD


pretoADD:
		inc preto
		jmp printaQuadrado
azulADD:
		inc azul
		jmp printaQuadrado
verdeADD:
		inc verde
		jmp printaQuadrado
cianoADD:
		inc ciano
		jmp printaQuadrado
vermelhoADD:
		inc vermelho
		jmp printaQuadrado
magentaADD:
		inc magenta
		jmp printaQuadrado
marromADD:
		inc marrom
		jmp printaQuadrado
cinzaClaroADD:
		inc cinzaClaro
		jmp printaQuadrado
cinzaEscuroADD:
		inc cinzaEscuro
		jmp printaQuadrado
azulClaroADD:
		inc azulClaro
		jmp printaQuadrado
verdeClaroADD:
		inc verdeClaro
		jmp printaQuadrado
cianoClaroADD:
		inc cianoClaro
		jmp printaQuadrado
vermelhoClaroADD:
		inc vermelhoClaro
		jmp printaQuadrado
magentaClaroADD:
		inc magentaClaro
		jmp printaQuadrado
amareloADD:
		inc amarelo
		jmp printaQuadrado
		 
		 
printaQuadrado:
		 push quadX1
		 push quadX2
		 push quadY1
		 push quadY2
		 
		 call imprimeQuadrado
		 
		 pop quadY2
		 pop quadY1
		 pop quadX2
		 pop quadX1
		 
		
		 
		add quadX1, 24
		add quadX2, 24
		
		jmp laco
		
		
		
   
   
   
fim:     
		mov ah,3eh                 ; fecha arquivo
        mov bx,handler
        int 21h
;      

		 ; MOSTROU PAREDE
		
		

		lea		dx, msg_Nome
		mov		ah, 9
		int 	21h
		
		mov posY2, 20
		mov posX2, 629
		mov posX1, 5
		 
		 ;; PRINTANDO BORDAS DA PAREDE
		 
		 
		 mov ax, corRejunte
		 mov corVariavel, ax
		 
		call printaLinhas     ; DE POSX1 ATE POSX2, NA ALTURA POSY2
		
		mov posY2, 380
		mov posX2, 629
		mov posX1, 5
		
		call printaLinhas
		
		mov posX2, 5															;; 5 624
		mov posY2, 380															;; 50 410
		mov posY1, 20
		
		call printaColunas ;; DE POSY2 ATE POSY1, NA LARGURA POSX2
		
		mov posX2, 629
		mov posY2, 380
		mov posY1, 20
		
		call printaColunas ;; DE POSY2 ATE POSY1, NA LARGURA POSX2
		
		
		
		;;							BORDADA PINTADA, MOSTRAR QUADRADOS...
		
		
		
		
		;; PRINTAR QUADRADOS LEGENDA
		
		mov  ah, 2                 ; move cursor para baixo
		mov  bh, 0
		mov  dl, 0
		mov  dh, 24
		int  10h
		
		lea dx, msg_ArquivoLegenda
		mov ah, 9
		int 21h

		lea dx, nomeSemPar
		mov ah, 9
		int 21h

		push bx
		mov bx, fimPalavra
		mov byte ptr[bx], 0
		pop bx
		
		lea dx, msg_LegendaLadrilho
		mov ah, 9
		int 21h
		
											; 420 de altura para quadrados
											
		mov corQuadrado, 0C00h						
		
		
		mov quadY2, 434
		mov quadY1, 410
		mov quadX2, 42
		mov quadX1, 18
		


escreveArquivo:    ;abre arquivo para escrita

		lea di, nomeSemPar

colocaRel:

		cmp [di], 0
		je colocaRel2
		inc di
		jmp colocaRel

colocaRel2:

		mov [di], '.'
		inc di
		mov [di], 'r'
		inc di
		mov [di], 'e'
		inc di
		mov [di], 'l'
		inc di
		mov [di], 0

		mov ah, 3ch
		xor cx, cx
		lea dx, nomeSemPar
		int 21h

		jnc aqui
		jmp terminar

aqui:	
		mov cx, 15		
		
legendaLoop:
		
		
		push cx
		
		
		push quadX2
		push quadX1
		push quadY1
		push quadY2
		
		
		
		call imprimeQuadrado
		
		

		
		pop quadY2
		pop quadY1
		pop quadX1
		pop quadX2
		
		inc corQuadrado
		
		add quadX2, 40
		add quadX1, 40
		
		pop cx
		
		dec cx
		
		cmp cx, 0
		
		
		
		
		jne legendaLoop
		
;printa resultados

		lea bx, preto
		mov posY, 28
		mov posX, 3
		mov cx, 15

loopNumeros:


		
		push cx

		call movCursorInicio

		mov al, posX
		mov posXTemp, al

		
		mov ax, [bx]

		push bx

		lea bx, String
		
		call sprintf_w



copiaString:    ;abre arquivo para escrita

		lea di, String2
		lea si, String
		push ax

copiaString2:

		cmp [si], '$'
		je fimCopiaString
		mov al, [si]
		mov [di], al
		inc di
		inc si
		jmp copiaString2

fimCopiaString:

		pop ax

		
		call escreveCorArquivo
		
		lea dx, String
		mov ah, 9
		int 21h

	

		

		
		mov al, posXTemp
		mov posX, al
		pop bx	
		add bx, 2
		add posX, 5
		pop cx



		loop loopNumeros

; fecha arquivo

		mov  ah, 3eh
 		mov  bx, handlerEscrever
  		int  21h 
		

	

		




; acabou programa, aguarda tecla
		mov    ah,1     
        int    21h

		lea bx, preto
		mov cx, 15

reset:
		mov [bx], 0
		add bx, 2
		loop reset




		jmp iniciozao
		
		
		 
terminar:
         mov    ax,4c00h            ; funcao retornar ao DOS no AH
                                    ; codigo de retorno 0 no AL
         int    21h                 ; chamada do DOS
		 
; FUNCOES

limpaTela:

		push ax
		push cx
		push dx

		mov ax, 0700h  ; function 07, AL=0 means scroll whole window
		mov bh, 00h    ; character attribute = white on black
		mov cx, 0000h ; row = 0, col = 0
		mov dx, 184fh  ; row = 24 (0x18), col = 79 (0x4f)
		int 10h        ; call BIOS video interrupt
		mov bh, 07h
		
		pop dx
		pop cx
		pop ax
		
		ret
		
movCursorInicio: ; posX, posY

		push ax
		push dx
		push bx

		mov  ah, 2h                  ; move cursor para o inicio
		mov  bh, 0h
		mov  dl, posX
		mov  dh, posY
		int  10h
	
		pop bx
		pop dx
		pop ax
		
		ret
		
		
printaLinhas:

		push ax
		push bx
		push cx
		push dx

		mov ax, corVariavel ;COR AZUL CLARO 3 VERMELHO 4 ROSA 15 laranja 6
        mov bx, 0				;360 624
		mov CX, posX2 ; 50 in hex
		mov DX, posY2 ; 100 in hex
		loopLinha:
		int 10h
		dec CX
		cmp CX, posX1
		jne loopLinha ; If CX isn't negative,
; draw another pixel

		pop dx
		pop cx
		pop bx
		pop ax


		ret
		
printaColunas:

		push ax
		push bx
		push cx
		push dx

		mov ax, corVariavel		;COR
        mov bx, 0				;360 624
		mov DX, posY2 ; 50 in hex
		mov CX, posX2 ; 100 in hex													
		loopColuna:
		int 10h
		dec DX
		cmp DX, posY1
		jne loopColuna ; If CX isn't negative,
		
		pop dx
		pop cx
		pop bx
		pop ax
		
		
		ret
		
imprimeQuadrado:											;; quadX1
															;; quadX2
															;; quadY1
															;; quadY2
															;; lado
															;; cor
		push ax
		push bx
		push dx
															
		mov ax, corRejunte
		mov corVariavel, ax
															
		mov ax, quadY2
		mov posY2, ax
		mov ax, quadX2
		mov posX2, ax
		mov ax, quadX1
		mov posX1, ax
		
		call printaLinhas
		
		mov ax, quadY1
		mov posY2, ax
		
		call printaLinhas
		
		mov ax, quadX2
		mov posX2, ax
		mov ax, quadY2
		mov posY2, ax
		mov ax, quadY1
		mov posY1, ax
		
		call printaColunas
		
		mov ax, quadX1
		mov posX2, ax
		
		call printaColunas
		
		
		dec quadX2
		dec quadY2
		
		mov ax, quadX2
		mov posX2, ax
		mov ax, quadY2
		mov posY2, ax
		mov ax, quadX1
		mov posX1, ax
		mov ax, quadY1
		mov posY1, ax
		
		mov ax, corQuadrado
		mov corVariavel, ax
		
		
loopCorQuadrado:

		push bx
		mov bx, posY2 
		cmp bx, posY1
		pop bx
		je fimQuadrado
		
		
		call printaLinhas
		
		dec posY2
		
		jmp loopCorQuadrado
		
		
		
fimQuadrado:
		pop dx
		pop bx
		pop ax


		ret
		

			
		

		
sprintf_w	proc	near

push cx
push dx

;void sprintf_w(char *string, WORD n) {
	mov		sw_n,ax

;	k=5;
	mov		cx,5
	
;	m=10000;
	mov		sw_m,10000
	
;	f=0;
	mov		sw_f,0
	
;	do {
sw_do:

;		quociente = n / m : resto = n % m;	// Usar instru��o DIV
	mov		dx,0
	mov		ax,sw_n
	div		sw_m
	
;		if (quociente || f) {
;			*string++ = quociente+'0'
;			f = 1;
;		}
	cmp		al,0
	jne		sw_store
	cmp		sw_f,0
	je		sw_continue
sw_store:
	add		al,'0'
	mov		[bx],al
	inc		bx
	
	mov		sw_f,1
sw_continue:
	
;		n = resto;
	mov		sw_n,dx
	
;		m = m/10;
	mov		dx,0
	mov		ax,sw_m
	mov		bp,10
	div		bp
	mov		sw_m,ax
	
;		--k;
	dec		cx
	
;	} while(k);
	cmp		cx,0
	jnz		sw_do

;	if (!f)
;		*string++ = '0';
	cmp		sw_f,0
	jnz		sw_continua2
	mov		[bx],'0'
	inc		bx
sw_continua2:


;	*string = '\0';
	mov		byte ptr[bx],'$'
		
;}
pop dx
pop cx
	ret
		
sprintf_w	endp

escreveCorArquivo: 

push ax
push bx
push cx
push dx

		cmp cx, 15
		je arquivoPreto
		cmp cx, 14
		jne corX
		jmp arquivoAzul
corX:		cmp cx, 13
		jne cor1
		jmp arquivoVerde
cor1:	cmp cx, 12
		jne cor2
		jmp arquivoCiano
cor2:		cmp cx, 11
		jne cor3
		jmp arquivoVermelho
cor3:		cmp cx, 10
		jne cor4
		jmp arquivoMagenta
cor4:		cmp cx, 9
		jne cor5
		jmp arquivoMarrom
cor5:		cmp cx, 8
		jne cor6
		jmp arquivoCinzaClaro
cor6:		cmp cx, 7
		jne cor7
		jmp arquivoCinzaEscuro
cor7:		cmp cx, 6
		jne cor8
		jmp arquivoAzulClaro
cor8:		cmp cx, 5
		jne cor9
		jmp arquivoVerdeClaro
cor9:		cmp cx, 4
		jne cor10
		jmp arquivoCianoClaro
cor10:		cmp cx, 3
		jne cor11
		jmp arquivoVermelhoClaro
cor11:		cmp cx, 2
		jne cor12
		jmp arquivoMagentaClaro
cor12:	jmp arquivoAmarelo

arquivoPreto:

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 7
		lea dx, pretoString
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 5
		lea dx, String2
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, crAd
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, lfAd
		int 21h
jmp terminar
		jmp fimEscreve

arquivoAzul:

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 6
		lea dx, azulString
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 5
		lea dx, String2
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, crAd
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, lfAd
		int 21h

		jmp fimEscreve

arquivoVerde:

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 7
		lea dx, verdeString
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 5
		lea dx, String2
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, crAd
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, lfAd
		int 21h

		jmp fimEscreve

arquivoCiano:

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 7
		lea dx, cianoString
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 5
		lea dx, String2
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, crAd
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, lfAd
		int 21h

		jmp fimEscreve

arquivoVermelho:

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 10
		lea dx, vermelhoString
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 5
		lea dx, String2
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, crAd
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, lfAd
		int 21h

		jmp fimEscreve


arquivoMagenta:

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 9
		lea dx, magentaString
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 5
		lea dx, String2
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, crAd
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, lfAd
		int 21h

		jmp fimEscreve

arquivoMarrom:

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 8
		lea dx, marromString
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 5
		lea dx, String2
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, crAd
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, lfAd
		int 21h

		jmp fimEscreve

arquivoCinzaClaro:

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 13
		lea dx, cinzaClaroString
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 5
		lea dx, String2
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, crAd
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, lfAd
		int 21h

		jmp fimEscreve

arquivoCinzaEscuro:

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 14
		lea dx, cinzaEscuroString
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 5
		lea dx, String2
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, crAd
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, lfAd
		int 21h

		jmp fimEscreve

arquivoAzulClaro:

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 12
		lea dx, azulClaroString
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 5
		lea dx, String2
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, crAd
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, lfAd
		int 21h

		jmp fimEscreve

arquivoVerdeClaro:

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 13
		lea dx, verdeClaroString
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 5
		lea dx, String2
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, crAd
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, lfAd
		int 21h

		jmp fimEscreve

arquivoCianoClaro:

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 13
		lea dx, cianoClaroString
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 5
		lea dx, String2
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, crAd
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, lfAd
		int 21h

		jmp fimEscreve

arquivoVermelhoClaro:

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 16
		lea dx, vermelhoClaroString
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 5
		lea dx, String2
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, crAd
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, lfAd
		int 21h

		jmp fimEscreve

arquivoMagentaClaro:

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 15
		lea dx, magentaClaroString
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 5
		lea dx, String2
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, crAd
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, lfAd
		int 21h

		jmp fimEscreve

arquivoAmarelo:

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 9
		lea dx, amareloString
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 5
		lea dx, String2
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, crAd
		int 21h

		mov ah, 40h
		mov bx, handlerEscrever
		mov cx, 1
		lea dx, lfAd
		int 21h

		jmp fimEscreve

fimEscreve:
		pop dx
		pop cx
		pop bx
		pop ax

		ret		
															
															
										
		
		 
codigo   ends
         end    inicio              ; inicia execu��o pelo r�tulo 'inicio'
		 
		 
		 
		 


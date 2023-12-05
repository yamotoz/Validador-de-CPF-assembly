
org 100h 
.DATA



;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;DIGITE O CPF AQUI
num DB 4,1,9,2,9,3,4,4,3,4,1  
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;CPF 419.293.443-41



msg0 DB "Primeiro Digito:",24h                       
msg1 DB "  Segundo Digito:",24h 
msg2 DB "  VALIDO ",24h                             
msg3 DB "  INVALIDO ",24h 

dv1 DB 0," ",'$'  

.CODE
;Primeira-Parte 

lea dx,msg0             ; O endereco vai pra DX.
mov ah,09h              ; Configura a impressao da funcao DOS.
int 21h                 ; Chama a interrupcao 21h para imprimir a mensagem.  



lea ax,num              ; Carrega o numero em AX.

mov si, ax              ; Move o numero para SI.      

mov dx, 0               ; DX == 0.

mov bl,10               ; BL == 10 

mov cx,9                ; CX == 9                         



inicio:
mov al, [si]            ; Move o valor atual do numero para AL.
mul bl                  ; AL X BL.
dec bl                  ; Decrementa BL.
add dx,ax               ; O resultado da soma ele armazena em DX.
inc si                  ; Incrementa o indice para acessar o proximo numero.
loop inicio             ; Repete o loop de CX ate ele ser zero.


mov ax,dx               ; Move o valor da soma para AX.
mov bl,11               ; Move o valor 11 para BL.
div bl                  ; Divide AX por BL.        
cmp ah,2                ; Compara o valor de AH com 2.
jl igual                ; if AH < 2, pula para igual.
cmp ah,1                ; Compara o valor de AH com 1.
je igual                ; if AH == 1, pula para igual.
jmp diferente           ; Pula para diferente caso contrario.                                                             
igual:
mov bl,0                ; Move 0 para BL.
jmp exit                ; Pula pro o final.
diferente:
sub bl,ah               ; AH menos o BL.         
exit:
mov ah,02h              ; Define a funcao de impressao do DOS.
mov dl,30h              ; Move o valor ASCII '0' para DL.
add dl,bl               ; Adiciona o valor de BL convertido para ASCII a DL.
int 21h                 ; Chama a interrupcao 21h para imprimir o digito verificador 1.


;VERIFICACAO                                          

mov al,[si]             ; Move o proximo numero para AL.
cmp bl,al               ; Compara o valor da subtracao com o numero em AL.
jz label1               ; if == AL, pula para label1.

lea dx,msg3             ; INVALIDO.                          
mov ah,09h              ; Define a funcao de impressao do DOS.
int 21h                 ; A partir da int 21 eu chamo a mensagem de erro.
jmp exit1               ; Pula para o final.

label1:
lea dx,msg2             ; VALIDO.            
mov ah,09h              ; Define a funcao de impressao do DOS.
int 21h                 ; A partir  da interrupcao 21h chamo a mensagem de erro.

mov dv1,bl              ; Move o valor do primeiro digito verificado para a variavel dv1.

;Segundo-Digito            


exit1: 

lea dx,msg1             
mov ah,09h              
int 21h 

mov cx, 0               ; Zera CX (contador para o loop)
mov ax, 0               ; Zera AX (armazena valor da soma)

lea ax,num

mov si, ax

mov dx,0h

mov bl,11

mov cx,10               ; Inicializa CX com 10 (contador para o loop)

inicio2:
mov al, [si]                                        
mul bl                                             
dec bl                                           
add dx,ax                                         
inc si                                            
loop inicio2                                        

mov ax,dx                                           
mov bl,11                                         
div bl                                       

cmp ah,2                                         
je igual2                                         
jmp diferente2                                      

igual2:
mov bl,0                                           
jmp exits                                     

diferente2:
sub bl,ah                                       

exits:
mov ah,02h                                          
mov dl,30h                                        
add dl,bl                                         
int 21h                                           

;Mecanica-Verificao 


mov al,[si]                  
cmp bl,al                                    
jz label2                                        

lea dx,msg3                                      
mov ah,09h                                       
int 21h                                   
jmp exit0                                         

label2:
lea dx,msg2                                        
mov ah,09h                                       
int 21h                                       

exit0:
int 20h                
;Final.

; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here

;Using a Stack to reverse My Name and after each reversed character append '*' by push after each group of
;two charaters-> (2 chars = 16 bits (stack only deals with 16 or 32 bits registers & memory variables)) -> two stars '**'.

.data    
    .stack 100
    var1 db "Mohammad"
    var2 db 16 dup(?)
    
.code
mov ax, @data
mov ds, ax



mov cx, 4
mov si, 0
  
mov ah, '*'
mov bh, 0

mov al, '*'

L1:
   push ax 
   
   mov bl, var1[si] 
   mov bh, var1[si+1] 
   push bx 
   add si, 2   
     
   loop L1 
          
          
mov cx, 4 

mov si, 0 

L2:
    
    pop bx 
    
    mov var2[si], bh
    
    mov dl, bl 
    
    pop bx
    
    mov var2[si+1], bl
    
    mov var2[si+2], dl
    
    mov var2[si+3], bh
    
    add si, 4
    
    loop L2 
    
ret





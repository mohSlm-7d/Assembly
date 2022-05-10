
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here

.code   
    mov cx, 12
    mov ah, 2
    
    rows:
        push cx
        
        mov dl, '$'
        mov cx, 20        
        
        cols:
            int 21h
            
            loop cols
        
        mov dl, 0Ah
        int 21h
        mov dl, 0Dh
        int 21h
        
        pop cx
        
     loop rows

ret





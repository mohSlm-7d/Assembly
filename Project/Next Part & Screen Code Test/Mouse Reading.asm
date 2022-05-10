
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here

.code
    mov ah, 2
    
    
    ;mov bh, 0h
    
    ;mov dh, 0h
    ;mov dl, 49h
    
    
    
    
    mov bh, 0
   
    mov dh, 0
    mov dl, 72
   
    int 10h
    
    
    mov cx, 6
    horizontal:        
        mov dl, '_'
        int 21h
        
        loop horizontal
        
        
    vertical:         
        

ret





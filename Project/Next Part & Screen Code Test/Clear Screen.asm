
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here 


.code
    mov ah, 2     
    mov bh, 0
    mov dh, 20
    mov dl, 0
    int 10h
    
    mov dl, 'E'
    int 21h
    mov dl, 'N'
    int 21h
    mov ah, 1
    int 21h
    
     mov  ax, 0003h       ; BIOS.SetVideoMode 80x25
    int  10h
    mov ah, 2
    mov bh, 7
    
    int 10h  
    
    
    
    mov ah, 2
    mov dl, 'A'
    int 21h
    mov dl, 'v'
    int 21h
    mov dl, 'g'
    int 21h
    mov dl, ':'
    int 21h
    mov dl, ' '
    int 21h 
    
    
    

ret


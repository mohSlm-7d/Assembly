
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here
.data
    k db 0
    res dw 0
    
    
.code
    mov ax, @data
    mov ds, ax
    
    
    mov ah, 1
    int 21h
    sub al, 30h
    
    mov k, al
    
    mov cl, al
    mov ch, 0
    

ret





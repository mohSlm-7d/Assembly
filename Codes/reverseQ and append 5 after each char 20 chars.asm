
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here 
.stack 40

.data
    userStr db 20 dup(?)
    reverseStr db 40 dup(?)

.code
    mov ax, @data
    mov ds, ax
    
    mov ah, 1
    
    mov cx, 20
    mov si, 0
    
    read:
        int 21h
        mov userStr[si], al
        inc si
        loop read
        
        mov cx, 20
        mov si, 0
        
        mov bl, 35h ; 5 in hexadecimal
        mov bh, 0h
    
    fillStack:
        push bx
        
        mov al, userStr[si]
        inc si
        mov ah, 0
        
        push ax        
        
        loop fillStack
        
        
        mov cx, 20
        mov si, 0
    
    reverse:
            pop ax
            mov reverseStr[si], al
            inc si
            
            pop bx
            mov reverseStr[si], bl
            inc si
            
            loop reverse 

ret





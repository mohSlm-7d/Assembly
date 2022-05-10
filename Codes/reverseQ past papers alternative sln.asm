
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
    
    mov cx, 20
    mov si, 0
    mov di, 19
    
    reverse:
            mov al, userStr[di]
            mov reverseStr[si], al
            
            inc si
            dec di
            
            mov reverseStr[si], 35h
            inc si
            
         loop reverse 

ret





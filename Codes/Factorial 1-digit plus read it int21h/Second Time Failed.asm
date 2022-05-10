
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here
.data
    k db 0
    result dw 0 
    
.code
    mov ax, @data
    mov ds, ax
    
    
    mov ah, 1
    int 21h
    sub al, 30h
    
    mov k, al
    mov ch, 0
    mov cl, k
    mov bl, k
    mov bh, 0
    
    mov result, 1
    
    mov al, 1
    
    mov ah, 0
    
    iterate:
        push cx
        
        
        mov cx, ax
        inc ax
        
        dec cx
        
        cmp cx, 0
        jmp next
        
        
        
        multiply:
            mov dx, result
            add result, dx
            
            loop multiply
        
        next:
        pop cx 
        
        
        loop iterate
    
    
        
ret






; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h


; add your code here

.stack 5

.data
    k db 0
    result db 0
    
.code
mov ax, @data
mov ds, ax

mov ah, 1
int 21h
sub al, 30h

mov k, al


mov cl, k
mov ch, 0

mov bl, 1d

iterate:
    push cx
    mov cl, bl
    inc bl
    call fact
    pop cx
        
    loop iterate



ret


proc fact
        mov al, result
    multiply: 
        
        add result, al
        loop multiply
    
    
    
    ret
fact endp


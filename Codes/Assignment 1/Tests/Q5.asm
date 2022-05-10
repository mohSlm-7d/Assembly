
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
.data
     te_st db 0
     
     count db 0
; add your code here 

.code
    mov ax, @data
    mov ds, ax
    

    mov bl, 000000b
    
    jmp Q5

L4:
    inc te_st
    ;Mov ah, 2

    ;Mov dl, 'S'
    ;Int 21h

    ;Mov dl, 'e'
    ;Int 21h

    ;Mov dl,  't'
    ;Int 21h

jmp exit 
 

Q5:
    mov bx, 5
    mov cx, 4
    
    Sub bx, cx
    Cmp bx, 0
    JG L4
;----------------

exit:
    ret






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
    
    jmp Q4

L3:
    inc te_st
    ;Mov ah, 2

    ;Mov dl, 'S'
    ;Int 21h

    ;Mov dl, 'e'
    ;Int 21h

    ;Mov dl,  't'
    ;Int 21h

jmp exit 
 

Q4:
    mov ax, -1
    Cmp ax, 0
    JL L3
;----------------

exit:
    ret





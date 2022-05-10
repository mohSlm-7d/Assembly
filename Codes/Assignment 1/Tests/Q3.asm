
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
    
    jmp Q3

L2:
    inc te_st
    Jmp exit
 

Q3:
    mov al, 11000000b
    add al, 0
    Jpe L2
;----------------

exit:
    ret





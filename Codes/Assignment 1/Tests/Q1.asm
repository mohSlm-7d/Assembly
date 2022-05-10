
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
    
    jmp Q1

L1:
    inc te_st
   

jmp exit 
 

Q1:
    Test bl, 001000b
    Jnz L1
     
    inc count
    
    Test bl, 010000b
    Jnz L1
    
    inc count
    
    Test bl, 100000b
    Jnz L1
    
    inc count
;----------------

exit:
    ret





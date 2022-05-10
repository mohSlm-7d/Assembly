
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

    mov bl, 111000b
    
    jmp Q2 
    
L1:
  inc te_st    
  jmp exit
  
    
Q2:
   or bl, 000111b
   cmp bl, 111111b
   JE L1


exit:
    ret





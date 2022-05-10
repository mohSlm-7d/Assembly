
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
.data

    count db 0
; add your code here 

.code 
     mov ax, @data
     mov ds, ax
     
     
    
    L1: 
        
        ;mov ah, 1
        ;int 21h
        
        
        mov ax, 3
        int 33h
        
        cmp bx, 1
        Je L1
        
        cmp cx, 4
        JL L1
        cmp cx, 50
        JG L1
        
        cmp dx, 50
        JL L1
        cmp dx, 75 
        JG L1
        
        jmp checkPosition
        
        loop L1
        
    
    

checkPosition:
    
    inc count       
    
    ret




proc Check
    
      cmp bx, 1
     ; Je checkPosition
    
    
    
    ret
    
    
    ;checkPosition:
    
    inc count       
    
    ret
  
check endp
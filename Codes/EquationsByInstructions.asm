
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here

.data
    Rval db ?
    Xval db 26
    Yval db 30
    Zval db 40
    
    result db ?
    count db 0          
.code
    mov ax, @data
    mov DS, ax
    ; negation(neg) before moving value to bl register.
    ;neg Xval
    ;mov bl, Xval
    
    ;Or moving then neg.
    mov bl, Xval
    neg bl
    
    mov cl, Yval
    sub cl, Zval
    
    
    add bl, cl
    mov bh, 0
    
    mov Rval, bl
    
    ;Jump keywords je, jo, jc.
    
    mov al, 1
    sub al, 1
    
    jz label1
    
    
    label1:
    mov bl, 7
    mov result, bl
    
    ;Advanced (Loop).
    mov bh, 0
    
    label2:
    inc bh
    dec bl
    jz label3
    
    ;cmp bl, 00
    
    
    
    loop label2 
    
    label3:
        mov count, bh
ret





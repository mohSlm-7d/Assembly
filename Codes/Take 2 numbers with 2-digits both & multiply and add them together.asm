
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here

.data
    num1 db 0
    num2 db 0
    AddRes db 0
    
    
    mulRes db 0
    
    
    str1 db "Enter Num1: "
    str2 db "Enter Num2: "
    ans db "Result is "
.code
    mov ax, @data
    mov ds, ax
    
    call print1
    
    call ReadNum
    
    mov num1, al
    
    call ReadNum
    
    mov cx, 10
    ;mov bl, 0
    
    digit:
        add al, num1
        loop digit
        
    mov num1, al
    
    
    call newline
    
    call print2
    call ReadNum
    
    mov num2, al
    call ReadNum
    
    mov cx, 10
    ;mov bl, 0
    dec_digit:
        add al, num2
        loop dec_digit
        
    
    mov num2, al
    
    call newline
    
    
    
    
    
    mov ch, 0
    mov cl, num1
    ;mov al, 0
    
    multiply:
        add al, num2
        loop multiply
        
        
        
        mov mulRes, al
        
        
        
    Addition:
        mov ah, 0
        mov al, num1
        add al, num2
        mov AddRes, al
    
    
    call answer
    
    
ret

ReadNum proc
    mov ah, 1
    int 21h
    sub al, 30h   
    ret            
ReadNum endp    


Print1 proc
    mov ah, 2
    mov si, 0
    mov cx, 12
    L2:
        mov dl, str1[si]
        int 21h
        inc si
        loop L2 
    ret
Print1 endp    


Print2 proc
    mov ah, 2
    mov si, 0
    mov cx, 12
    L:
        mov dl, str2[si]
        int 21h 
        inc si
        loop L
    ret
Print2 endp    


NewLine proc
    mov ah, 2
    mov dl, 0Ah
    int 21h
    mov dl, 0Dh
    int 21h 
    ret
newline endp  



Answer proc
    mov ah, 2
    mov si, 0
    mov cx, 10
    
    lbl:
    mov dl, ans[si]
    int 21h
    
    inc si
    loop lbl
    
    
    
    
    ;add Res, 30h
    mov dl, AddRes 
    
    
    sub dl, 10
    sub dl, 10
    
    add dl, 30h
    int 21h
    
    mov dl, 2
    add dl, 30h
    int 21h
    
    ret
answer endp    
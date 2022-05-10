
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here

.data
    myName db 8 dup(?)
    message db "Enter Your ID: " 
    
    Uni_ID db 8 dup(?)
    
.code
    mov ax, @data
    mov ds, ax
    
    
    mov cx, 8
    mov si, 0
    
    
    Input:
    mov Ah, 1
    int 21h
    
    mov myName[si], al
    inc si
    
    loop Input
                    
    
    mov cx, 8
    mov si, 0                    
    
    mov ah, 2
    mov dl, 0Ah ;new line.
    int 21h
    
    mov dl, 0x0D ; return carriage.
    int 21h
    
    Output:
    mov Ah, 2
    mov dl, myName[si]
    int 21h
    inc si
    
    loop Output
    
    
    mov cx, 8
    mov si, 7
    
    mov ah, 2
    mov dl, 0Ah ;new line.
    int 21h
    
    mov dl, 0x0D ; return carriage.
    int 21h
    
    Reverse:
    mov Ah, 2
    mov dl, myName[si]
    int 21h
    dec si
    
    loop Reverse 
    
    ;New line.
    mov dl, 0Ah
    int 21h
    
    
     mov dl, 0x0D
    int 21h
    
    mov cx, 15
    mov si, 0
    
    
    
    
    
    
    printMssg:
    mov ah, 2
    mov dl, message[si]
    int 21h
    inc si
    
    loop printMssg  
    
    
    
    mov cx, 8
    mov si, 0
    
    ID:
    mov ah, 1
    int 21h
    sub al, 30h
    
    mov Uni_ID[si], al
    inc si
    
    loop ID
        
ret





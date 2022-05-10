
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.data
     var1 db 0Ah,"HELLO"  
     var2 dw ? 
     arrayD dd 1h,2h,3h 
     arrayW dw 1h, 2h, 3h 
     
     myBytes db 80h, 66h, 0A5h
     
     ;To test result of summation with decimal values
     ;myBytes db 80d, 81d, 88d
     
     myBytesResult dw ?  
     
.code
mov ax, @data
mov ds, ax

mov bx,0Ah
;movzx eax, bx

;movzb var1         

;mov eax,0d



;Dword DoubleWord array reverse
;this emu8086 doesn't support 32bit registers like eax,ebx,etc.
;mov ax, [arrayD]

;xchg ax, arrayD+8
;mov arrayD, ax


;Word Array reverse

mov ax, arrayW

xchg ax, arrayW+4
mov arrayW, ax

mov ah, 0h
mov al, myBytes

mov bh, 0h
mov bl, myBytes+1

add ax, bx

mov bh, 0h
mov bl, myBytes+2

add ax, bx


;inc al
;inc ah
;inc ah

mov myBytesResult, ax
inc myBytesResult
dec myBytesResult  

ret






; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here
.stack 5
.data
var1 db "Hello"
var2 5 dup(?)

.code
mov ax, @data
mov ds, ax

mov cx, 5
mov si, 0

L1:
mov al, var1[si]
push ax ; AL always contains the data of var1 and AH is rubbish or garbage data.
inc si
loop L1



mov cx, 5
mov si, 0

L2:
pop ax
mov var2[si], al ;Taking the AL part that contains the data( The letter ('o','l','l','e','H') ) and the AH part is garbage data.
inc si
loop L2

ret





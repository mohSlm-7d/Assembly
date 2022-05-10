
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here

;Using a Stack to reverse My Name and after each reversed character append '*' by push after each group of
;two charaters-> (2 chars = 16 bits (stack only deals with 16 or 32 bits registers & memory variables)) -> two stars '**'.

.data    
    .stack 100
    var1 db "Mohammad"
    var2 db 16 dup(?)
    
.code
mov ax, @data
mov ds, ax



mov cx, 4 ; Mo ha mm ad (contains 8 chars) (4 groups that contains 2 chars (8 / 2 = 4) )
mov si, 0
  
mov ah, '*'
mov bh, 0

mov al, '*'

L1:
   push ax ;Push "**" in bottom of stack popped (pop) last (LIFO).
   
   mov bl, var1[si] ;moving first char in current group of 2 chars in var1.
   mov bh, var1[si+1] ;moving second(next) char in current group of 2 chars in var1.
   push bx ;Push bx that contains the current group of 2 consecutive chars.
   add si, 2 ;To next group of 2 chars in var1 
   
   ;2 chars (16 bits) (2 locations in RAM(var1 here) ).
     
   loop L1 ;Iterating through var1 and Push each two consecutive chars as a location in Stack (in bottom of Stack).
          
          
mov cx, 4 ; Each location in Stack is 16 bits(2 chars) & Mohammad has 8 chars which means 4 locations in Stack are used, 

;so 4 Pop instructions to pop (Mohammad) So 4 iterations(cx=4). And one pop in each iteration to pop the two stars"**".

mov si, 0 

L2:
    
    pop bx ;Pop the first location of Stack->(added last LIFO)->that contains the last added(by Push) group(Last group of 2 chars in Mohammad 
    ;(So it's "ad" (starting with "ad" in the {loop L2} ) ) ).
    
    mov var2[si], bh ; Here "ad" is stored in bx as "a" in bl & "d" in bh
    
    ;(Little Endian: Least significant value in least address & most signif. in  most address). So here in first
    
    ;location in var2 "d" will be stored (reverse string).
    
    mov dl, bl ;Storing the "a" in dl.
    
    pop bx ;Pop the two stars "**"(next location in Stack).
    
    mov var2[si+1], bl ;Moving the first Star stored in bl to next location in var2.   So in var2: "d", "*".
    
    mov var2[si+2], dl ; Moving the char "a" stored in dl->(after being moved in a previous step from bl to dl)->to
    
    ;next location in var2.  So in var2: "d", "*", "a".
    
    mov var2[si+3], bh ;Moving the second star stored in bx->(by pop)-> as bh to next location in var2.
    
    ;So in var2: "d", "*", "a", "*". 
    
    ;4 locations are filled in var2 (so move si 4 locations).
    
    add si, 4
    
    loop L2 ;Iterating through var2 to fill it with each popped group of 2 chars from stack and reversing the
    ;two chars in each group (starting from last froup in "Mohammad" which is "ad" and ending with the first group
    ;which is "Mo".  Reversed the groups order & reversed the 2 chars of each group.
    
    ;And in the loop appending a "*" after each char in var2.
    
ret





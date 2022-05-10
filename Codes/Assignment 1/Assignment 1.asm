.code
;move a value to bl to test it.
mov bl, 001000b

Jmp Q1

L1:
    Mov ah, 2

    Mov dl, 'S'
    Int 21h

    Mov dl, 'e'
    Int 21h

    Mov dl,  't'
    Int 21h

 
 
L2:
    Mov ah, 2

    Mov dl, 'P'
    Int 21h

    Mov dl, 'a'
    Int 21h

    Mov dl, 'r'
    Int 21h
 
    Mov dl, 'i'
    Int 21h

    Mov dl, 't'
    Int 21h

    Mov dl, 'y'
    Int 21h



L3:
    Mov ah, 2

    Mov dl, 'n'
    Int 21h

    Mov dl, 'e'
    Int 21h

    Mov dl, 'g'
    Int 21h

    Mov dl, 't'
    Int 21h

    Mov dl, 'i'
    Int 21h

    Mov dl, 'v'
    Int 21h

    Mov dl, 'e'
    Int 21h


L4: 
    Mov ah, 2

    Mov dl, '+'
    Int 21h






Q1:
    Test bl, 001000b
    Jnz L1

    Test bl, 010000b
    Jnz L1

    Test bl, 100000b
    Jnz L1
;----------------

Q2:
    Test bl, 111000b
    Jnz L1
;----------

;Jz ExitLbl
;-----------

Q3:
    ;Mov Ah, 1
    ;Int 21h
    mov al, 00000101b
    Jpe L2
;-----------

Q4:
    Cmp ax, 0
    JL L3
;-----------

Q5:
    Sub bx, cx
    Cmp bx, 0
    JG L4
;-----------


mov cx, 5
ExitLbl:
;This label used to avoid the execution of           ;previous labels and it's only for easily tracing ;the execution of the code on the emulator.
ret
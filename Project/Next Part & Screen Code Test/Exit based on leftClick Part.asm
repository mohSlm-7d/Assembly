
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here
.code   

  mov ax, @data
  mov ds, ax
  mov ax, 0013h  ; Set video mode 19 (320x200)
  int 10h
  mov ax, 0000h  ; Initialize the mouse
  int 33h        ; -> AX BX
  mov ax, 0001h  ; Show mouse arrow
  int 33h

MainLoop:
  mov  ax, 0003h ; Get mouse info
  int  33h       ; -> BX CX DX
  lea  dx, msg2  ; The "Not clicked" message
  test bx, 1     ; Test left mouse button
  jz   Up
Down:
  lea  dx, msg1  ; The "Clicked" message
Up:
  mov  ah, 09h   ; Print string
  int  21h
  mov  ah, 01h   ; Test keyboard
  int  16h       ; -> AX ZF
  jz   MainLoop  ; No key is waiting
  mov  ah, 00h   ; Fetch key
  int  16h       ; -> AX

  mov  ax, 0003h ; Set video mode 3 (80x25)
  int  10h
  mov  ax, 4C00h ; Terminate program
  int  21h

ret





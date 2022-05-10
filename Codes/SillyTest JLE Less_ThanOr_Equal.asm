  ORG 100h   
  
  .data
    testRes db 0
  
  .code
  mov ax, @data
  mov ds, ax
  
  MOV AL, -2
  CMP AL, 5
  JLE label1
  
   mov testRes, 10
   JMP exit

label1:
    mov testRes, 20

exit:
   RET
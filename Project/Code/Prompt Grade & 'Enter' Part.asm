
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.stack 100

; add your code here
.data
    EGradeTxt db "Enter Grade: "
    
    GradeDigits db 0, 0, 0
    grade db 0
    sum dw 0 
    
    AllGradesCount db 0
    
    FailCount db 0  
    FairCount db 0  
    GoodCount db 0  
    VGoodCount db 0  
    ExcellentCount db 0  
    
    
    AvgCount db 0
    Avg db 0
    
    
.code
    mov ax, @data
    mov ds, ax
    
    ;The following code is to output "Enter Grade" text.
    mov cx, 13
    mov ah, 2
    mov si, 0
    
    EnterGrade:
        mov dl, EGradeTxt[si]
        inc si
        int 21h
        
        loop EnterGrade
     
      
    call ReadGrades
    
    call CalculateAvg;;;;;Temp For Test  
        
ret

proc ReadGrades
    
       
    grades: 
        mov grade, 0 ;In the iterations following the first iteration the grade will be storing values
        ;from previous iteration, so in the beginning of each iteration assign 0 to grade.
        call Initialize_digits
        
        mov ah, 1
        
        mov cx, 3
        mov si, 0
        
        digits:
            int 21h
            
            ;If the user press th 'Enter' key 
            ;it jumps to newline lable which insert a new line 
            ;& returns carriage(returns to the beginning of the line)
            ;after that it starts the next iteration of drades label).
            
            ;call IsValid & inside update AllGradesCount.
            
            cmp al, 0Dh
            Je NewGrade
            
            
            
            mov GradeDigits[si], al
            sub GradeDigits[si], 30h     
            inc si
            
            loop digits
            
        NewGrade:
            ; Returning the cursor to the beginning
            ; of the grade (the first digit of the grade)
            ; and after that clearing each digit.
            mov ah, 2
             
            mov bh, 0 ; Page one (zero based).            
            mov dh, 0 ; Row one (zero based).
            mov dl, 13 ; Column 14 (zero based).
            int 10h
             
            push cx
             
            call ClearGrade
         
            pop cx ; pop the the value of cx used for digits loop stored in stack (pop it from stack to cx (needed for comparisons).
        
         
           cmp cx, 3
           Je NoEntry
      
        
        ;Check for special case that the user enters two digits (store the digits in a correct order in GradeDigits).
        cmp cx, 2
        JE SwapFor1DigitCase   
        
        ;Check for special case that the user enters one digit only(store the digits in a correct order in GradeDigits).
        cmp cx, 1
        JE SwapFor2DigitsCase
        
        call DigitsToGrade       
        
        
        
        call IsValid
        
        
        
        call SortGrade
        
        call AddToSum
        
        mov cx, 0
        
        loop grades
    
    
    exit_Read:
    ret
    
ReadGrades endp


proc SwapFor1DigitCase
    
    mov bl, 0    
    xchg bl, GradeDigits[0]
    mov GradeDigits[2], bl
        
    
    ;call DigitsToGrade       
        
    ;call SortGrade
        
    ;call AddToSum
    
    
    ;jmp ReadGrades
    ret

SwapFor1DigitCase endp



proc SwapFor2DigitsCase
    
    mov bl, GradeDigits[0]
    xchg GradeDigits[1], bl
    mov GradeDigits[2], bl
    
    mov GradeDigits[0], 0 
    
    ;call DigitsToGrade       
        
    ;call SortGrade
        
    ;call AddToSum
    
    
    ;jmp ReadGrades
    ret

SwapFor2DigitsCase endp
    


proc Initialize_digits
    mov si, 0
    mov cx, 3
    
    assign:
          mov GradeDigits[si], 0
          inc si
          
        loop assign
    ret
Initialize_digits endp

proc IsValid
    
    cmp grade, 0d
    JL NotValid
    
    cmp grade, 100d
    JG NotValid
    
    
    Valid:
        ;Update The counter of grades after entering a new grade.
        inc AllGradesCount
        ret
    
    
    
    NotValid:
        jmp grades    
        
IsValid endp    


proc DigitsToGrade
    HundredDigit:
        cmp GradeDigits[0], 0
        Je TenthsDigit
        
        
        mov bx, 0
        
        mov cl, GradeDigits[0]
        mov ch, 0
        
        HundredSum:
            add bl, 100
            loop HundredSum
            
        add grade, bl
                             
                             
            
   TenthsDigit:
        cmp GradeDigits[1], 0
        Je OnesDigit
        
        
        mov bx, 0
        
        mov cl, GradeDigits[1]
        mov ch, 0
        
        TengthsSum:
            add bl, 10
            loop TengthsSum
        
        add grade, bl    
    
   OnesDigit:
        cmp GradeDigits[2], 0
        Je exit_digitsToGrade
        
        
        mov bl, GradeDigits[2]
        add grade, bl 
        
        
    exit_digitsToGrade:
        ret
    
DigitsToGrade endp


proc AddToSum
    
    mov bl, grade
    mov bh, 0
    
    add sum, bx
    
    ret
AddToSum endp



proc SortGrade
    
    Sort:
        cmp grade, 50d
        JL Fail
        
        cmp grade, 60d
        JL Fair
    
        cmp grade, 75d
        JL Good
        
        cmp grade, 90d
        JL VGood
        
        cmp grade, 100
        JLE Excellent
    
    Fail:
        inc FailCount
        jmp exit_sort
    
    Fair:
        inc FairCount
        jmp exit_sort        
    
    Good:
        inc GoodCount
        jmp exit_sort
    
    VGood:
        inc VGoodCount
        jmp exit_sort
        
    Excellent:
        inc ExcellentCount
        jmp exit_sort
    
    exit_sort:
        ret
        
    
SortGrade endp


proc CalculateAvg
    
    mov bx, Sum
    mov al, AllGradesCount
    mov ah, 0
    
    cmp ax, 0d
    Je exit_CalculateAvg
    
    
    count:
        Sub bx, ax
        inc AvgCount
        
        cmp bx, ax
        JL exit_CalculateAvg
        
        loop count

    exit_CalculateAvg:          
        
        ret
        
CalculateAvg endp        


proc ClearGrade
              
     ;To clear the 3 digits of the grade 
     ;and even if the digits are not 3 (1 or 2) 
     ;the cursor will always return 
     ;to same column after clearing the grade.
     
     mov cx, 3         
     Clear:
                
             
          mov dl, 00h ; Null ascii code is 00h
          int 21h
                
          loop Clear
                
             
          ;Returning the cursor to the same column
          ;in the same row (row one) after clearing the grade.
          mov dl, 13
          int 10h     
    
    
    ret
    
ClearGrade endp


proc NoEntry
    
    mov GradeDigits[0], 101
    
    
    ret
    
NoEntry endp
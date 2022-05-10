
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

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
            
            cmp al, 0Dh
            Je newLine
            ;If the user press th 'Enter' key 
            ;it jumps to newline lable which insert a new line 
            ;& returns carriage(returns to the beginning of the line)
            ;after that it starts the next iteration of drades label).
            
            ;call IsValid & inside update AllGradesCount.
            
            sub al, 30h
            mov GradeDigits[si], al
            inc si
            
            loop digits
             
        newLine:       
             mov ah, 2
             
             mov bh, 0
             
             mov dh, 0
             mov dl, 13
             
             int 10h
             
                
        
        ;Update The counter of grades after entering a new grade.
        inc AllGradesCount
        
        ;Check for special case that the user enters two digits (store the digits in a correct order in GradeDigits).
        cmp cx, 2
        JE SwapFor1DigitCase   
        
        ;Check for special case that the user enters one digit only(store the digits in a correct order in GradeDigits).
        cmp cx, 1
        JE SwapFor2DigitsCase
        
        call DigitsToGrade       
        
        call SortGrade
        
        call AddToSum
        
        loop grades
    
    exit_Read:
    ret
    
ReadGrades endp


proc SwapFor1DigitCase
    
    mov bl, 0    
    xchg bl, GradeDigits[0]
    mov GradeDigits[2], bl
        
    
    call DigitsToGrade       
        
    call SortGrade
        
    call AddToSum
    
    
    jmp ReadGrades

SwapFor1DigitCase endp



proc SwapFor2DigitsCase
    
    mov bl, GradeDigits[0]
    xchg GradeDigits[1], bl
    mov GradeDigits[2], bl
    
    mov GradeDigits[0], 0 
    
    call DigitsToGrade       
        
    call SortGrade
        
    call AddToSum
    
    
    jmp ReadGrades

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
    
    mov bl, GradeDigits[0]
    add bl, 30h
    
    cmp bl, 30h
    JL  NotValid
    
    cmp bl, 31h
    JG NotValid
    
                   
    
                   
    mov bl, GradeDigits[1]
    add bl, 30h
    
    cmp bl, 30h
    JL NotValid
    
    cmp bl, 39h
    JG NotValid
    
    
    
    
    mov bl, GradeDigits[2]
    add bl, 30h
    
    cmp bl, 30h
    JL NotValid
    
    cmp bl, 39h
    JG NotValid
    
    
    exit_IsValid:   
        ret
    
    
    
    NotValid:
        ret    
        
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
    
    count:
        Sub bx, ax
        inc AvgCount
        
        cmp bx, ax
        JL exit_CalculateAvg
        
        loop count

    exit_CalculateAvg:          
        
        ret
        
CalculateAvg endp        
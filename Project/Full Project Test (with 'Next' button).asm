
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.stack 100

; add your code here
.data
    EGradeTxt db "Enter Grade: "
    
    GradeDigits db 0, 0, 0
    validGrade db 1
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
    
    FailTxt db "Fail"
    FairTxt db "Fair"  
    GoodTxt db "Good"  
    VGoodTxt db "Very Good"  
    ExcellentTxt db "Excellent"
    
    AvgTxt db "Average is: "
    
    ExitMessage db "To exit press on 'Next' in 10"
    MouseMessageCount db 10
    
    InLoopTenCount db 0
    
    
    ExitFlag db 0
    
    ClickXposition dw 0
    ClickYposition dw 0
    
    MouseLoopCount db 0
    
    
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
        
        
    call DrawNext 
         
    call PrintGradesCategories
    
    call PrintFailCount
    call PrintFairCount
    call PrintGoodCount
    call PrintVGoodCount
    call PrintExcellentCount
    
    mov cx, 0
    Run::
        push cx
        mov ah, 2
        
        mov  ax, 0000h  ; reset mouse
        int  33h
        
        call PrintNextMssg
        
        mov InLoopTenCount, 0
        mov MouseMessageCount, 10
        MouseInput:
            
            mov ax, 3
            int 33h
            cmp bx, 1
            Je exitRun
                       
            cmp InLoopTenCount, 10
            Je UpdateMessageCounters
            
            cmp MouseLoopCount, 100
            Je exitMouseLoop
                        
            
            inc MouseLoopCount
            
            inc InLoopTenCount           
            
            jmp MouseInput
        
        exitMouseLoop:
            mov MouseLoopCount, 0
            
            call ClearNextMssg
            
                
                
        mov ah, 2
        mov bh, 0
        mov dh, 0
        mov dl, 13
        int 10h
        
        mov validGrade, 1 ; Assuming the new value is valid and checking whether it's valid or not By (IsValid). In case that the value of previous grade entered was 
        ;invalid (so the validGrade is assigned to 0) therfore here I re-assign it to 1.
        
        ;In the iterations following the first iteration the grade will be storing values
        ;from previous iteration, so in the beginning of each iteration assign 0 to grade.
        
        mov grade, 0 
                
        call Initialize_digits
        call ReadGrade
        
        
        call DigitsToGrade
        
        call IsValid        
        cmp validGrade, 0
        Je Run
        
                
        call SortGrade
        
        call AddToSum
        
        call PrintFailCount
        call PrintFairCount
        call PrintGoodCount
        call PrintVGoodCount
        call PrintExcellentCount
        
        pop cx
        loop Run
        
        
       
exitRun:
    mov ClickXposition, cx
    mov ClickYposition, dx
    call CheckExit
    
    cmp ExitFlag, 0
    Je Run
    
    call ClearScreen
        
    call CalculateAvg
        
    call PrintAvg
    
    ret
    
UpdateMessageCounters:
    mov InLoopTenCount, 0
    dec MouseMessageCount
    call PrintMouseMessageCountInMessage
    jmp MouseInput
    

ret 



proc PrintNextMssg
    
   mov cx, 29
   mov si, 0 
        
   mov ah, 2
   mov bh, 0
   mov dh, 4
   mov dl, 0
   int 10h
   PrintExitMssg:
        mov dl, ExitMessage[si]
        inc si
        int 21h
        loop PrintExitMssg
    
    ret
PrintNextMssg endp


proc ClearNextMssg
    
    mov ah, 2
    mov bh, 0
    mov dh, 4
    mov dl, 0
    int 10h  
            
    mov cx, 29
    ClearExitMssg:
        mov dl, 00h                
        int 21h
        loop ClearExitMssg
    
    ret
ClearNextMssg endp


proc PrintMouseMessageCountInMessage
    
    mov ah, 2
    mov bh, 0
    mov dh, 4
    
    ;To clear the 0 of the '10' in the Next(Exit) Message.
    mov dl, 28
    int 10h    
    mov dl, 00h
    int 21h
    
    ;To print the MouseMessageCount of one digit in the end of the Next(Exit) Message.
    mov dl, 27
    int 10h
    mov dl, MouseMessageCount
    add dl, 30h
    int 21h 
     
    ret
PrintMouseMessageCountInMessage endp


proc CheckExit
    cmp ClickYposition, 30
    Jb NotValidExit
    
    cmp ClickYposition, 40
    Ja NotValidExit
    
    cmp ClickXposition, 580
    Jb NotValidExit
    
    cmp ClickXposition, 610
    Ja NotValidExit
    
    ValidExit:
        mov ExitFlag, 1
        ret
    
    NotValidExit:    
        ret
        
CheckExit endp

proc Initialize_digits
    mov si, 0
    mov cx, 3
    
    assign:
          mov GradeDigits[si], 0
          inc si
          
        loop assign
    ret
Initialize_digits endp


proc ReadGrade       
        
        mov ah, 1
        
        mov cx, 3
        mov si, 0
        
        ReadDigits:
            int 21h
            
            ;If the user press th 'Enter' key 
            ;it jumps to NewGrade lable which insert a new line 
            ;& returns carriage(returns to the beginning of the line)
            ;after that it starts the next iteration of drades label).
            
            ;call IsValid & inside update AllGradesCount.
            
            cmp al, 0Dh
            Je NewGrade
            
            
            sub al, 30h     
            mov GradeDigits[si], al
            
            inc si
            
            loop ReadDigits
            
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
           Je exit_Read
      
        
        ;Check for special case that the user enters two digits (store the digits in a correct order in GradeDigits).
        cmp cx, 2
        JE SwapFor1DigitCase   
        
        ;Check for special case that the user enters one digit only(store the digits in a correct order in GradeDigits).
        cmp cx, 1
        JE SwapFor2DigitsCase
        
        ret
           
    
    ;exit_Read: Used for invalid case(when the user doesn't enter 
    ;any digit(when the user hits Enter key in first digit).
    
    exit_Read:
    
        mov grade, 101d
        ret
    
ReadGrade endp


proc SwapFor1DigitCase
    
    mov bl, 0    
    xchg bl, GradeDigits[0]
    mov GradeDigits[2], bl
        
    ret

SwapFor1DigitCase endp



proc SwapFor2DigitsCase
    
    mov bl, GradeDigits[0]
    xchg GradeDigits[1], bl
    mov GradeDigits[2], bl
    
    mov GradeDigits[0], 0 
    
    ret

SwapFor2DigitsCase endp
    

proc DigitsToGrade
    HundredDigit:
        cmp GradeDigits[0], 0
        Je TenthsDigit
        
        cmp GradeDigits[0], 1
        JG GreaterThan100
        
        
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
    
    GreaterThan100:
        mov validGrade, 0
        ret
DigitsToGrade endp



proc IsValid
    cmp validGrade, 0
    Je NotValid
    
    cmp grade, 0d
    JL NotValid
    
    cmp grade, 100d
    JG NotValid
    
    
    Valid:
        ;Update The counter of grades after entering a new grade.
        inc AllGradesCount
        ret
    
    
    
    NotValid:
        mov validGrade, 0
        ret   
        
IsValid endp    



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
        
        jmp exit_sort ;if it didn't match any of the previous cases then it's not valid.
    
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


        


proc ClearGrade
              
     ;To clear the 3 digits of the grade 
     ;and even if the digits are not 3 (1 or 2) 
     ;the cursor will always return 
     ;to same column after clearing the grade.
     mov ah, 2
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


proc DrawNext
    
    mov ah, 2
    
    mov bh, 0
    mov dh, 2
    mov dl, 72 
    int 10h
    
    
    mov cx, 6
    mov dl, '-'
    UpperHorizontal:
        int 21h
        
        loop UpperHorizontal
        
    
    mov bh, 0
    mov dh, 3
    mov dl, 71
    int 10h   
    
    mov dl, '|'
    int 21h
    
   
    
    mov cx, 6
    spacesBefore:
        mov dl,' '
        int 21h
        
        loop spacesBefore
    
    mov dl, '|'
    int 21h   
    
    mov bh, 0
    mov dh, 4
    mov dl, 71
    int 10h  
    
    
    
    mov dl, '|'
    int 21h
    
    mov dl,' '
    int 21h        
    
    
    
    mov dl, 'N'
    int 21h    
    
    mov dl, 'e'
    int 21h
    
    mov dl, 'x'
    int 21h
    
    mov dl, 't'
    int 21h
    
    
    mov bh, 0
    mov dh, 4
    mov dl, 78
    int 10h
    
    mov dl, '|'
    int 21h
    
    
    
    mov bh, 0
    mov dh, 5
    mov dl, 71
    int 10h 
    
    mov dl, '|'
    int 21h
    
    mov cx, 6
    spacesAfter:
        mov dl,' '
        int 21h
        
        loop spacesAfter
    
    mov dl, '|'
    int 21h
    
    
    
    mov bh, 0
    mov dh, 6
    mov dl, 72
    int 10h  
    
    
    mov cx, 6
    mov dl, '-'
    LowerHorizontal:
        int 21h
        
        loop LowerHorizontal
    
    ret
DrawNext endp


proc PrintGradesCategories
    mov ah, 2
    
    mov bh, 0
    mov dh, 18
    mov dl, 0
    int 10h
    
    mov si, 0
    mov cx, 4 
    PrintFailTxt:
        mov dl, FailTxt[si]
        inc si
        int 21h
        loop PrintFailTxt
    
    mov dl, 09h
    int 21h
    
    mov dl, '|'
    int 21h
    
    
    mov si, 0
    mov cx, 4
    PrintFairTxt:
        mov dl, FairTxt[si]
        inc si
        int 21h
        loop PrintFairTxt
    
    mov dl, 09h
    int 21h
    
    mov dl, '|'
    int 21h
    
    mov si, 0
    mov cx, 4
    PrintGoodTxt:
        mov dl, GoodTxt[si]
        inc si
        int 21h
        loop PrintGoodTxt
    
    mov dl, 09h
    int 21h
    
    mov dl, '|'
    int 21h
    
    mov si, 0
    mov cx, 9
    PrintVGoodTxt:
        mov dl, VGoodTxt[si]
        inc si
        int 21h
        loop PrintVGoodTxt
        
    mov dl, 09h
    int 21h
    
    mov dl, '|'
    int 21h
  
                         
    mov si, 0
    mov cx, 9    
    PrintExcellentTxt:
        mov dl, ExcellentTxt[si]
        inc si
        int 21h
        loop PrintExcellentTxt
    
    
    inc dh 
    mov dl, 0
    int 10h
    mov dl, '_'
    
    mov cx, 50
    horizontalLine:
        int 21h
        loop horizontalLine    
    
    
    mov cx, 4
    Rows:
        mov dl, 0Ah
        int 21h
        mov dl, 0Dh
        int 21h
        mov dl, 09h
        int 21h
        push cx
      
        mov cx, 4
        Cols:               
                      
            cmp cx, 1
            Je ExcellentVerLine
            
            mov dl, '|'
            int 21h
                        
            mov dl, 09h
            int 21h 
            
            loop Cols
        ExcellentVerLine:
            mov dl, 09h
            int 21h
            
            
            mov dl, '|'
            int 21h
        pop cx
        loop Rows
    
    
    ret
PrintGradesCategories endp    

proc PrintFailCount
    
    mov bl, 0
    
    mov bh, 0
    mov dh, 22
    mov dl, 3
    int 10h
    
    mov bh, FailCount
    
    
    
    cmp bh, 100
    JL Check2ndDigitFail
    
    ThreeDigitsFailCount:           
        cmp bh, 100
        JL print3rdDigitFail
        
        sub bh, 100
        inc bl
        loop ThreeDigitsFailCount
    
    
    print3rdDigitFail:        
        mov dl, bl
        add dl, 30h
        int 21h
        mov bl, 0
        jmp TwoDigitsFailCount
        
    
    Check2ndDigitFail:
        cmp bh, 10
        JL OneDigitFailCount
        
        
    TwoDigitsFailCount:
        cmp bh, 10
        JL print2ndDigitFail    
        
        sub bh, 10
        inc bl
        loop TwoDigitsFailCount
    
    print2ndDigitFail:
        mov dl, bl
        add dl, 30h
        int 21h
    
    
     
    OneDigitFailCount:
        mov bl, bh
    
    mov dl, bl
    add dl, 30h
    int 21h    
        
    
    ret
PrintFailCount endp

proc PrintFairCount
    
    mov bl, 0
    
    mov bh, 0
    mov dh, 22
    mov dl, 12
    int 10h
    
    mov bh, FairCount
    
    
    
    cmp bh, 100
    JL Check2ndDigitFair
    
    ThreeDigitsFairCount:           
        cmp bh, 100
        JL print3rdDigitFair
        
        sub bh, 100
        inc bl
        loop ThreeDigitsFairCount
    
    
    print3rdDigitFair:        
        mov dl, bl
        add dl, 30h
        int 21h
        mov bl, 0
        jmp TwoDigitsFairCount
        
    
    Check2ndDigitFair:
        cmp bh, 10
        JL OneDigitFairCount
        
        
    TwoDigitsFairCount:
        cmp bh, 10
        JL print2ndDigitFair    
        
        sub bh, 10
        inc bl
        loop TwoDigitsFairCount
    
    print2ndDigitFair:
        mov dl, bl
        add dl, 30h
        int 21h
    
    
     
    OneDigitFairCount:
        mov bl, bh
    
    mov dl, bl
    add dl, 30h
    int 21h    
        
    
    ret
PrintFairCount endp

proc PrintGoodCount
    
    mov bl, 0
    
    mov bh, 0
    mov dh, 22
    mov dl, 21
    int 10h
    
    mov bh, GoodCount
    
    
    
    cmp bh, 100
    JL Check2ndDigitGood
    
    ThreeDigitsGoodCount:           
        cmp bh, 100
        JL print3rdDigitGood
        
        sub bh, 100
        inc bl
        loop ThreeDigitsGoodCount
    
    
    print3rdDigitGood:        
        mov dl, bl
        add dl, 30h
        int 21h
        mov bl, 0
        jmp TwoDigitsGoodCount
        
    
    Check2ndDigitGood:
        cmp bh, 10
        JL OneDigitGoodCount
        
        
    TwoDigitsGoodCount:
        cmp bh, 10
        JL print2ndDigitGood    
        
        sub bh, 10
        inc bl
        loop TwoDigitsGoodCount
    
    print2ndDigitGood:
        mov dl, bl
        add dl, 30h
        int 21h
    
    
     
    OneDigitGoodCount:
        mov bl, bh
    
    mov dl, bl
    add dl, 30h
    int 21h    
        
    
    ret
PrintGoodCount endp    
    
proc PrintVGoodCount
    
    mov bl, 0
    
    mov bh, 0
    mov dh, 22
    mov dl, 33
    int 10h
    
    mov bh, VGoodCount
    
    
    
    cmp bh, 100
    JL Check2ndDigitVGood
    
    ThreeDigitsVGoodCount:           
        cmp bh, 100
        JL print3rdDigitVGood
        
        sub bh, 100
        inc bl
        loop ThreeDigitsVGoodCount
    
    
    print3rdDigitVGood:        
        mov dl, bl
        add dl, 30h
        int 21h
        mov bl, 0
        jmp TwoDigitsVGoodCount
        
    
    Check2ndDigitVGood:
        cmp bh, 10
        JL OneDigitVGoodCount
        
        
    TwoDigitsVGoodCount:
        cmp bh, 10
        JL print2ndDigitVGood    
        
        sub bh, 10
        inc bl
        loop TwoDigitsVGoodCount
    
    print2ndDigitVGood:
        mov dl, bl
        add dl, 30h
        int 21h
    
    
     
    OneDigitVGoodCount:
        mov bl, bh
    
    mov dl, bl
    add dl, 30h
    int 21h    
        
    
    ret
PrintVGoodCount endp    

proc PrintExcellentCount
    
    mov bl, 0
    
    mov bh, 0
    mov dh, 22
    mov dl, 45
    int 10h
    
    mov bh, ExcellentCount
    
    
    
    cmp bh, 100
    JL Check2ndDigitExcellent
    
    ThreeDigitsExcellentCount:           
        cmp bh, 100
        JL print3rdDigitExcellent
        
        sub bh, 100
        inc bl
        loop ThreeDigitsExcellentCount
    
    
    print3rdDigitExcellent:        
        mov dl, bl
        add dl, 30h
        int 21h
        mov bl, 0
        jmp TwoDigitsExcellentCount
        
    
    Check2ndDigitExcellent:
        cmp bh, 10
        JL OneDigitExcellentCount
        
        
    TwoDigitsExcellentCount:
        cmp bh, 10
        JL print2ndDigitExcellent    
        
        sub bh, 10
        inc bl
        loop TwoDigitsExcellentCount
    
    print2ndDigitExcellent:
        mov dl, bl
        add dl, 30h
        int 21h
    
    
     
    OneDigitExcellentCount:
        mov bl, bh
    
    mov dl, bl
    add dl, 30h
    int 21h    
        
    
    ret
PrintExcellentCount endp    

proc CalculateAvg
    
    mov bx, Sum
    mov al, AllGradesCount
    mov ah, 0
    
    cmp ax, 0d
    Je exit_CalculateAvg
    
    mov cx, 0
    count:
        Sub bx, ax
        inc AvgCount
        
        cmp bx, ax
        JL exit_CalculateAvg
        
        loop count

    exit_CalculateAvg:          
        mov al, AvgCount
        mov Avg, al
        ret
        
CalculateAvg endp


proc ClearScreen
    mov ax, 0003h       ; BIOS.SetVideoMode 80x25
    int 10h
    
    mov ah, 2
    
    mov bh, 7
    mov dh, 0
    mov dl, 0
    int 10h     
    
    ret
ClearScreen endp

proc PrintAvg
    
    mov ah, 2
    
    mov bh, 7
    mov dh, 0
    mov dl, 0
    int 10h  
    
    
    mov si, 0
    mov cx, 12
    mov ah, 2
    AvgTxtPrint:
        mov dl, AvgTxt[si]
        inc si
        int 21h
        
        loop AvgTxtPrint
        
       
    
    mov bh, Avg
    
    mov bl, 0   
    
    cmp bh, 100
    JL Check2ndDigitAvg
    
    ThreeDigitsAvg:           
        cmp bh, 100
        JL print3rdDigitAvg
        
        sub bh, 100
        inc bl
        loop ThreeDigitsAvg
    
    
    print3rdDigitAvg:        
        mov dl, bl
        add dl, 30h
        int 21h
        mov bl, 0
        jmp TwoDigitsAvg
        
    
    Check2ndDigitAvg:
        cmp bh, 10
        JL OneDigitAvg
        
        
    TwoDigitsAvg:
        cmp bh, 10
        JL print2ndDigitAvg    
        
        sub bh, 10
        inc bl
        loop TwoDigitsAvg
    
    print2ndDigitAvg:
        mov dl, bl
        add dl, 30h
        int 21h
    
    
     
    OneDigitAvg:
        mov bl, bh
    
    mov dl, bl
    add dl, 30h
    int 21h    
    
    ret
PrintAvg endp
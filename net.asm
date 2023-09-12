.model small
.stack 100
.data
    ; Messages
    displayNetPay   db 13, 10, "*****************************"
                    db 13, 10, "::Welcome to NET PAY Module::"
                    db 13, 10, "*****************************$"

    exitNetPay      db 13, 10, "************************************"
                    db 13, 10, "::Exit NET PAY Module Successfully::"
                    db 13, 10, "************************************$"

    askDeduct       db 13,10, "Staff Contain Any Deduction/Allowance? (y=Yes/n=No): $"
    enterDeduct     db 13,10, "-->Deduction Amount (0000.00 < Amount < 9999.99): $"
    enterAllow      db 13,10, "-->Allowance Amount (0000.00 < Amount < 9999.99): $"
    inputErr        db 13,10, "<<Only Accept Integer Value Amount (EXP FORMAT:0123.45)..Re-enter again>>$"
    err_yesNo       db 13, 10, "<<Please enter y or n only>>$"
    enterErr	    db 13,10, "<<Please Enter 4 Digit Whole Number & 2 Digit Decimal Number...>>$"
    confirmAmount   db 13,10, "Confirm Deduction/Allowance amount? (y=Yes/n=No): $"
    displayTotalNet db 13,10,"Total Net Pay = $"

    newline 	    db 13, 10, '$'

    count           db 0
    temp1	    dw 0
    temp2           db 0
    integer         dw 1000,100,10,1
    decimal	    db 10,1
    tempDeductInt   dw 0
    tempDeductDec   db 0
    tempAllowInt    dw 0
    tempAllowDec    db 0
    tempNetPayInt   dw 0
    netPayDec	    db 2 dup(0)
    netPayInt	    db 4 dup(0)
    realDec	    db 2 dup(0)

    ; Constants
    YES             equ 'y'
    NO              equ 'n'
    MAX_DAYS        equ 29h
.code
main proc
    mov ax, @data
    mov ds, ax

    call displayWelcomeNet
    jmp yesNoAmount

yesNoAmount:
    mov count,3
    mov ah, 09h
    lea dx, askDeduct
    int 21h

    ; Read user input
    mov ah, 01h
    int 21h
    call yesNo1
    jmp inputDeduct

inputDeduct:
    ; Ask for deduction amount
    mov ah, 09h
    lea dx, enterDeduct
    int 21h

    mov count,1
    mov cx, 4      ; Allow up to 4 characters for input
    mov si, 0

    ; Read and validate deduction amount
    call readDeduct
    mov ax,temp1
    mov tempDeductInt,ax
    mov bl,temp2
    mov tempDeductDec,bl
    mov temp1,0h
    mov temp2,0h
    jmp inputAllow

inputAllow:
    ; Ask for allowance amount
    mov ah, 09h
    lea dx, enterAllow
    int 21h

    mov count,2
    mov cx, 4      ; Allow up to 4 characters for input
    mov si, 0

    ; Read and validate deduction amount
    call readDeduct
    mov ax,temp1
    mov tempAllowInt,ax
    mov bl,temp2
    mov tempAllowDec,bl
    mov temp1,0h
    mov temp2,0h
    jmp confirmGua

confirmGua:
    mov count,4
    mov ah,09h
    lea dx,confirmAmount
    int 21h

    call confirmMoney

calcInt:
    call netpay		;display net pay
    mov ax,4680		;Gross Pay
    mov bx,tempAllowInt  ;Allowance
    add ax,bx
    mov bx,tempDeductInt ;Deduction
    sub ax,bx
    mov bx,840		;Bonus
    add ax,bx
    mov tempNetPayInt,ax
    call calcDec
    ret

calcDec:
    mov ax,0
    mov al,88	;decimal bonus
    mov bl,tempDeductDec	;52
    mov dl,tempAllowDec		;96
    add al,dl
    sub al,bl	;total=134 86h
    mov bl,100
    div bl
    mov netPayDec[0],al		;01
    mov netPayDec[1],ah		;34
    mov ax,0
    mov al,netPayDec[1]
    mov bl,10
    div bl
    mov realDec[0],al
    mov realDec[1],ah
    call convertIntDecimal
    ret

convertIntDecimal:
    mov ax,0
    mov dx,0
    mov bx,0
    mov bl,netPayDec[0]
    add tempNetPayInt,bx
    mov ax,tempNetPayInt  
    mov bx,100
    div bx
    mov bl,10
    div bl
    mov netPayInt[0],al
    mov netPayInt[1],ah
    mov netPayInt[2],dl
    mov netPayInt[3],dh

    ;DISPLAY NUMBER 1 DIGIT
    MOV AH,02H
    MOV DL,netPayInt[0]
    ADD DL,30H
    INT 21H

    ;DISPLAY NUMBER 2 DIGIT
    MOV AH,02H
    MOV DL,netPayInt[1]
    ADD DL,30H
    INT 21H

    MOV AX,0
    MOV AL,netPayInt[2]	
    DIV BL    		
    MOV netPayInt[2],AL	
    MOV netPayInt[3],AH	
	
    ;DISPLAY NUMBER 3 DIGIT
    MOV AH,02H
    MOV DL,netPayInt[2]
    ADD DL,30H
    INT 21H

    ;DISPLAY NUMBER 4 DIGIT
    MOV AH,02H
    MOV DL,netPayInt[3]
    ADD DL,30H
    INT 21H
    call convertDecDecimal
    ret
jumper1: jmp calcInt
jumper2: jmp yesNoAmount
jumper3: jmp inputDeduct
jumper4: jmp inputAllow
jumper5: jmp confirmGua
convertDecDecimal:
    mov ah,02h
    mov dl,'.'
    int 21h

    ;DISPLAY NUMBER 1 DIGIT
    MOV AH,02H
    MOV DL,realDec[0]
    ADD DL,30H
    INT 21H

    ;DISPLAY NUMBER 2 DIGIT
    MOV AH,02H
    MOV DL,realDec[1]
    ADD DL,30H
    INT 21H

    jmp exit

exit:
    mov ah,09h
    lea dx,exitNetPay 
    int 21h

    ; Exit program
    mov ah, 4ch
    int 21h
main endp
yesNo1:
    cmp al, YES
    je check1
    cmp al, NO
    je jumper1
    jmp errYesNo
    ret

yesNo2:
    cmp al, YES
    je check1
    cmp al, NO
    je jumper2
    jmp errYesNo
    ret

check1:
    mov al,count
    cmp al,1
    je jumper3
    cmp al,2
    je jumper4
    cmp al,3
    je jumper3
    cmp al,4
    je jumper1
    ret

check2:
    mov al,count
    cmp al,3
    je jumper2
    cmp al,4
    je jumper5

errYesNo:
    call printErrorMessage
    call check2
displayWelcomeNet:
    mov ah, 09h
    lea dx, displayNetPay
    int 21h
    ret

printErrorMessage:
    mov ah, 09h
    lea dx, err_yesNo
    int 21h
    call printNewLine
    ret

readDeduct:
    mov ah, 01h        
    int 21h

    ; Check if the input is a valid digit ('0' to '9')
    call chkErr

    ; If it's a valid digit, store it and proceed
    jmp combineInt
    ret

chkErr:
    cmp al, 13
    je errorEnter
    cmp al, '0'
    jl errMsg
    cmp al, '9'
    jg errMsg
    ret

combineInt:
    sub al, 30h           ; Convert ASCII digit to numeric value
    mov ah, 0             ; Clear the upper 8 bits of ax
    mov bx, integer[si]   ; Load the multiplier from the integer array

    ; Multiply ax by the value in bx (multiplier from the integer array)
    mul bx

    ; Add the result to temp
    add temp1, ax

    ; Move to the next multiplier (e.g., 100, 10, 1)
    add si,2h

    ; Check if we've reached the maximum allowed input length (4)
    dec cx
    jz addDecimal  ; If so, terminate the input

    jmp readDeduct

addDecimal:
    mov ah, 02h
    mov dl, '.'
    int 21h
    mov si, offset decimal
    mov cx, 2

readDecimal:
    mov ah, 01h
    int 21h

    call chkErr

    sub al, 30h
    xor ah, ah
    mov bl, [si]
    mul bl
    add temp2, al
    inc si
    dec cx
    jnz readDecimal  ; Continue reading decimal digits if cx is not zero

    jmp readDone  ; Only exit when both decimal digits are read

readDone:
    ret

errMsg:
    mov temp1,0h
    mov temp2,0h
    ; Display error message
    mov ah, 09h
    lea dx, inputErr
    int 21h
    call printNewLine
    call check1

errorEnter:
    mov temp1,0h
    mov temp2,0h
    mov ah, 09h
    lea dx, enterErr
    int 21h
    call printNewLine
    call check1

confirmMoney:
    mov ah,01h
    int 21h
    call yesNo2
    call check1
    
printNewLine:
    mov ah, 09h
    lea dx, newline
    int 21h
    ret   

netpay:
    mov ah,09h
    lea dx,displayTotalNet
    int 21h
    ret
end main

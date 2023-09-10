.model small
.stack 100
.data
    displayOvertime 	db 13, 10, "******************************"
    		    	db 13, 10, "::Welcome to OVERTIME Module::"
    		    	db 13, 10, "******************************$"
    
    exitOvertime 	db 13, 10, "*************************************"
    		 	db 13, 10, "::Exit OVERTIME Module Successfully::"
    		 	db 13, 10, "*************************************$"
    
    comfirm 		db 13, 10, "Staff Overtime?(y=Yes/n=No): $"
    err_yesNo 		db 13, 10, "Please enter y or n only$"
    promptWorkDays 	db 13, 10, "Total Number of Working Days(0-29): $"
    errDays 		db 13, 10, "Digit Acceptable Range(0-9) only...Please insert a new day!!! $"
    errorDays 		db 13, 10, "Days cannot above 29 days...Please insert a new day!!! $"
    correct_Days 	db 13, 10, "Correct day input? (y/n): $"
    display_OTHours 	db 13, 10, "Total Overtime Hours: $"
    error          	db 13,10,"Please enter y or n only$"
    
    newline 		db 13, 10, '$'

    ; Constants
    YES equ 'y'
    NO equ 'n'

    ; Variables
    digit 		db 2 dup(?) ; Array to store the digits
    total_overtime 	db 4 dup(?)
    workDays 		db 0
    days  		dw ?  

.code
main proc
    mov ax, @data
    mov ds, ax

    call displayWelcome
    jmp otConfirmation

otConfirmation:
    mov ah, 9h
    lea dx, comfirm
    int 21h

    mov ah, 01h
    int 21h
    cmp al, YES
    je getWorkDays
    cmp al, NO
    jne errYesNo_OT
    jmp exitProgram

getWorkDays:
    call printNewLine
    lea dx, promptWorkDays
    int 21h

    mov cx, 2
    mov si, 0
    call getUserInput

    ; Validate input
    mov al, digit[0]
    mov dl, 10
    mul dl
    add al, digit[1]
    cmp al, 29
    ja highDaysErr
    mov workDays, al

confirmDay:
    mov ah, 9h
    lea dx, correct_Days
    int 21h

    mov ah, 01h
    int 21h
    cmp al, YES
    je displayTotalOT
    cmp al, NO
    jne errYesNo_confirm
    dec si
    mov workDays, 0
    jmp otConfirmation

displayTotalOT:
    call printNewLine
    lea dx, display_OTHours
    int 21h

    mov ah, 0
    mov al, workDays
    mov bx, 9
    mul bx
    mov dx, 12Ch	;decimal = 300
    sub dx, ax
    mov days,dx		

    ;convert to decimal
    call convertDecimal
    jmp exitProgram

errYesNo_OT:
    call printErrorMessage
    jmp otConfirmation

errYesNo_confirm:
    call printErrorMessage
    jmp confirmDay

daysError:
    call printErrorDays
    jmp getWorkDays

highDaysErr:
    call dateTooHigh
    jmp getWorkDays

exitProgram:
    call printNewLine
    mov ah, 09h
    lea dx,exitOvertime
    int 21h

    ;exit
    mov ah, 4ch
    int 21h

main endp

; Custom procedures
getUserInput:
    mov ah, 01h		;al = 1, al = 5
    int 21h

    ; Check if the input is a valid digit ('0' to '9')
    cmp al, '0'
    jl daysError
    cmp al, '9'
    jg daysError

    ; If it's a valid digit, store it and proceed
    mov digit[si], al
    sub digit[si], 30h
    inc si
    loop getUserInput

    ret

convertDecimal:
    xor ax,ax
    xor dx,dx
    mov ax,days
    MOV BX,100
    DIV BX
    MOV BL,10
    DIV BL
    MOV total_overtime [0],AL
    MOV total_overtime [1],AH
    MOV total_overtime [2],DL  ;60
    MOV total_overtime [3],DH
	
    ;DISPLAY NUMBER 1 DIGIT
    MOV AH,02H
    MOV DL,total_overtime [0]
    ADD DL,30H
    INT 21H

    ;DISPLAY NUMBER 2 DIGIT
    MOV AH,02H
    MOV DL,total_overtime [1]
    ADD DL,30H
    INT 21H
	
    MOV AX,0
    MOV AL,total_overtime [2] 	;AX = 0060
    DIV BL    		;AL=00 AH=00
    MOV total_overtime [2],AL	;AL=00
    MOV total_overtime [3],AH	;AH=00
	

    ;DISPLAY NUMBER 3 DIGIT
    MOV AH,02H
    MOV DL,total_overtime [2]
    ADD DL,30H
    INT 21H

    ;DISPLAY NUMBER 4 DIGIT
    MOV AH,02H
    MOV DL,total_overtime [3]
    ADD DL,30H
    INT 21H
    ret

displayWelcome:
    mov ah, 09h
    lea dx, displayOvertime
    int 21h
    ret

printNewLine:
    mov ah, 09h
    lea dx, newline
    int 21h
    ret   

printErrorDays:
    mov ah, 09h
    lea dx, errDays
    int 21h
    call printNewLine
    ret

printErrorMessage:
    mov ah, 09h
    lea dx, err_yesNo
    int 21h
    call printNewLine
    ret

dateTooHigh:
    mov ah, 09h
    lea dx, errorDays 
    int 21h
    call printNewLine
    ret
end main
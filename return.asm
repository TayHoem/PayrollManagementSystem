.MODEL SMALL
.DATA
    returnList1     db 13,10,"		    *****************************"
                    db 13,10,"		    ||       RETURN LIST       ||"
                    db 13,10,"		    *****************************$"
    otReturn        db 13,10,"		    ||1.Log In Module          ||",13,10,"		    ||2.Staff Info Module      ||", "$"
    grossPayReturn  db 13,10,"		    ||1.Log In Module          ||",13,10,"		    ||2.Staff Info Module      ||",13,10,"		    ||3.Overtime Module        ||", "$"
    bonusReturn     db 13,10,"		    ||1.Log In Module          ||",13,10,"		    ||2.Staff Info Module      ||",13,10,"		    ||3.Overtime Module        ||",13,10,"		    ||4.Gross Pay Module       ||", "$"
    netPayReturn    db 13,10,"		    ||1.Log In Module          ||",13,10,"		    ||2.Staff Info Module      ||",13,10,"		    ||3.Overtime Module        ||",13,10,"		    ||4.Gross Pay Module       ||",13,10,"		    ||5.Bonus Module           ||","$"
    returnList3     db 13,10,"		    *****************************$"
    newline         	db 13, 10, '$'
    returnSelect 	db 13,10,"Please Select One Of It To Return: $"
    askReturn   	db 13,10,"Do you want to return?(y=yes/n=no): $"
    welcome1    	db 13,10,"Welcome to LogIn$"
    welcome2    	db 13,10,"Welcome to Staff Information$"
    welcome3    	db 13,10,"Welcome to Overtime$"
    welcome4    	db 13,10,"Welcome to Gross Pay$"
    welcome5    	db 13,10,"Welcome to Bonus$"
    welcome6    	db 13,10,"Welcome to Net Pay$"
    welcome7    	db 13,10,"Welcome to Reporting$"
    error 		db 13,10,"Please choose number in the list only!!!$"
    errYesNo		db 13,10,"Please enter y or n only!!!$"
    calculate   	dw 0
    loopCount		db 5 dup(0)
    select 		db ?

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
Login:
    mov loopCount[0],1
    mov ah,09h
    lea dx,welcome1
    int 21h
    jmp staff

staff:
    mov loopCount[1],2
    mov ah,09h
    lea dx,welcome2
    int 21h
    jmp ot

ot:
    mov loopCount[2],3
    mov calculate,1
    mov ah,09h
    lea dx,welcome3
    int 21h
    call returnOrNot

grossPay:
    mov loopCount[3],4
    mov calculate,2
    mov ah,09h
    lea dx,welcome4
    int 21h
    call returnOrNot
JL1: jmp Login

bonus:
    mov loopCount[4],5
    mov calculate,3
    mov ah,09h
    lea dx,welcome5
    int 21h
    call returnOrNot
JL2: jmp staff
JL3: jmp ot
JL5: jmp bonus
netPay:
    mov calculate,4
    mov ah,09h
    lea dx,welcome6
    int 21h
    call returnOrNot
JL6: jmp netPay
reporting:
    mov ah,09h
    lea dx,welcome7
    int 21h
    jmp exit
JL4: jmp grossPay

choose:		;choose return to where
    add calculate,1	;if calc=1+1=2
    mov dx,calculate
    mov si,0
    mov cx,dx		;loop 2 times
loopWantedPlaces:
    mov ah,0h
    mov al,loopCount[si]	;loopCount[0]=1
    mov bl,select		;select=2
    cmp al,bl
    je GoesWantedPlaces
    inc si		;loopCount[1]=2
loop loopWantedPlaces
    sub calculate,1
    jmp errMsg		
    ret	

GoesWantedPlaces:
    cmp select,1
    je JL1
    cmp select,2
    je JL2
    cmp select,3
    je JL3
    cmp select,4
    je JL4
    cmp select,5
    je JL5
    jmp errMsg	

compareNo:
    ;not return compare calculate
    cmp calculate,1
    je JL4
    cmp calculate,2
    je JL5
    cmp calculate,3
    je JL6
    cmp calculate,4
    je reporting

returnOrNot:
    lea dx,askReturn
    int 21h

    mov ah,01h
    int 21h
    cmp al,'y'
    je returnWhere
    cmp al,'n'
    je compareNo
    mov ah,09h
    lea dx,errYesNo
    int 21h
    call printNewLine
    jmp returnOrNot
    
returnWhere:
    cmp calculate,1
    je determine1
    cmp calculate,2
    je determine2
    cmp calculate,3
    je determine3
    cmp calculate,4
    je determine4

determine1:
    lea si,otReturn 
    jmp loopReturn

determine2:
    lea si,grossPayReturn
    jmp loopReturn

determine3:
    lea si,bonusReturn
    jmp loopReturn

determine4:
    lea si,netPayReturn 
    jmp loopReturn

loopReturn:
    mov ah,09h
    lea dx,returnList1
    int 21h
    mov cx,1
returnBah:
    mov ah,09h
    lea dx,[si]
    int 21h
    inc si
loop returnBah
    mov ah,09h
    lea dx,returnList3
    int 21h
    jmp readReturnSelect
    
readReturnSelect:
    mov ah,09h
    lea dx,returnSelect
    int 21h
    jmp selectWhat

selectWhat:
    mov ah,01h
    int 21h
    sub al,30h
    mov select,al
    call choose
    ret
   
errMsg:
    mov ah,09h
    lea dx,error
    int 21h
    jmp readReturnSelect
    
printNewLine:
    mov ah, 09h
    lea dx, newline
    int 21h
    ret  
exit:
    mov ah, 4ch
    int 21h     ; Exit program

MAIN ENDP
END MAIN
.model small
.stack 100
.data
;LOGO
	logoAirAsia	DB 13,10,"                		    Welcome To"
			DB 13,10,"             AAAAA   IIIIII RRRRRR    AAAAA   SSSSSS  IIIIII  AAAAA"
			DB 13,10,"            A     A    I    R     R  A     A  S         I    A     A"
			DB 13,10,"            AAAAAAA    I    RRRRRR   AAAAAAA  SSSSS     I    AAAAAAA"
			DB 13,10,"            A     A    I    R    R   A     A       S    I    A     A"
			DB 13,10,"            A     A  IIIIII R     R  A     A  SSSSSS  IIIIII A     A"
			DB 13,10,"                                 PAYROLL SYSTEM$"
	
    	;LOGIN
    	checkID db "HR001",0
    	checkPass db "12345",0
    	displayLogin db 13,10,"                          ^**************************^"
                     db 13,10,"                          ::Welcome to LOG IN Module::"
                     db 13,10,"                          ^**************************^$"
    	success db 13,10,"        "
		db 13,10,"                             -->Log In successful<--$"
    	fail 	db 13,10,"        "
		db 13,10,"          -->Unauthorised user...Please enter a valid ID or password<--$"

    	enter1 db 13,10,"Enter HR ID: $"
    	enter2 db 13,10,"Enter Password: $"

        ; Constants
    	MAX_ID_LENGTH equ 6
    	MAX_PASS_LENGTH equ 6

    	HRID_LABEL LABEL BYTE
    	idmax db MAX_ID_LENGTH     ; Max length of HR ID
    	inputID db ?               ; Number of chars that user entered
    	actID db MAX_ID_LENGTH dup(0) ; Array of chars (null-terminated)

    	HRPASSWORD db 5 dup(0)

	;STAFF INFROMATION
	displaySI db 13,10," "
		  db 13,10,"                          ___________________________"
    		  db 13,10,"                          ::   STAFF Information   ::"
    		  db 13,10,"                          ___________________________"
		  db 13,10,"              >>==============================================<<"
		  db 13,10,"              ||	    PAYROLL CANDIDATES SELECTION      ||"
		  db 13,10,"              ::===========::=================================::"
		  db 13,10,"              ||STAFF ID   ||	        NAME		      ||"
		  db 13,10,"              ::===========::=================================::"
		  db 13,10,"              ||SD0001     || 	John Doe		      ||"
		  db 13,10,"              ||SD0002     || 	Jane Smith	              ||"
		  db 13,10,"              ||SD0003     || 	David Williams		      ||"
		  db 13,10,"              ||SD0004     || 	Emily Johnson		      ||"
		  db 13,10,"              ||SD0005     || 	Michael Brown		      ||"
		  db 13,10,"              ||SD0006     || 	Susan Davis		      ||"
		  db 13,10,"              >>===========::=================================<<$"
    
    	exitSI db 13,10," "
	       db 13,10,"                          _______________________"
    	       db 13,10,"                          ::Exit STAFF Module ::"
    	       db 13,10,"                          _______________________$"
	line   db 13,10," "
	       db 13,10,"========================================================================$"

	fhandle dw ?  
	fileStaff db 'staff.txt',0           
	
	;Staff Inforamtion Variable
	PROMPTSTAFFID db 13,10,'Enter the Satff ID(eg:SD0001) :$' 
	STAFFID DB 6 DUP(?)
	errorMsg db 10,13,"Invalid Staff ID!!! Please key in again....$"
	buffer db 600 dup(?)
	backStaff db 10,13,"Back to Staff ID Key In$"
	;WORKING HOURS 
	PROMPTWH DB 10,13,"Enter TOTAL WORKING HOURS(000-300 HOUR):$"
	TOTALWHTEMP DB 4 DUP(?)
	TOTALWH DW ? 		;STORE TOTAL WORKING HOURS 
	WRTOTALWH DB "Wrong TOTAL HOURS!!! Please key in (000-300)HOURS only!$"
	DISTOTALWH DB 10,13,"Total Working Hours: $"
	DISWH DB 3 DUP(?)
	;error message when open file and read file
	openErrorMsg db 10,13,"Error occured when opening file$"
	readErrorMsg db 10,13,"Error occured when reading file$"
	;confirm message
	confirmStaff db 10,13,"Sure this staff (YES=y/No=n)?$"
	confirmTotalWH db 10,13,"Confirm Total Working Hours (YES=y/No=n)? $"
	confirmSI db ?

	;OVERTIME
	displayOvertime db 13, 10, "                          ******************************"
    		    	db 13, 10, "                          ::Welcome to OVERTIME Module::"
    		    	db 13, 10, "                          ******************************$"
    
   	exitOvertime 	db 13, 10, "                          *************************************"
    		 	db 13, 10, "                          ::Exit OVERTIME Module Successfully::"
    		 	db 13, 10, "                          *************************************$"
    
    	comfirm 	db 13, 10, "Staff Overtime?(y=Yes/n=No): $"
    	promptWorkDays 	db 13, 10, "Total Number of Working Days(0-29): $"
    	errDays 	db 13, 10, "Digit Acceptable Range(0-9) only...Please insert a new day!!! $"
    	errorDays 	db 13, 10, "Days cannot above 29 days...Please insert a new day!!! $"
    	correct_Days 	db 13, 10, "Correct day input? (y/n): $"
   	display_OTHours db 13, 10, "Total Overtime Hours: $"
    	hours		db " Hours$"
    	wantDays	db " Days$"

	    ; Variables
   	digit 		db 2 dup(?) ; Array to store the digits
    	total_overtime 	db 4 dup(?)
   	workDays 		db 0
    	days  		dw ?  

	;GROSS PAY
	displayGP db 13, 10, "                          _______________________________"
    		  db 13, 10, "                          ::        GROSS PAY          ::"
    		  db 13, 10, "                          _______________________________$"
    
    	exitGP db 13, 10, "                          __________________________"
    	       db 13, 10, "                          ::    EXIT GROSS PAY    ::"
    	       db 13, 10, "                          __________________________$"


  	;gross pay
	GROSS_PAY DB 10,13,"Gross Pay? (YES=y/NO=n) :$"
	PROMPTHOURRATE DB 10,13,"Enter Hour Rate RM(00-20):$" 
	PROMPTOTRATE DB 10,13,"Enter OT Rate RM(00-20):$"
   	HOURRATE DB 2 DUP(0)
	OTRATE DB 2 DUP(0)
	HOUR_RATES DB ?
	OT_RATES DB ?
	WRGRATE DB 10,13,"Wrong Rate!!! Please key-in rate in RM(0-20) only!$"
	CONFIRM_RATE DB 10,13,"Confirm Hours and OT Rate(y/n):$"
	DISGP DB 10,13,"GROSS PAY  : RM$"
	DECIMAL DB ".000$"
	TOTALWHPAY DW ?	;TO STORE TOTAL NORMAL WORK PAY (CAN USE DW TO 4 HEXA NUM)
	TOTALOTPAY DW ?	;TO STORE TOTAL NORMAL OT PAY 	
	TOTALGP DW ?   		;TOTAL OF GROSS PAY
	TOTALGPDIS DB 4 DUP(0)	;USE TO DISPLAY TOTAL OF GROSS PAY

	;BONUS
	displayBN db 13, 10, "                          ___________________________"
    		  db 13, 10, "                          ::Welcome to BONUS Module::"
    		  db 13, 10, "                          ___________________________",13,10,"$"
    
    	exitBN db 13, 10, "                          __________________________"
    	       db 13, 10, "                          ::Exit BONUS Module ::"
    	       db 13, 10, "                          __________________________$"

  	;BONUS
	BONUS_GET DB 10,13,"Bonus ? (YES=y/NO=n) :$"
	PROMPTBONUSRATE DB 10,13,"Enter Bonus Rate (00.0-20.0)% :$" 
   	BONUSRATES DB 2 DUP(0)
	RATESPOINT DB '.'
	BONUSRATEDECI DB 2 DUP(?)
	BONUS_RATE DB ?
	BONUS_RATEDEC DB ?
	WRBONUSRATE DB 10,13,"Wrong Rate!!! Please key in rate in (00-20)% only!$"
	CONFIRM_BNRATE DB 10,13,"Confirm BONUS Rate(y/n):$"
	DISBN DB 10,13,"BONUS  : RM$"
	DECIMAL1 DB 0
	;BONUS
	TOTALBN DW ?
	TOTALBNDEC DB ? 	;DECIMAL BONUS
	TOTALBNDIS DB 6 DUP(0)

	ERRYESNO DB 10,13,"Please enter y or n only !!!$"
	nline DB 10,13,"$"   	;for new line  ; 0A =10,0D =13
	YES equ 'y'
    	NO equ 'n'
.code
main proc
	mov ax,@data
	mov ds,ax
	
	MOV AH,09H
	LEA DX,logoAirAsia
	INT 21H
LOGIN:
	; Print UI Log In
    	mov ah, 09h
    	lea dx, displayLogin
    	int 21h 

PROMPTLOGIN:
    	; Enter HR ID
    	lea dx, enter1
    	int 21h

    	mov ah, 0Ah
    	lea dx, HRID_LABEL   ; Tell INT 21h to store captured string here.
    	int 21h

promptPassword:
    	; Enter Password
    	mov ah,09h
    	lea dx, enter2
    	int 21h

    	mov cx,5
    	mov bx,0
    	jmp accept_Pass
accept_Pass:
    	mov ah, 07h
    	int 21h
    	mov HRPASSWORD[bx],al

    	mov ah,02h
   	mov dl,'*'
    	int 21h

    	inc bx
loop accept_Pass

    	; Compare HR ID
    	lea si, actID
    	lea di, checkID
    	mov cx, MAX_ID_LENGTH
compareID1:
    	mov al, [si]       ; Load the next character from si into al
    	cmp al, 0Dh         ; Check for carriage return (CR)
    	jne compareID2  ; Skip the CR character
    	mov al,00h
compareID2:
    	mov bl, [di]       ; Load the character from di into bl
    	cmp al, bl
    	jne loginFailed   ; HR ID verification failed

    	; Increment si and di to move to the next character
    	inc si
    	inc di
loop compareID1 

	lea si,HRPASSWORD
	lea di,checkPass
	mov cx,MAX_PASS_LENGTH
comparePassword1:
	mov al,[si]
	mov bl,[di]
	cmp cx,1
	jne comparePassword2
	mov al,00h
comparePassword2:
	cmp al,bl
	jne loginFailed
	inc si
	inc di
	cmp al,0
	je loginSuccessful
loop comparePassword1
	
loginSuccessful:
    	; Code to execute when login is successful
    	mov ah, 09h
    	lea dx, success
    	int 21h
    	jmp STAFFINFORM

loginFailed:
    	; Code to execute when login fails
    	mov ah, 09h
    	lea dx, fail
    	int 21h
    	jmp PROMPTLOGIN

	;Staff Information module
STAFFINFORM:
	;start staff information module
	MOV AH,09H
	LEA DX,displaySI
	INT 21H

	MOV AX,0
	;Open an Existing File
	MOV AH,3DH
	MOV AL,2		;0 for read only 1 for writing 2 for read & write
	LEA DX,fileStaff
	INT 21H
	MOV fhandle,AX
	JC  OPEN_ERR
	
	;READ a data from  a filea
	mov ah,3fh
    	lea dx,buffer
	mov cx,600
	mov bx,fhandle
	int 21h 
	JC  READ_ERR

	;Close file
	mov bx,fhandle		;ready handler
	mov ah,3eh		;function 3eh - close file
	int 21h
	JMP promptId

OPEN_ERR:
	mov ah,09h
	lea dx,openErrorMsg
	int 21h
	mov ah,4ch		;terminate
	mov al,01h		;error level=1
	int 21h

READ_ERR:
	mov ah,09h
	lea dx,readErrorMsg
	int 21h
	mov ah,4ch		;terminate
	mov al,02h		;error level=2
	int 21h 
   
promptId:		
	;prompt user to key in Staff ID
	mov ah,09h
	lea dx,PROMPTSTAFFID
	int 21h
	
	MOV CX,6  
    	MOV SI,0
	
keyInId:
    	MOV AH,01H
    	INT 21H
    	MOV STAFFID[SI],AL
    	INC SI
    	LOOP keyInId
    
   	;new line
	CALL NEWLINE

	MOV SI,0
	LEA si,buffer
readId:
	mov di,0
	lea di,staffId
	
validate:	           
    	;validate staff id      
    	mov al,[di]
    	mov BL,[si] 
	inc si
    	inc di
   	cmp bl,'&'
    	JE  displayInform1 
	cmp al,BL
    	JNE next
    	jmp validate
    	
next:
    	mov BL,[si] 
	inc si
	cmp BL,'#'
    	JNE NEXT
	mov BL,[si] 
	cmp BL,'$'
	JNE readId
	jmp ErrorId
    
ErrorId:
    	;error Messages
    	mov ah,09h
    	lea dx,errorMsg
    	int 21h

	;PRINT NEW LINE 
	CALL NEWLINE
	JMP promptId
       
displayInform1:
	CALL BORDER
	CALL NEWLINE
displayInform2:
    	mov bl,[si] 
	cmp bl,','
	JE  DISPLAYLINE
    	cmp bl,'#'
   	JE  confirmStaffId
    	mov ah,02h
    	mov dl,bl
    	int 21h
    	inc si
    	jmp displayInform2

DISPLAYLINE: 
	CALL NEWLINE
	INC SI
	JMP displayInform2

BACKSTAFFID:
	MOV AH,09H
	LEA DX,backStaff
	INT 21H
	JMP promptId

confirmStaffId:
	CALL BORDER
	CALL NEWLINE

	MOV AH,09H
	LEA DX,confirmStaff
	INT 21H
	
	MOV AH,01H
	MOV DL,confirmSI
	INT 21H
	
	CMP AL,YES
   	JE  KeyInTotalWH	;YES - let user key in total working hours
    	CMP AL,NO
   	JE  BACKSTAFFID 	;IF NO - back to key in staff id
   	JMP ERRCONFIRMSI

ERRCONFIRMSI:
	MOV AH,09H
	LEA DX,ERRYESNO
	INT 21H
	JMP confirmStaffId

KeyInTotalWH:
	MOV AH,09H
	LEA DX,PROMPTWH
	INT 21H
	
	MOV CX,3
	MOV SI,0
	CALL WORKHOURS

	CMP TOTALWH,0
	JL  XRANGEWH
	CMP TOTALWH,300
	JG  XRANGEWH
	JMP displayWH

XRANGEWH:
	;DISPALY ERROR MESSAGES
	MOV AH,09H
	LEA DX,WRTOTALWH
	INT 21H
	JMP KeyInTotalWH

displayWH:
	;display Total Working Hours for the staff
	MOV AH,09H
	LEA DX,DISTOTALWH
	INT 21H
	CALL DISPLAYTOTALWH
	
CONFIRMWH:
	MOV AH,09H
	LEA DX,confirmTotalWH
	int 21h

	MOV AH,01H
	MOV DL,confirmSI
	INT 21H
	
	CMP AL,YES
   	JE  OT		;YES - let user key in total working hours
    	CMP AL,NO
   	JE  KeyInTotalWH	;IF NO - back to key in staff id
   	JMP ERRCONFIRMWH

ERRCONFIRMWH:
	call printErrorMessage
	JMP CONFIRMWH

OT:
	MOV AH,09H
	LEA DX,exitSI
	INT 21H
	call NEWLINE
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
    	call NEWLINE
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
    	je  displayTotalOT
    	cmp al, NO
   	jne errYesNo_confirm
    	dec si
    	mov workDays, 0
    	jmp otConfirmation

displayTotalOT:
    	call NEWLINE
    	lea dx, display_OTHours
    	int 21h

    	mov ah, 0
   	mov al, workDays
   	mov bx, 9
    	mul bx
    	mov dx,TOTALWH	;TOTALWH = 300
    	sub dx, ax
	cmp dh,255
    	jne netDays
   	mov days,0h
    	call convertDecimal
    	jmp exitProgram

netDays:
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
   	call NEWLINE
    	mov ah, 09h
    	lea dx,exitOvertime
    	int 21h
	JMP GROSSPAY

GROSSPAY:
	MOV AH,09H
	LEA DX,displayGP
	INT 21H

GPCONFIRM:
	;DISPLAY GROSS PAY CONFIRM 
	MOV AH,09H
	LEA DX,GROSS_PAY
	INT 21H
	
	MOV AH,01H
	INT 21H
	CMP AL,YES
	JE  AGAIN
	CMP AL,NO
	JE  GPCONFIRM
	JMP ERRGP
	
AGAIN:	
	;clear screen
		
	;GET HOUR RATE
	MOV AH,09H
	LEA DX,PROMPTHOURRATE
	INT 21H

	MOV CX,2
	MOV SI,0
	CALL HOURR

	CMP HOUR_RATES,0
	JL  XRANGE1
	CMP HOUR_RATES,20
	JG  XRANGE1
	JMP AGAIN2
	
AGAIN2:
	;GET OT RATE
	MOV AH,09H
  	LEA DX,PROMPTOTRATE
 	INT 21H

	;OTRATE
	MOV CX,2
	MOV SI,0
	MOV AL,0
	CALL OTR
	
	CMP OT_RATES,0
	JL  XRANGE2
	CMP OT_RATES,20
	JG  XRANGE2
	JMP CONFIRMRATE
XRANGE1:
	;DISPALY ERROR MESSAGES
	MOV AH,09H
	LEA DX,WRGRATE
	INT 21H
	JMP AGAIN

XRANGE2:
	;DISPALY ERROR MESSAGES
	MOV AH,09H
	LEA DX,WRGRATE
	INT 21H
	JMP AGAIN2

ERRGP:
	MOV AH,09H
	LEA DX,ERRYESNO
	INT 21H
GOGPCONFIRM:
	JMP GPCONFIRM

CONFIRMRATE:
	;CONFIRMATION
    	MOV AH,09H
    	LEA DX,CONFIRM_RATE 
    	INT 21H

   	MOV AH,01H
    	INT 21H
    	CMP AL,YES
   	JE  GROSSPAYCAL	 
    	CMP AL,NO
   	JE  GOGPCONFIRM
   	JMP ERRCONFIRMRATE

ERRCONFIRMRATE:
	MOV AH,09H
	LEA DX,ERRYESNO
	INT 21H
	JMP CONFIRMRATE

GROSSPAYCAL:
	;TRY
	MOV AX,0
	;TOTAL WORK HOUR
     
    	MOV AX,TOTALWH
	SUB AX,days       	;TOTALWH = 300 = 12CH  300-39 = 261 (105 H)
	MOV BL,HOUR_RATES
	MUL BX			;261 x 20 = 5220D 105 H X 14 H = 1464 H 5220
	MOV TOTALWHPAY,AX	;TOTALWH1 = 1464 H
	
	MOV AX,0
	MOV AX,days   		;OTHOUR = 39 = 27H
	MUL OT_RATES		;39 X 20 = 780 27 H X 14 H = 030C H
	MOV TOTALOTPAY,AX	;TOTALOTPAY = 030C H

	MOV AX,0
	MOV AX,TOTALWHPAY	;AH = 14 H
	ADD AX,TOTALOTPAY	;AX = 1464 H + 030CH = 1770 H 6000 D

	;TO STORE THE TOTAL GROSS PAY
	MOV TOTALGP,AX  	;TOTALGP = 1770 H 6000 D
	
     	;DISPLAY GROSS PAY
	MOV AH,09H
	LEA DX,DISGP
	INT 21H
	
	MOV AX,0
	MOV DX,0
	MOV AX,TOTALGP
	MOV BX,100
	;AX=6000/100 AL=0060 DX=0000
	DIV BX
	;AL=38/10= 24 H AL=03 AH=08 DX=0000 
	MOV BL,10
	DIV BL
	MOV TOTALGPDIS[0],AL
	MOV TOTALGPDIS[1],AH
	MOV TOTALGPDIS[2],DL  ;60
	MOV TOTALGPDIS[3],DH
	
	;DISPLAY NUMBER 1 DIGIT
	MOV AH,02H
	MOV DL,TOTALGPDIS[0]
	ADD DL,30H
	INT 21H

	;DISPLAY NUMBER 2 DIGIT
	MOV AH,02H
	MOV DL,TOTALGPDIS[1]
	ADD DL,30H
	INT 21H
	
	MOV AX,0
	MOV AL,TOTALGPDIS[2] 	;AX = 0060
	DIV BL    		;AL=00 AH=00
	MOV TOTALGPDIS[2],AL	;AL=00
	MOV TOTALGPDIS[3],AH	;AH=00

	;DISPLAY NUMBER 3 DIGIT
	MOV AH,02H
	MOV DL,TOTALGPDIS[2]
	ADD DL,30H
	INT 21H

	;DISPLAY NUMBER 4 DIGIT
	MOV AH,02H
	MOV DL,TOTALGPDIS[3]
	ADD DL,30H
	INT 21H

	MOV AH,09H
	LEA DX,DECIMAL
	INT 21H
	LEA DX,exitGP
	INT 21H

	;MOV AH,09H
	;LEA DX,EXITGP
	;INT 21H
	JMP BONUS

BONUS:
	MOV AH,09H
	LEA DX,displayBN
	INT 21H

BNCONFIRM:
	;DISPLAY GROSS PAY CONFIRM 
	MOV AH,09H
	LEA DX,BONUS_GET
	INT 21H
	
	MOV AH,01H
	INT 21H
	CMP AL,YES
	JE  GETBONUS
	CMP AL,NO
	JE  BNCONFIRM
	JMP ERRBN
	
GETBONUS:	
	;clear screen
		
	;GET BONUS RATE
	MOV AH,09H
	LEA DX,PROMPTBONUSRATE
	INT 21H

	MOV CX,2
	MOV SI,0
	CALL BONUSL

	;CHECK BONUS RATE
	CMP BONUS_RATE,0
	JL  XBNRANGE
	CMP BONUS_RATE,20
	JG  XBNRANGE
	CMP BONUS_RATEDEC,0
	JL  XBNRANGE
	CMP BONUS_RATEDEC,99
	JG  XBNRANGE
	JMP CONFIRMRATEBN
	
XBNRANGE:
	;DISPALY ERROR MESSAGES (BONUS)
	MOV AH,09H
	LEA DX,WRBONUSRATE
	INT 21H
BACKBONUS:
	JMP GETBONUS

ERRBN:
	MOV AH,09H
	LEA DX,ERRYESNO
	INT 21H
	JMP BNCONFIRM

CONFIRMRATEBN:
	;CONFIRMATION
    	MOV AH,09H
    	LEA DX,CONFIRM_BNRATE 
    	INT 21H

   	MOV AH,01H
    	INT 21H
    	CMP AL,YES
   	JE  BONUSCAL	 	;YES - CAL BONUS
    	CMP AL,NO
   	JE  BACKBONUS		;IF NO - BACK START OF BONUS MODULE
   	JMP ERRCONFIRMBONUS

ERRCONFIRMBONUS:
	MOV AH,09H
	LEA DX,ERRYESNO		
	INT 21H
	JMP CONFIRMRATEBN

BONUSCAL:
	MOV AX,0
	MOV DX,0
	MOV BX,0

	;GET BONUS BY MUL BONUS RATE
    	MOV AX,TOTALGP		;AL = 1248 H 4680(TOTAL GP)
	MOV BX,100
	DIV BX       		;AX = 4680 (1248 H) / 100 = 46 (2E H) DX=0080
	MUL BONUS_RATE		;RM46 X 18 = RM 828 (033C H)
	MOV TOTALBN,AX 		;TOTAL BONUS PAY = 828

	MOV AX,0 
	MOV DX,0
	MOV AX,TOTALGP		;AL = 0ED8 H(TOTAL GP)
	MOV BX,100
	DIV BX       		;AL = 3800 (0ED8 H) / 100 = 38 (26 H)
	MUL BONUS_RATEDEC	;RM38 X 28 = RM 1064 (428 H)
	MOV BX,100 
	MOV DX,0
	DIV BX			;1064/100 = 10.64 AX=0010D (000A H) DX=0064D (0040 H)
	;TO STORE THE TOTAL BONUS PAY
	ADD TOTALBN,AX 		;TOTALBN + 10 = RM 694
	MOV TOTALBNDEC,DL	;TOTALBNDEC = 0.64
	
     	;DISPLAY BONUS PAY
	MOV AH,09H
	LEA DX,DISBN
	INT 21H
	
	;*IF BONUS PAY LARGE THAN 1000 (CHANGE!!!)*
	MOV AX,0
	MOV DX,0
	MOV AX,TOTALBN		;TOTAL BONUS PAY = 760 (02F8 H)
	MOV BX,100		;840/100 = 8.40(AH = 00 AL = 08 DL= 40 D)
	DIV BX
	MOV BL,10
	DIV BL			;AL = 00 H AH=08 H DL=40 (53 H) DH=00 H
	MOV TOTALBNDIS[0],AL	
	MOV TOTALBNDIS[1],AH	
	MOV TOTALBNDIS[2],DL
	MOV TOTALBNDIS[3],DH
	
	;DISPLAY NUMBER 1 DIGIT
	MOV AH,02H
	MOV DL,TOTALBNDIS[0]
	ADD DL,30H
	INT 21H

	;DISPLAY NUMBER 2 DIGIT
	MOV AH,02H
	MOV DL,TOTALBNDIS[1]
	ADD DL,30H
	INT 21H
	
	MOV AX,0
	MOV AL,TOTALBNDIS[2] 	;AX = 0094
	DIV BL    		;94/10= 9.4 AL=09 AH=04
	MOV TOTALBNDIS[2],AL	;AL=09
	MOV TOTALBNDIS[3],AH	;AH=04
	

	;DISPLAY NUMBER 3 DIGIT
	MOV AH,02H
	MOV DL,TOTALBNDIS[2]
	ADD DL,30H
	INT 21H

	;DISPLAY NUMBER 4 DIGIT
	MOV AH,02H
	MOV DL,TOTALBNDIS[3]
	ADD DL,30H
	INT 21H

	;DISPLAY '.'
	MOV AH,02H
	MOV DL,RATESPOINT
	INT 21H

	;DISPLAY DECIMAL OF TOTAL BONUS
	MOV AX,0
	MOV AL,TOTALBNDEC ;64
	DIV BL		  ;BL =10 (0AH) 64/10=6.4 AL= 06,AH =04H
	MOV TOTALBNDIS[4],AL
	MOV TOTALBNDIS[5],AH
	
	;DISPLAY DECIMAL NUMBER OF TOTAL BONUS
	MOV AH,02H
	MOV DL,TOTALBNDIS[4]
	ADD DL,30H
	INT 21H

	MOV AH,02H
	MOV DL,TOTALBNDIS[5]
	ADD DL,30H
	INT 21H	

	MOV AH,02H
	MOV DL,DECIMAL1
	ADD DL,30H
	INT 21H

	MOV AH,09H
	LEA DX,EXITBN
	INT 21H
exit:	 
    	;Exit
     	mov ah,4ch
	int 21h

main endp
BORDER:
	MOV AH,09H
	LEA DX,LINE
	INT 21H
	RET
NEWLINE:
	MOV AH,09
	LEA DX,NLINE
	INT 21H
	RET
WORKHOURS:
	MOV AH,01H
	INT 21H
	SUB AL,30H
	MOV TOTALWHTEMP[SI],AL
	INC SI
      LOOP WORKHOURS

	;CHANGE INPUT
    	MOV AL,TOTALWHTEMP[0]
    	MOV DL,100
    	MUL DL
	MOV TOTALWH,AX
	MOV AL,TOTALWHTEMP[1]
	MOV DL,10
	MUL DL
    	ADD AL,TOTALWHTEMP[2]
	ADD TOTALWH,AX

	RET

GODAYSERROR:
	JMP daysError


DISPLAYTOTALWH:
	MOV AX,0 
	MOV DX,0
	MOV AX,TOTALWH
	MOV BX,100
	DIV BX
	MOV DISWH[0],AL
	MOV DISWH[1],DL
	
	;DISPLAY FIRST DIGIT
	MOV AH,02H
	MOV DL,DISWH[0]
	ADD DL,30H
	INT 21H
     
    	MOV AX,0
	MOV AL,DISWH[1]
	MOV BL,10
	DIV BL
	MOV DISWH[1],AL
	MOV DISWH[2],AH

	;DISPLAY SECOND DIGIT
	MOV AH,02H
	MOV DL,DISWH[1]
	ADD DL,30H
	INT 21H
	
	;DISPLAY THIRD DIGIT
	MOV AH,02H
	MOV DL,DISWH[2]
	ADD DL,30H
	INT 21H

	RET

;OT
getUserInput:
    mov ah, 01h		;al = 1, al = 5
    int 21h

    ; Check if the input is a valid digit ('0' to '9')
    cmp al, '0'
    jl GODAYSERROR
    cmp al, '9'
    jg GODAYSERROR

    ; If it's a valid digit, store it and proceed
    mov digit[si], al
    sub digit[si], 30h
    inc si
    loop getUserInput
    call displayDays

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

    call displayHours
    ret

displayDays:
    mov ah,09h
    lea dx,wantDays
    int 21h
    ret

displayHours:
    mov ah,09h
    lea dx,hours
    int 21h
    ret

displayWelcome:
    mov ah, 09h
    lea dx, displayOvertime
    int 21h
    ret 

printErrorDays:
    mov ah, 09h
    lea dx, errDays
    int 21h
    call NEWLINE
    ret

printErrorMessage:
    mov ah, 09h
    lea dx, ERRYESNO
    int 21h
    call NEWLINE
    ret

dateTooHigh:
    mov ah, 09h
    lea dx, errorDays 
    int 21h
    call NEWLINE
    ret
;GROSS PAY
HOURR:
	MOV AH,01H
	INT 21H
	SUB AL,30H
	MOV HOURRATE[SI],AL
	INC SI
      LOOP HOURR

	;CHANGE INPUT
    	MOV AL, HOURRATE[0]
    	MOV DL, 10
    	MUL DL
    	ADD AL, HOURRATE[1]
    	MOV HOUR_RATES, AL

	RET

OTR:
	MOV AH,01H
	INT 21H
	SUB AL,30H
	MOV OTRATE[SI],AL
	INC SI
      LOOP OTR
	
	;VALIDATE
	MOV AL, OTRATE[0]
    	MOV DL, 10
    	MUL DL
    	ADD AL, OTRATE[1]
    	MOV OT_RATES, AL
	RET
;BONUS
BONUSL:
	MOV AH,01H
	INT 21H
	SUB AL,30H
	MOV BONUSRATES[SI],AL
	INC SI
      LOOP BONUSL

	MOV AH,02H
	MOV DL,RATESPOINT
	INT 21H
	
	MOV CX,2
	MOV SI,0

BONUSDECINPUT:	
	MOV AH,01H
	INT 21H
	SUB AL,30H
	MOV BONUSRATEDECI[SI],AL
	INC SI
	LOOP BONUSDECINPUT	

	 ; Validate input NO DECIMAL
	MOV AX,0
	MOV DX,0
    	MOV AL,BONUSRATES[0]  	;AL = 02H 
    	MOV BL,10
    	MUL BL			;AL = 01 X 10 = 10(0A H)
	ADD AL,BONUSRATES[1]	;AL = 10 + 8 = 18(12 H)
	MOV BONUS_RATE,AL	;BONUS_RATE = 18 (12 H)

	; Validate input NO DECIMAL
	MOV AX,0
	MOV DX,0
    	MOV AL,BONUSRATEDECI[0] ;AL = 02H 
    	MOV BL,10
    	MUL BL			;AL = 02 X 10 = 20 (14 H)
	ADD AL,BONUSRATEDECI[1]	;AL = 20 + 8 = 28 (1C H)
	MOV BONUS_RATEDEC,AL	;BONUS_RATEDEC = 0
	RET
    end main   
	

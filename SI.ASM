.model small
.stack 100
.data
	;STAFF INFROMATION
	displaySI db 13, 10, "___________________________"
    		  db 13, 10, "::Welcome to STAFF Module::"
    		  db 13, 10, "___________________________$"
    
    	exitSI db 13, 10, "_______________________"
    	       db 13, 10, "::Exit STAFF Module ::"
    	       db 13, 10, "_______________________$"

	fhandle dw ?  
	fileStaff db 'staff.txt',0           
	
	;Staff Inforamtion Variable
	PROMPTSTAFFID db 13,10,'Enter the Satff ID(eg:SD0001) :$' 
	STAFFID DB 6 DUP(?)
	nline DB 10,13,"$"   	;for new line  ; 0A =10,0D =13
	errorMsg db 10,13,"Invalid Staff ID!!! Please key in again....$"
	buffer db 200 dup(?)
	backStaff db 10,13,"Back to Staff ID Key In$"
	;WORKING HOURS 
	PROMPTWH DB 10,13,"Enter TOTAL WORKING HOURS(000-300 HOUR):$"
	TOTALWHTEMP DB 4 DUP(?)
	TOTALWH DW ? 		;STORE TOTAL WORKING HOURS 
	WRTOTALWH DB "Wrong TOTAL HOURS!!! Please key in (000-300)HOURS only!$"
	DISTOTALWH DB 10,13,"Total Working Hours: $"
	DISWH DB 3 DUP(?)

	openErrorMsg db 10,13,"Error occured when opening file$"
	readErrorMsg db 10,13,"Error occured when reading file$"
	confirmStaff db 10,13,"Sure this staff (YES=y/No=n)?$"
	confirmTotalWH db 10,13,"Confirm Total Working Hours (YES=y/No=n)? $"
	confirmSI db ?
	ERRYESNO DB 10,13,"Please enter y or n only !!!$"
	YES equ 'y'
    	NO equ 'n'
.code
main proc
	mov ax,@data
	mov ds,ax

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
	mov cx,200
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
	mov ah,09h
    	lea dx,nline
	int 21h 

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
    	JE  displayInform 
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
	MOV AH,09H
	LEA DX,NLINE
	INT 21H
	JMP promptId
       
displayInform:
    	mov bl,[si] 
    	cmp bl,'#'
   	JE  confirmStaffId
    	mov ah,02h
    	mov dl,bl
    	int 21h
    	inc si
    	jmp displayInform 

BACKSTAFFID:
	MOV AH,09H
	LEA DX,backStaff
	INT 21H
	JMP promptId

confirmStaffId:
	MOV AH,09H
	LEA DX,NLINE
	INT 21H

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
   	JE  EXIT		;YES - let user key in total working hours
    	CMP AL,NO
   	JE  KeyInTotalWH	;IF NO - back to key in staff id
   	JMP ERRCONFIRMWH

ERRCONFIRMWH:
	MOV AH,09H
	LEA DX,ERRYESNO
	INT 21H
	JMP CONFIRMWH
	
exit:
	MOV AH,09H
	LEA DX,EXITSI
	INT 21H 
    	;Exit
     	MOV AH,4CH
	INT 21H	
main endp
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
	
	end main
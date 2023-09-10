.model small
.stack 100
.data
    checkID db "HR001",0
    checkPass db "12345",0
    displayLogin db 13,10,"****************************"
                 db 13,10,"::Welcome to LOG IN Module::"
                 db 13,10,"****************************$"
    success db 13,10,"-->Log In successful<--$"
    fail db 13,10,"-->Unauthorised user...Please enter a valid ID or password<--$"
    enter1 db 13,10,"Enter HR ID: $"
    enter2 db 13,10,"Enter Password: $"
    newline db 13,10,'$'

    ; Constants
    MAX_ID_LENGTH equ 6
    MAX_PASS_LENGTH equ 6

    HRID_LABEL LABEL BYTE
    idmax db MAX_ID_LENGTH     ; Max length of HR ID
    inputID db ?               ; Number of chars that user entered
    actID db MAX_ID_LENGTH dup(0) ; Array of chars (null-terminated)

    HRPASSWORD_LABEL LABEL BYTE
    passMax db MAX_PASS_LENGTH ; Max length of password
    inputPass db ?             ; Number of chars that user entered
    actPass db MAX_PASS_LENGTH dup(0) ; Array of chars (null-terminated)

.code
main proc
    mov ax, @data
    mov ds, ax

    ; Print UI Log In
    mov ah, 09h
    lea dx, displayLogin
    int 21h 

    ; Enter HR ID
    lea dx, enter1
    int 21h

    mov ah, 0Ah
    lea dx, HRID_LABEL   ; Tell INT 21h to store captured string here.
    int 21h

    ; Enter Password
    mov ah,09h
    lea dx, enter2
    int 21h

    mov ah, 0Ah
    lea dx, HRPASSWORD_LABEL ; Tell INT 21h to store captured password here.
    int 21h

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

    ; Check if we've reached the end of the input (null-terminated)
    cmp al, 0
    je comparePassword
loop compareID1 

    ; Compare Password
comparePassword:
    lea si, actPass
    lea di, checkPass
    mov cx, MAX_PASS_LENGTH   ; Use the actual length of the entered password
comparePasswordLoop1:
    mov al, [si]       ; Load the next character from si into al
    cmp al, 0Dh         ; Check for carriage return (CR)
    jne comparePasswordLoop2 ; Skip the CR character
    mov al,00h
comparePasswordLoop2:
    mov bl, [di]       ; Load the character from di into bl
    cmp al, bl
    jne loginFailed   ; Password verification failed

    ; Increment si and di to move to the next character
    inc si
    inc di

    ; Check if we've reached the end of the input (null-terminated)
    cmp al, 0
    je loginSuccessful
loop comparePasswordLoop1    ; Continue if more characters to compare

loginSuccessful:
    ; Code to execute when login is successful
    mov ah, 09h
    lea dx, success
    int 21h
    jmp exit

loginFailed:
    ; Code to execute when login fails
    mov ah, 09h
    lea dx, fail
    int 21h
    jmp exit

exit:
    ; Exit program
    mov ah, 4ch
    int 21h
main endp
end main
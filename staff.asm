.model small
.stack 100
.data
	staff	db 13,10,"              >>==============================================<<"
		db 13,10,"              ||	 PAYROLL CANDIDATES SELECTION         ||"
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
.code
main proc
    	mov ax, @data
    	mov ds, ax

	mov ah,09h
	lea dx,staff
	int 21h

	mov ah,4ch
	int 21h
main endp
end main

.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
public _main
.data
tekst	db 10, 'Nazywam sie . . . ' , 10
		db 'Moj pierwszy 32-bitowy program '
		db 'asemblerowy dziala juz poprawnie!', 10
.code
_main PROC
	mov ecx, 85
	mov eax, 0
	mov ebx, 3
	mov ecx, 5
ptl:add eax, ebx
	add ebx, 2
	sub ecx, 1
	jnz ptl
	push ecx
	push dword PTR OFFSET tekst
	push dword PTR 1
	call __write
	add esp, 12
	push dword PTR 0
call _ExitProcess@4
_main ENDP
END

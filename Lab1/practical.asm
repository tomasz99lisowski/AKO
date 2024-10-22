; wczytywanie i wyúwietlanie tekstu wielkimi literami
; (inne znaki siÍ nie zmieniajπ)
.686
.model flat
extern _ExitProcess@4	:	PROC
extern _MessageBoxA@16	:	PROC
extern _MessageBoxW@16	:	PROC
extern __write			:	PROC ; (dwa znaki podkreúlenia)
extern __read			:	PROC ; (dwa znaki podkreúlenia)
 
public _main

.data
tekst_pocz		db 10, 'ProszÍ napisaÊ jakiú tekst '
tytul_A16		db 'A16',0

tytul_W16		dw 'W', '1', '6', 0

				db		'i nacisnac Enter', 10
koniec_t		db ?
magazyn			db 80 dup (?)
magazyn_UTF16	dw 80 dup (?)
nowa_linia		db 10
liczba_znakow	dd ?



.code
_main PROC
		; wyúwietlenie tekstu informacyjnego
		; liczba znakÛw tekstu
		mov edi, 0
		mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
		push ecx
		push OFFSET tekst_pocz ; adres tekstu
		push 1 ; nr urzπdzenia (tu: ekran - nr 1)
		call __write ; wyúwietlenie tekstu poczπtkowego
		add esp, 12 ; usuniecie parametrÛw ze stosu
		; czytanie wiersza z klawiatury
		push 80 ; maksymalna liczba znakÛw
		push OFFSET magazyn
		push 0 ; nr urzπdzenia (tu: klawiatura - nr 0)
		call __read ; czytanie znakÛw z klawiatury
		add esp, 12 ; usuniecie parametrÛw ze stosu
		; kody ASCII napisanego tekstu zosta≥y wprowadzone
		; do obszaru 'magazyn'
		; funkcja read wpisuje do rejestru EAX liczbÍ
		; wprowadzonych znakÛw
		mov liczba_znakow, eax
		; rejestr ECX pe≥ni rolÍ licznika obiegÛw pÍtli
		mov ecx, eax
		mov ebx, 0 ; indeks poczπtkowy
		mov esi, 0

ptl:	mov dl, magazyn[ebx] ; pobranie kolejnego znaku
		cmp dl, 'A'
jb		inny_znak
		cmp dl, 'Z'
jb		pl_male
		cmp dl, 'a'
jb		dalej
		cmp dl, 'z'
ja		pl_duze
		sub dl, 20H
		jmp zapisz

COMMENT @
jb		inny_znak ; skok, gdy znak nie wymaga zamiany
		cmp dl, 'Z'
jb		pl_male ; 
		cmp dl, 'z'
ja		pl_duze
		sub dl, 20H ; zamiana na wielkie litery
		; odes≥anie znaku do pamiÍci
		jmp zapisz
@

inny_znak:	mov dl, '*'
			jmp zapisz



pl_male:	
			add dl, 20H
			jmp zapisz

pl_duze:		cmp dl, 0A5H; π
jz		a_label
		cmp dl, 86H; Ê
jz		c_label
		cmp dl, 0A9H; Í
jz		e_label
		cmp dl, 88H; ≥
jz		l_label
		cmp dl, 0E4H; Ò
jz		n_label
		cmp dl, 0A2H; Û
jz		o_label
		cmp dl, 98H; ú
jz		s_label
		cmp dl, 0BEH; ø
jz		z1_label
		cmp dl, 0ABH; ü
jz		z2_label
		cmp dl, 0A4H; •	
jz		Aa_label
		cmp dl, 08FH; ∆
jz		Cc_label
		cmp dl, 0A8H;  
jz      Ee_label
		cmp dl, 09DH; £
jz      Ll_label
		cmp dl, 0E3H; —
jz      Nn_label
		cmp dl, 0E0H; ”			
jz      Oo_label
		cmp dl, 097H; å
jz      Ss_label
        cmp dl, 0BDH; Ø
jz      Z11_label
		cmp dl, 08DH; è 
jz      Z22_label


		
Aa_label:	mov dl, 0B9H
			jmp zapisz
Cc_label:	mov dl, 0E6H
			jmp zapisz
Ee_label:	mov dl, 0EAH
			jmp zapisz
Ll_label:	mov dl, 0B3H
			jmp zapisz
Nn_label:	mov dl, 0F1H
			jmp zapisz
Oo_label:	mov dl, 0F3H
			jmp zapisz
Ss_label:	mov dl, 09CH
			jmp zapisz
Z11_label:	mov dl, 0BFH
			jmp zapisz
Z22_label:	mov dl, 09FH
			jmp zapisz

a_label:	nop
			jmp zapisz

c_label:	add dl, 40H
			jmp zapisz

e_label:	add dl, 21H
			jmp zapisz

l_label:	add dl, 1BH
			jmp zapisz

n_label:	sub dl, 13H
			jmp zapisz

o_label:	add dl, 31H
			jmp zapisz

s_label:	sub dl, 0CH
			jmp zapisz

z1_label:	sub dl, 0FH
			jmp zapisz

z2_label:	sub dl, 1CH
			jmp zapisz
			

;zapisz: mov magazyn_UTF16[edi], dx
;		add edi, 2

zapisz:		mov magazyn[ebx], dl
			jmp dalej
		
		

dalej:	inc ebx ; inkrementacja indeksu
		dec ecx
		jnz ptl ; sterowanie pÍtlπ
		; wyúwietlenie przekszta≥conego tekstu
		push 0
		push OFFSET tytul_A16
		push OFFSET magazyn
		push 0
		call _MessageBoxA@16 ; wyúwietlenie przekszta≥conego tekstu
		add esp, 12 ; usuniecie parametrÛw ze stosu
		push 0
		call _ExitProcess@4 ; zakoÒczenie programu
_main ENDP
END









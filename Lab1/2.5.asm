; wczytywanie i wy�wietlanie tekstu wielkimi literami
; (inne znaki si� nie zmieniaj�)
.686
.model flat
extern _ExitProcess@4	:	PROC
extern _MessageBoxA@16	:	PROC
extern _MessageBoxW@16	:	PROC
extern __write			:	PROC ; (dwa znaki podkre�lenia)
extern __read			:	PROC ; (dwa znaki podkre�lenia)
 
public _main

.data
tekst_pocz		db 10, 'Prosz� napisa� jaki� tekst '
tytul_A16		db 'A16',0

tytul_W16		dw 'W', '1', '6', 0

				db		'i nacisnac Enter', 10
koniec_t		db ?
magazyn			db 80 dup (?)
nowa_linia		db 10
liczba_znakow	dd ?



.code
_main PROC
		; wy�wietlenie tekstu informacyjnego
		; liczba znak�w tekstu
		mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
		push ecx
		push OFFSET tekst_pocz ; adres tekstu
		push 1 ; nr urz�dzenia (tu: ekran - nr 1)
		call __write ; wy�wietlenie tekstu pocz�tkowego
		add esp, 12 ; usuniecie parametr�w ze stosu
		; czytanie wiersza z klawiatury
		push 80 ; maksymalna liczba znak�w
		push OFFSET magazyn
		push 0 ; nr urz�dzenia (tu: klawiatura - nr 0)
		call __read ; czytanie znak�w z klawiatury
		add esp, 12 ; usuniecie parametr�w ze stosu
		; kody ASCII napisanego tekstu zosta�y wprowadzone
		; do obszaru 'magazyn'
		; funkcja read wpisuje do rejestru EAX liczb�
		; wprowadzonych znak�w
		mov liczba_znakow, eax
		; rejestr ECX pe�ni rol� licznika obieg�w p�tli
		mov ecx, eax
		mov ebx, 0 ; indeks pocz�tkowy
ptl:	mov dl, magazyn[ebx] ; pobranie kolejnego znaku
		cmp dl, 'a'
jb		dalej ; skok, gdy znak nie wymaga zamiany
		cmp dl, 'z'
ja		pl ; skok, gdy kod znaku jest wi�kszy ni� 07BH
		sub dl, 20H ; zamiana na wielkie litery
		; odes�anie znaku do pami�ci
		jmp zapisz


pl:		cmp dl, '�'
jz		a_label
		cmp dl, 86H; �
jz		c_label
		cmp dl, 0A9H; �
jz		e_label
		cmp dl, 88H; �
jz		l_label
		cmp dl, 0E4H; �
jz		n_label
		cmp dl, 0A2H; �
jz		o_label
		cmp dl, 98H; �
jz		s_label
		cmp dl, 0BEH; �
jz		z1_label
		cmp dl, 0ABH; �
jz		z2_label


		
; to UTF-16 coding

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
			

zapisz: mov magazyn[ebx], dl


		
		

dalej:	inc ebx ; inkrementacja indeksu
		dec ecx
		jnz ptl ; sterowanie p�tl�
		; wy�wietlenie przekszta�conego tekstu
		push 0
		push OFFSET tytul_W16
		push OFFSET magazyn
		push 0
		call _MessageBoxW@16
		add esp, 12 ; usuniecie parametr�w ze stosu
		push 0
		call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END








COMMENT @
v:	nop	;add dl, 0AH
e:	nop ;sub dl, 01H
l:	nop	;add dl, 0FH
n:	nop	;sub dl, 01H
o:	nop	;add dl, 3FH
s:	nop	;sub dl, 01H
z1:	nop	;sub dl, 01H
z2:	nop	;sub dl, 1FH

		push liczba_znakow
		push OFFSET magazyn
		push 1
		call __write ; wy�wietlenie przekszta�conego tekstu


; tekst wy�wietlnay w cmd w formie latin 2
a_label:	sub dl, 01H
			jmp zapisz

c_label:	add dl, 09H
			jmp zapisz

e_label:	sub dl, 01H
			jmp zapisz

l_label:	add dl, 15H
			jmp zapisz

n_label:	sub dl, 01H
			jmp zapisz

o_label:	add dl, 3EH
			jmp zapisz

s_label:	sub dl, 01H
			jmp zapisz

z1_label:	sub dl, 01H
			jmp zapisz

z2_label:	sub dl, 1EH
			jmp zapisz


; to Windows1250 coding

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

@
; Macros.inc
; Contiene las macros para convertir enteros a cadena y viceversa

; MacroEnteroACadena
; Esta macro convierte un entero de 32 bits con signo
; en su representación en cadena para su impresión posterior
; usando la función WriteConsoleA


MacroEnteroACadena	MACRO	Numero, Cadena, Contador
LOCAL	Inicio
LOCAL	Repetir
LOCAL	Sacar
			PUSHAD				; Salvar todos los registros
			LEA	ESI, Cadena
			MOV	BYTE PTR [ESI], ' '	; Positivo, no lleva signo
			MOV	EAX, Numero
			TEST	EAX, 80000000H
			JZ	Inicio
			; Numero negativo
			; Poner signo e invertir
			MOV	BYTE PTR [ESI], '-'
			NEG	EAX

Inicio:
			INC	ESI			; Siguiente posición después del signo
			MOV	ECX, 0			; Contador de caracteres
			MOV	EBX, 10			; Dividir entre 10

Repetir:
			INC	ECX
			CDQ				; EDX:EAX <- EAX
			DIV	EBX
			PUSH	EDX			; Residuo en la pila
			CMP	EAX, 0			; ¿Seguir dividiendo?
			JNE	Repetir

			; ECX tiene el total de caracteres
			MOV	Contador, ECX
			INC	Contador		; Por el signo

			; Sacar los residuos de la pila y convertirlos en caracteres
Sacar:
			POP	EDX
			OR	DL, 30H			; Convertir caractera a ASCII
			MOV	[ESI], DL
			INC	ESI
			LOOP	Sacar

			; Fin. Cadena tiene el número y Contador el total de caracteres
			POPAD				; Recuperar todos los registros
			ENDM


MacroCadenaAEntero	MACRO	Cadena, Numero
LOCAL Saltar
LOCAL SiguienteEspacio
LOCAL VerificarSigno
LOCAL Empezar
LOCAL Terminar
LOCAL Salir
			PUSHAD

			LEA	ESI, Cadena
			MOV	EAX, 0
			MOV	EBX, 10
			MOV	EDI, 0			; Positivo

			;Saltar blancos y tabuladores
Saltar:
			CMP	BYTE PTR [ESI], 32	; Espacio en blanco
			JE	SiguienteEspacio
			CMP	BYTE PTR [ESI], 9	; Tabulador
			JNE	VerificarSigno
SiguienteEspacio:
			INC	ESI
			JMP	Saltar

			;El signo solo puede ser el primer caracter
VerificarSigno:
			CMP	BYTE PTR [ESI], '-'
			JNE	Empezar
			MOV	EDI, 1			; Negativo
			INC	ESI

			; Convertir dígitos a números
			; Salir cuando no sea dígito
Empezar:
			CMP	BYTE PTR [ESI], '0'
			JB	Terminar		; Si es menor que 0
			CMP	BYTE PTR [ESI], '9'
			JA	Terminar		; Si es mayor que 0
			MUL	EBX
			MOV	DL, [ESI]
			AND	EDX, 0000000FH		; Convertir dígito a número
			ADD	EAX, EDX
			INC	ESI
			JMP	Empezar

			; Si tenía signo, negar el número
Terminar:		CMP	EDI, 0
			JE	Salir
			NEG	EAX

			; Dejarlo en número
Salir:			MOV	Numero, EAX
			POPAD
			ENDM

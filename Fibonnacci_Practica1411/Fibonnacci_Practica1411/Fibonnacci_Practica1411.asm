				TITLE	Programa para mostrar los primeros 10 numeros de Fibonnacci
				PAGE	60, 132

				.586
				.MODEL	FLAT, STDCALL

Include	<Macros.inc>

; Prototipos de llamadas a servicios del sistema operativo

GetStdHandle	PROTO	:DWORD
WriteConsoleA	PROTO	:DWORD,	:DWORD,	:DWORD,	:DWORD,	:DWORD
ExitProcess		PROTO	CodigoSalida:DWORD

				.STACK
				.DATA
F				DWORD	0
F1				DWORD	1
F2				DWORD	1
MenSal01		BYTE	"Los primeros 10 numeros de la serie de Fibonnacci son: ", 13, 10
Long_MS01		EQU		$ - MenSal01

; Variables para las llamadas al sistema operativo
ManejadorS		DWORD	0
Caracteres		DWORD	0
Texto			BYTE	13 DUP ( ' ' )
SaltoLinea		BYTE	13, 10
STDOUT			EQU		-11

				.CODE
Principal		PROC
				; Obtener manejador de salida
				INVOKE	GetStdHandle, STDOUT
				MOV		ManejadorS, EAX

				; Mostrar encabezado
				MOV		EAX, Long_MS01
				INVOKE	WriteConsoleA, ManejadorS, ADDR MenSal01, EAX, ADDR Caracteres, 0

				; Mostrar el primer numero de Fibonnacci
				MacroEnteroACadena	F1, Texto, Caracteres
				INVOKE	WriteConsoleA, ManejadorS, ADDR Texto, Caracteres, ADDR Caracteres, 0
				; Salto de línea
				INVOKE	WriteConsoleA, ManejadorS, ADDR SaltoLinea, 2, ADDR Caracteres, 0

				; Mostrar el segundo numero de Fibonnacci
				MacroEnteroACadena	F2, Texto, Caracteres
				INVOKE	WriteConsoleA, ManejadorS, ADDR Texto, Caracteres, ADDR Caracteres, 0
				; Salto de línea
				INVOKE	WriteConsoleA, ManejadorS, ADDR SaltoLinea, 2, ADDR Caracteres, 0

				; Ciclo para calcular los 8 numeros restantes
				MOV		ECX, 8
Inicio:
				MOV		EAX, F1
				ADD		EAX, F2
				MOV		F, EAX

				PUSH	ECX			; Salvar el ECX

				; Mostrar el siguiente numero de Fibonnacci
				MacroEnteroACadena	F, Texto, Caracteres
				INVOKE	WriteConsoleA, ManejadorS, ADDR Texto, Caracteres, ADDR Caracteres, 0
				; Salto de línea
				INVOKE	WriteConsoleA, ManejadorS, ADDR SaltoLinea, 2, ADDR Caracteres, 0

				POP		ECX			; Recuperar el ECX

				; Dos anterior
				MOV		EAX, F1
				MOV		F2, EAX

				; Uno anterior
				MOV		EAX, F
				MOV		F1, EAX

				;LOOP	Inicio
				DEC		ECX
				JNZ		Inicio

				; Salir al S. O.
				INVOKE	ExitProcess, 0
Principal		ENDP
				END		Principal
;EUP que lea el número por el teclado y determine si es primo no primo

TITLE	Programa para determinar si un numero es primo o no primo
				PAGE	60, 132

				.586
				.MODEL	FLAT, STDCALL

Include	<Macros.inc>

; Prototipos de llamadas a servicios del sistema operativo

GetStdHandle	PROTO	:DWORD
ReadConsoleA	PROTO	:DWORD,	:DWORD,	:DWORD,	:DWORD,	:DWORD
WriteConsoleA	PROTO	:DWORD,	:DWORD,	:DWORD,	:DWORD,	:DWORD
ExitProcess		PROTO	CodigoSalida:DWORD

				.STACK
				.DATA
Numero			DWORD	0
Contador		DWORD	0
MenEnt01		BYTE	"Proporcione un numero entero positivo "
Long_ME01		EQU		$ - MenEnt01

MenSal01		BYTE	"El numero es primo."
Long_MS01		EQU		$ - MenSal01
MenSal02		BYTE	"El numero NO es primo."
Long_MS02		EQU		$ - MenSal02

; Variables para las llamadas al sistema operativo
ManejadorE		DWORD	0
ManejadorS		DWORD	0
Caracteres		DWORD	0
Texto			BYTE	13 DUP ( ' ' )
SaltoLinea		BYTE	13, 10
STDIN			EQU		-10
STDOUT			EQU		-11

				.CODE
Principal		PROC
				; Obtener manejadores de entrada y salida
				INVOKE	GetStdHandle, STDIN
				MOV		ManejadorE, EAX
				INVOKE	GetStdHandle, STDOUT
				MOV		ManejadorS, EAX
				
				; Solicitar los datos de entrada Numero
				MOV		EAX, Long_ME01
				INVOKE	WriteConsoleA, ManejadorS, ADDR MenEnt01, EAX, ADDR Caracteres, 0
				INVOKE	ReadConsoleA, ManejadorE, ADDR Texto, 13, ADDR Caracteres, 0
				MacroCadenaAEntero	Texto, Numero

				;Ciclo para las divisiones y contar cuantas veces es divisible
				MOV		ECX, Numero
Ciclo:
				MOV		EAX, Numero
				CDQ 					;Mueve al número EAX -> EDX:EAX lo hace de 64 bits
				DIV		ECX

				;Preguntar si el residuo es 0
				CMP		EDX, 0
				JNE		NoContar

				;Si no salta es igual a 0 (divisible) Incrementa el contador
				INC Contador

NoContar:
				LOOP	Ciclo

				;Preguntar por el resultado de contador]
				CMP		Contador, 2
				JNE ImprimirNoPrimo

				;Si no salta es primo
				MOV		EAX, Long_MS01
				INVOKE	WriteConsoleA, ManejadorS, ADDR MenSal01, EAX, ADDR Caracteres, 0
				JMP	 Salir

ImprimirNoPrimo:
				MOV		EAX, Long_MS02
				INVOKE	WriteConsoleA, ManejadorS, ADDR MenSal02, EAX, ADDR Caracteres, 0

Salir:
				; Salto de linea
				INVOKE	WriteConsoleA, ManejadorS, ADDR SaltoLinea, 2, ADDR Caracteres, 0
    
			   ; Salir al S. O.
				INVOKE	ExitProcess, 0
Principal		ENDP
				END		Principal





; E.P.L.E que lea desde teclado 10 numeros enteros y los almacene en un vector. El programa debe de determinar cuantos números son pares y cuantos son impares. Mostrar resultado en pantalla

TITLE	Programa para evaluar numeros pares o impares dentro de un ciclo
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
Vector			DWORD	10 DUP(0)
A				DWORD	0
Pares			DWORD	0
Impares			DWORD	0
MenEnt01		BYTE	"Proporcione el numero entero "
Long_ME01		EQU		$ - MenEnt01
MenSal01		BYTE	"Total de pares es:   "
Long_MS01		EQU		$ - MenSal01
MenSal02		BYTE	"Total de impares es:   "
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

				; Ciclo para leer los 10 numeros
				MOV ECX, 10			; Contador del ciclo	
				MOV ESI, 0			; indice del vector, empieza en 0
Inicio:			
				; Guardar ECX
				PUSH ECX
				
				; Solicitar los datos de entrada A
				MOV		EAX, Long_ME01
				INVOKE	WriteConsoleA, ManejadorS, ADDR MenEnt01, EAX, ADDR Caracteres, 0
				INVOKE	ReadConsoleA, ManejadorE, ADDR Texto, 13, ADDR Caracteres, 0
				MacroCadenaAEntero	Texto, A

				; Almacenar el numero en el vector
				MOV EAX, A
				MOV Vector[ ESI ], EAX
				
				; Recuperar ECX
				POP ECX

				; Actualizar indice y contador
				ADD ESI, 4			; Porque el tipo de dato es DWORD tiene un tamaño de 4 y se incrementa de 4 en 4.
				DEC ECX
				JNZ Inicio

				; Ciclo para determinar si lo numeros son pares o impares
				MOV ECX, 10			; Contador del ciclo	
				MOV ESI, 0			; indice del vector, empieza en 0
Procesar:
				MOV EDI, 2			; Divisor	
				Mov	EAX, [Vector + ESI ]
				CDQ					; EAX -> EDX: EAX
				IDIV EDI
				; Si el residuo es 0 es par
				CMP EDX, 0
				JE ContarPares
				; Si no salta es impar
				INC Impares
				JMP Continuar
ContarPares:
				INC Pares
Continuar:
				; Actulizar indice y contador
				ADD ESI, TYPE DWORD	; Incrementar el tamaño del tipo de dato
				DEC	ECX
				JNZ Procesar

                ; Mostrar total de pares
				MOV		EAX, Long_MS01
				INVOKE	WriteConsoleA, ManejadorS, ADDR MenSal01, EAX, ADDR Caracteres, 0
				MacroEnteroACadena	Pares, Texto, Caracteres
				INVOKE	WriteConsoleA, ManejadorS, ADDR Texto, Caracteres, ADDR Caracteres, 0

				; Salto de linea
				INVOKE	WriteConsoleA, ManejadorS, ADDR SaltoLinea, 2, ADDR Caracteres, 0
               
			    ; Mostrar total de impares
				MOV		EAX, Long_MS02
				INVOKE	WriteConsoleA, ManejadorS, ADDR MenSal02, EAX, ADDR Caracteres, 0
				MacroEnteroACadena	Impares, Texto, Caracteres
				INVOKE	WriteConsoleA, ManejadorS, ADDR Texto, Caracteres, ADDR Caracteres, 0

				; Salto de linea
				INVOKE	WriteConsoleA, ManejadorS, ADDR SaltoLinea, 2, ADDR Caracteres, 0
              
			   ; Salir al S. O.
				INVOKE	ExitProcess, 0
Principal		ENDP
				END		Principal





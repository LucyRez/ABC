format PE console

entry Start

include 'win32a.inc'

section '.data' data readable writable

          resStr db 'Sum of 50 and -5 : %d', 0
          A dd ?
          B dd ?

          NULL = 0


section '.code' code readable executable

        Start:
                mov [A], 50
                mov [B], -5

                mov ecx, [A]
                add ecx, [B]

                push ecx
                push resStr
                call [printf]

                call [getch]

                push NULL
                call [ExitProcess]

section '.idata' import data readable

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'

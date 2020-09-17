 format PE console

entry Start

include 'win32a.inc'

section '.data' data readable writable


          resStr db 'Result for 200: %d', 0
          A dw ?
          B dw ?

          NULL = 0


section '.code' code readable executable

        Start:
                xor eax, eax
                mov al, 11001000b
                rol al, 1

                push eax
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

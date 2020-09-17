 format PE console

include 'win32a.inc'

jmp Start

section '.data' data readable writable

          resStr db 'Composition of -5 and 9 : %d', 0
          A dd ?
          B dd ?

          NULL = 0

function:

       imul ecx, ebx  ;multiplication


ret

Start:
       mov ecx, -5 ;we put numbers in ecx and ebx
       mov ebx, 9

       call function

       push ecx
       push resStr
       call[printf]

exit:
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

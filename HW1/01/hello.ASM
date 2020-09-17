format PE console

entry Start

include 'win32a.inc'

section '.data' data readable writable

          nameStr db '%s', 0
          ageStr db '%d', 0

          name rd 2
          age rd 1

          question1 db 'What is your name?', 0
          question2 db 'How old are you?', 0
          hello db 'Hello %s! You are %d years old.', 0

          NULL = 0


section '.code' code readable executable

        Start:
               push question1
               call [printf]

               push name
               push nameStr
               call [scanf]

               push question2
               call[printf]

               push age
               push ageStr
               call [scanf]

               push [age]
               push name
               push hello
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

format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable

        question1       db 'Size of array: ', 0
        question2       db '[%d] =  ', 0
        question3       db 'Write the value of x: ', 0
        strIncorSize    db 'Incorrect size of vector = %d', 10, 0
        number          db '%d', 0
        result          db 'Result : ', 10,0
        strVecElemOut   db '[%d] = %d', 10, 0

        size            dd 0 ; Размер массива А.
        countB          dd 0 ; Количество элементов в массиве В.
        x               dd ? ; Значение х, по которому будет проходить фильтрация массива.
        i               dd ? ; Индекс элемента массива.
        tmpA            dd ?
        tmpB            dd ?
        tmpStack        dd ?
        arrA            rd 100
        arrB            rd 100

;--------------------------------------------------------------------------

section '.code' code readable executable
start:
        call input ; Ввод массива А и переменной х.

        call fillArrayB ; Заполнение массива В элементами отличными от А.

        call arrayOutB ; Вывод массива В на консоль.

finish:
        call[getch] ; Ожидание пока пользователь не введёт символ для завершения программы.
        push 0
        call [ExitProcess]

;--------------------------------------------------------------------------

input:
        push question3
        call [printf]  ; Просим пользователя ввести значение x.
        add esp, 4 ; Очищаем стек.

        push x
        push number
        call [scanf] ; Считываем х с консоли.
        add esp, ; Очищаем стек.

        push question1
        call[printf] ; Просим ввести размер массива А.
        add esp, 4 ; Очищаем стек.

        push size
        push number
        call [scanf] ; Считываем размер массива с консоли.
        add esp, 8 ; Очищаем стек.

        mov eax, [size] ; Помещаем значение размера массива в регистр eax.
        cmp eax, 0 ; Проверяем равняется ли размер массива нулю.
        jg getElement ; Если размер массива не равен нулю переходим по метке.

        ; Иначе продолжаем работу.
        push size
        push strIncorSize
        call [printf] ; Выводим сообщение о том, что размер стека задан неверно.
        push 0
        call [ExitProcess] ; Завершаем работу программы.

; Перейдём на эту метку в случае если размер массива больше 0.
getElement:

        xor ecx, ecx ; Зануляем регистр ecx.
        mov ebx, arrA  ; Регистр ebx получает ссылку на массив А.

; В данном цикле происходит считывания значений, введённых пользователем, в массив.
ArrayLoop:

        mov [tmpA], ebx ; Сохраняем ссылку на массив.

        cmp ecx, [size] ; Сравниваем значение в регистре с размером массива.
        jge endInput ; Если значения равны, значит мы прошлись по всей длине массива. Выходим.

        ; Иначе продолжаем работу.
        mov [i], ecx ; Сохраняем индекс.

        push ecx
        push question2
        call [printf] ; Просим пользователя ввести i-ый элемент массива.
        add esp, 8 ; Очищаем стек.

        push ebx
        push number
        call [scanf] ; Считываем число, введённое пользователем.
        add esp, 8 ; Очищаем стек.

        mov ecx, [i] ; Заново получаем значение индекса.
        inc ecx ; Увеличиваем значение индекса на 1.
        mov ebx, [tmpA] ;Восстанавливаем ссылку на массив.
        add ebx, 4 ; Очищаем стек.
        jmp ArrayLoop ; Продолжаем работу цикла пока не пройдёмся по всей длине массива.

; Прерываем работу цикла, если нужное количество элементов считано.
endInput:
        ret

;--------------------------------------------------------------------------

; Здесь происходит заполнение массива В подходящими под условие элементами.
fillArrayB:

        mov [tmpStack], esp ; Сохраняем значение указателя стека.
        xor ecx, ecx ; Зануляем регистр ecx.
        mov eax, arrA ; Регистр eаx получает ссылку на массив А.
        mov ebx, arrB ; Регистр ebx получает ссылку на массив В.

; Цикл проходит по длине всего массива А и записывает в массив В все элементы, которые не совпадают с х.
checkInLoop:

        mov [tmpA], eax ; Сохраняем ссылку на массив А.
        mov [tmpB], ebx ; Сохраняем ссылку на массив В.
        cmp ecx, [size] ; Сравниваем индекс с размером массива.
        je endFilter ; Если индекс больше или равен размеру массива, переходим по метке и выходим.

        mov [i], ecx ; Сохраняем индекс.

        mov eax, [tmpA] ; Восстанавливаем ссылку на массив.
        mov ecx, [eax]
        mov eax, ecx ; Получаем текущий элемент массива.
        cmp [x], ecx ; Сравниваем текущий элемент с х.
        jne addToB ; Если элемент не равен х, он будет добавлен в массив В. Переходим на метку.

        ; Иначе, если элемент равен х, мы продолжим работу цикла.
        mov ecx, [i] ; Получаем текущий индекс.
        inc ecx ; Увеличиваем индекс.
        mov eax, [tmpA] ; Восстанавливаем ссылку на массив А.
        add eax, 4 ; Очищаем стек.
        mov ebx, [tmpB] ; Восстанавливаем ссылку на массив В.
        jmp checkInLoop ; Продолжаем работу цикла.

; Запись элемента массива А в массив В.
addToB:

        mov eax, [tmpA] ; Восстанавливаем ссылку на массив А.
        mov ebx, [tmpB] ; Восстанавливаем ссылку на массив В.
        mov [ebx], ecx ; Получаем индекс.

        mov ecx, [i]
        inc ecx ; Увеличиваем индекс.
        add eax, 4 ; Очищаем стек.
        add ebx, 4 ; Очищаем стек.

        xor edx, edx ; Зануляем значение регистра.
        mov edx, [countB] ; Получаем число элементов массива В.
        inc edx ; Увеличиваем число.
        mov [countB], edx ; Помещаем число в массив В.

        jmp checkInLoop ; Возвращаемся в цикл.

; Прерываем работу цикла, если мы прошлись по всем элементам массива.
endFilter:

        mov esp, [tmpStack] ; Возвращаем положение стека.
        ret

;--------------------------------------------------------------------------

; Здесь происходит вывод массива В на консоль.
arrayOutB:

        push result
        call [printf] ; Печатаем "Result : "
        add esp, 4 ; Очищаем стек.

        mov [tmpStack], esp ; Сохраняем значение указателя стека.
        xor ecx, ecx ; Зануляем значение регистра.
        mov ebx, arrB ; Получаем ссылку на массив.

; Цикл вывода массива.
loopB:

        mov [tmpA], ebx  ; Сохраняем массив.
        cmp ecx, [countB] ; Сравниваем значение счётчика и длину массива.
        je endOutputB ; Если значения равны - мы прошлись по всему массиву и можем завершать программу.
        mov [i], ecx ; Сохраняем индекс.

        push dword [ebx] ; Получаем текущий элемент.
        push ecx
        push strVecElemOut
        call [printf] ; Выводим текущий элемент.

        mov ecx, [i]
        inc ecx ; Увеличиваем индекс на 1.
        mov ebx, [tmpA] ; Восстанавливаем массив.
        add ebx, 4
        jmp loopB ; Продолжаем работу цикла.

endOutputB:

        mov esp, [tmpStack] ; Возвращаем положение стека.
        ret


;-------------------------------third act - including HeapApi--------------------------

section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'






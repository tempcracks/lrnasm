/* Профессиональный ABI-совместимый frame */
.type professional_func, @function
professional_func:
    /* Пролог */
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %esi
    pushl %edi
    
    /* Локальные переменные */
    subl $LOCAL_SIZE, %esp
    
    /* Сохранение регистров в соответствии с ABI */
    movl 8(%ebp), %eax        # Первый аргумент
    movl 12(%ebp), %ebx       # Второй аргумент
    
    /* Тело функции */
    # ...
    
    /* Эпилог */
    movl %ebp, %esp
    popl %edi
    popl %esi
    popl %ebx
    popl %ebp
    ret $8                    # Удаляем аргументы

  pushl %ebx, %esi, %edi - сохраняем callee-saved регистры (те, которые функция обязана сохранить по соглашению ABI)

  high memory address
  |  arg2        | <- ebp+16
  ----------------
  |  arg1        |
  ----------------
  | return address|
  ----------------
  | old ebp       |<- ebp 
  ----------------
  |  saved edi    |
  | saved edi      |
  | saved ebx      |<- ebp-12
  -----------------
  |  local variables|<- ebp-12 = local variables


function parameters
RETURN value: for integer or pointer return types, its placed in RAX
Parameters (in order):
1st argument: RDI
2nd argument: RSI
3nd argument: RDX
4th argument: RCX
5th argument: R8
6th argument: R9
7th+ argument passed on the stack

The Stack
the stack pointer (RSP) must be 16-byte aligned before a call instruction
the call instruction pushes the 8-byte return address,so upon entry to a function,
RSP is RSP-8 breaking the alignment. the function prologue often adjusts it back
(e.g. with a push rbp)


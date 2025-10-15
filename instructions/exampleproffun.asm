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

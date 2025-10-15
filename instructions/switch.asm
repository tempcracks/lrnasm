.data
    # Таблица адресов переходов.
    # Каждое значение .long — это адрес метки в секции кода.
jump_table:
    .long case_0
    .long case_1
    .long case_2
    .long case_3

.text
.globl _start

_start:
    movl $2, %eax   # Загружаем в %eax индекс 2 (хотим перейти к case_2)

    jmp *jump_table(,%eax,4)  # Косвенный переход через таблицу

case_0:
    # Код для случая 0
    movl $1, %ebx
    jmp end

case_1:
    # Код для случая 1
    movl $2, %ebx
    jmp end

case_2:
    # Код для случая 2 (сюда и произойдет переход)
    movl $3, %ebx
    jmp end

case_3:
    # Код для случая 3
    movl $4, %ebx
    jmp end

end:
    # Завершение программы
    movl $1, %eax
    int $0x80

-----------------------same on C
#include <stdio.h>

// Функции для каждого case
void case_0() { printf("Case 0\n"); }
void case_1() { printf("Case 1\n"); }
void case_2() { printf("Case 2\n"); }
void case_3() { printf("Case 3\n"); }

// Таблица переходов (массив указателей на функции)
void (*jump_table[])(void) = {
    case_0,
    case_1, 
    case_2,
    case_3
};

int main() {
    int eax = 2; // Аналог movl $2, %eax
    
    // Эквивалент jmp *jump_table(,%eax,4)
    jump_table[eax](); // Вызов функции по индексу 2 (case_2)
    
    return 0;
}
--------------------------same on c++
by vector<function(void)> .....

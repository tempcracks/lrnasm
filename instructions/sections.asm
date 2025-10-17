.section .bss
buffer:     .space 1024       /* Буферы */
variable:   .space 4          /* Переменные */

.section .rodata
pi:         .double 3.1415    /* Математические константы */
messages:   .asciz "Error"    /* Сообщения */

Professional sectors (embedded/systems)
Векторы прерываний

.section .isr_vector,"ax",@progbits
.align 2
vectors:
    .word _stack_top          /* Указатель стека */
    .word reset_handler       /* Вектор сброса */
    .word nmi_handler         /* Аппаратные прерывания */

.section .text.fast,"ax",@progbits
irq_handler:
  push {r0-r12}
  pop {r0-r12}
  bx lr

.section .noinit,"aw",@nobits
persistent: .space 16 Данные при сбросе 
.section .backup,"aw",@nobits
backup_ram: .space 128   Battery-backed RAM 

.section .flash_config,"a",@progbits
.flash_opt: .word 0xFFFF0000 // options flash
.security: .word 0xFFFFFF // security


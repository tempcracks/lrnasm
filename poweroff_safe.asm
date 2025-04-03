; shutdown.asm - корректное завершение работы Linux (x86_64)
; Компиляция: nasm -f elf64 shutdown.asm && ld -o shutdown shutdown.o
; Запуск: ./shutdown (требует прав root)

section .data
    ; Константы для sys_reboot
    LINUX_REBOOT_MAGIC1      equ 0xfee1dead
    LINUX_REBOOT_MAGIC2      equ 672274793
    LINUX_REBOOT_CMD_POWER_OFF equ 0x4321fedc

section .text
    global _start

_start:
    ; Системный вызов reboot (номер 169)
    mov rax, 169                  ; syscall номер для reboot
    mov rdi, LINUX_REBOOT_MAGIC1  ; magic1
    mov rsi, LINUX_REBOOT_MAGIC2  ; magic2
    mov rdx, LINUX_REBOOT_CMD_POWER_OFF ; команда
    mov r10, 0                    ; дополнительные аргументы (не используются)
    syscall

    ; Если reboot вернул ошибку (не должно случиться с root)
    mov rdi, rax                  ; код ошибки
    mov rax, 60                   ; sys_exit
    syscall

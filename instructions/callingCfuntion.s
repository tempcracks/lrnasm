main.c
#include <stdio.h>
int add(int a, int b){
  return a+b;
}
main.s

.section .text
.globl main
.type main, @funtion

main:
#prologue (callee-saved)
push %rbp
mov %rsp,%rbp

#call the add function according to the ABI
#first argument (a) goes in EDI (the 32 bit part of RDI)
mov $5, %edi
mov $10, %esi
#call the function. this pushes the return address onto the stack
call add
# the result is now in eax (the 32-bit part of RAX)

#we calling printf("%d\n", result);

mov $.LC0, %rdi #.LC0 is our format string
mov %eax, %esi

mov $0, %al
call printf

#epilogue
mov %rbp, %rsp
pop %rbp
mov $0, %eax
ret

.section .rodata
.LC0:
  .string "the result is : %d\n"
  

.data
# struct person
person:
  .long 0x11111111 #.id (offset 0)
  .long 0x22222222 #.age (offset 4)
  .long 0x33333333 #.salary (offset 8)

.text
movl $person, %ebx #ebx = ptr to struct

movl 0(%ebx), %eax #eax = person->id
movl 4(%ebx), %eax #eax = person->age
movl 8(%ebx), %eax #eax = person->salary

#-----------------------------

.data
function_ptr: .long my_function

.text
my_function:
  movl $42, %eax
  ret

main:
  # indirect call into ptr
  call *function_ptr #call *ptr

  # or into reg
  movl $my_function, %ebx
  call *%ebx #call *reg

#----------------------------

.data
value: .long 0x12345678
single: .long value #ptr to value
double: .long single #ptr to ptr

.text
movl double, %eax #eax = address single
movl (%eax), %ebx #ebx = address value (from single)
movl (%ebx), %ecx #ecx = 0x12345678 (from value)

#----------------------

.data
values: .long 0x11111111, 0x222222222, 0x33333333
ptr_array: .long values, values+4, values+8 # array of ptr's

.text
movl $ptr_array, %esi #esi = begin of array ptr's
movl (%esi), %edi #edi = fist ptr (on values[0])
movl (%edi), %eax #eax = values[0] = 0x11111111

movl 4(%esi), %edi
movl (%edi), %ebx #ebx = values[1] = 0x2222222

#------------------------------
Arithmetic pointers
.data
array: .long 0x10,0x20,0x30
.text
movl $array, %ebx

addl $4, %ebx #ebx++
movl (%ebx), %eax #eax = array[1] = 0x20

movl $2, %ecx
movl array(,$ecx,4), $edx #edx = array[2] = 0x30

#-=-------------------

Practical example
.data
string: .asciz "Hello"
length: .long 0

.text
movl $string, %esi #esi - ptr on string
movl $0, %ecx #scetcik

loop:
movb (%esi), %al #al = *pointer
cmpb $0, %al #is the end?
je done
incl %ecx
incl %esi #pointer++
jmp loop

done:
  movl %ecx, length #save legnth

#-------------------------


.data
matrix:
  .float 1.0,2.0,3.0,4.0
  .float 5.0,6.0,7.0,8,0
  .float 9,0,10.0,11.0,12.0

rows = 3
cols = 4
element_size = 4

.text
.globl access_matrix_element

#access to matrix[i][j] - rdi =i , rsi = j
access_matrix_element:
  # i * cols + j
  movq %rdi, %rax
  imulq $cols, %rax
  addq %rsi, %rax

  #matrix + (i * cols + j) * element_size
  leaq matrix(%rip), %rcx
  movq %rax, %rdx
  imulq $element_size, %rdx
  movss (%rcx, %rdx), %xmm0 #load float

  ret
  
#multiple matrix to scalar
.globl matrix_scalar_multiply
matrix_scalar_multiply:
  #rdi = matrix, rsi = rows, rdx = cols, xmm0 = scalar
  movq %rdi, %r8 #matrix
  movq %rsi, %r9 #rows
  movq %rdx, %r10 #cols

  xorq %rcx, %rcx  #i =  0

row_loop:
  xorq %r11, %r11 #j=0
col_loop:
  #index = i* cols+j
  movq %rcx, %rax
  imulq %r10, %rax
  addq %r11, %rax

  #load elementl
  movss (%r8, %rax, 4), %xmm1
  mulss %xmm0, %xmm1 #mul to scalar
  movss %xmm1, (%r8, %rax, 4) #save

  incq %r11
  cmpq %r10, %r11
  jl col_loop

  incq %rcx
  cmpq %r9, %rcx
  jl row_loop

  ret

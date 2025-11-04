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

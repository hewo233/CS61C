.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
    
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # Open the file

    mv a1, s0
    li a2, 0
    jal ra, fopen
    li t0, -1
    beq a0, t0, error_50
    mv s3, a0 # s3 is the file pointer

    # Read the number of rows and columns

    li a0, 8
    jal ra, malloc
    beq a0, x0, error_53
    mv s4, a0 # s4 is the pointer to row and col

	mv a1, s3
    mv a2, s4
    li a3, 8
    jal ra, fread
    bne a0, a3, error_51

    lw t0, 0(s4)
    sw t0, 0(s1)
    lw t1, 4(s4)
    sw t1, 0(s2)
    mul t0, t0, t1 # t0 is the size of matrix
    slli t0, t0, 2 # t0 is the size of matrix in bytes

    mv a0, s4
    jal ra, free

    # Read the matrix

    mv a0, t0
    jal ra, malloc
    beq a0, x0, error_53
    mv s4, a0

    mv a1, s3
    mv a2, s4
    mv a3, t0
    jal ra, fread
    bne a0, a3, error_51

    # Close the file

    mv a1, s3
    jal ra, fclose
    li t0, -1
    beq a0, t0, error_52    

    mv a0, s4 #return

    # Epilogue

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24

    jr ra


error_50:
    li a1, 50
    jal exit2

error_51:
    li a1, 51
    jal exit2

error_52:
    li a1, 52
    jal exit2

error_53:
    li a1, 53
    jal exit2
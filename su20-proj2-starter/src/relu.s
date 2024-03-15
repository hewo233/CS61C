.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
    li t0, 0 # t0 is i, i = 0

loop_start:
    bge t0, a1, loop_end

    slli t1, t0, 2 # t1 = i * sizerof(int) 
    add t1, t1, a0 # t1 = &a[i]
    lw t2, 0(t1) # t2 = a[i]

    blt t2, x0, less_zero

    j loop_continue

less_zero:
    sw x0, 0(t1) # a[i] = 0

loop_continue:
    addi t0, t0, 1 # i++
    j loop_start

loop_end:
    ret


.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================

# I use a0-4, t0-6

dot:

    # check error
    li t3, 1
    blt a2, t3, length_less
    li t3, 1
    blt a3, t3, stride_less
    blt a4, t3, stride_less

    # Init
    li t0, 0 # t0 is i = 0
    li t6, 0 # t1 use to store ans

loop_start:
    
    bge t0, a2, loop_end 

    slli t1, t0, 2 # t1 = i*4

    mul t3, t1, a3
    mul t4, t1, a4

    add t3, a0, t3
    add t4, a1, t4

    lw t3, 0(t3)
    lw t4, 0(t4)

    mul t5, t3, t4
    add t6, t6, t5

    j loop_continue

length_less:
    li a1, 5
    ret

stride_less:
    li a1, 6
    ret

loop_continue:
    addi t0, t0, 1 # i++
    j loop_start

loop_end:

    mv a0, t6
    ret
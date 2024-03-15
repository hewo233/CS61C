.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:
    li t0, 1

    li t3, -114514
    li t4, 233
    
    blt a1, t0, error_exit
   

    li t0, 0 # i = 0, t0 is i

loop_start:
    
    bge t0, a1, loop_end # if i >= a1, jump to loop_end

    slli t1, t0, 2 # t1 = i * 4
    add t1, t1, a0 # t1 = &a[i]
    lw t2, 0(t1) # t2 = a[i]

    bgt t2, t3, change_max

    j loop_continue
    
change_max: 
    mv t3, t2
    mv t4, t0

loop_continue:
    addi t0, t0, 1 # i++
    j loop_start

error_exit:
    li t4, 7
    j loop_end

loop_end:
    mv a0, t4
    ret
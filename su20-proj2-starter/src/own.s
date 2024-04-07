.import utils.s

.data
v0: .word 3 -42 432 7 -5 6 5 -114 2

.text 


j main

# swap the word of the a3, a2 (a3, a2 is address)
swap: 

    addi sp, sp, -12
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)

    lw t0, 0(a3)
    lw t1, 0(a2)
    sw t1, 0(a3)
    sw t0, 0(a2)

    lw t1, 4(sp)
    lw t2, 8(sp)
    addi sp, sp, 12

    jr ra

main:

    la s0, v0
    li t0, 0 # i = 0
    li t1, 0 # j = 0
    li s1, 9 # n = 9

out_loop:
    beq t0, s1, out_loop_end

inner_loop:
    beq t1, s1, inner_loop_end
    slli t2, t1, 2
    add t2, t2, s0
    lw t3, 0(t2)
    lw t4, 4(t2)
    addi t1, t1, 1
    bgt t3, t4, ready_swap
    j inner_loop

ready_swap:

    addi sp, sp, -8
    sw a3, 0(sp)
    sw a2, 4(sp)

    mv a3, t2
    addi a2, t2, 4

    jal ra, swap

    lw a3, 0(sp)
    lw a2, 4(sp)
    addi sp, sp, 8
    j inner_loop

inner_loop_end:
    addi t0, t0, 1
    li t1, 0
    j out_loop 

out_loop_end:
    mv a0, s0
    li a1, 1
    li a2, 9
   jal ra, print_int_array

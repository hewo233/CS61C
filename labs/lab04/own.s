.data
v0: .word 3 -42 432 7 -5 6 5 -114 2

.text 


j main

# swap the word of the x3, x2 (x3, x2 is address)
swap: 

    addi sp, sp, -12
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)

    lw t0, 0(x3)
    lw t1, 0(x2)
    sw t1, 0(x3)
    sw t0, 0(x2)

    lw t0, 0(sp)
    mv t0, t1
    mv t1, t2
    sw t0, 0(x3)
    sw t1, 0(x2)
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
    bgt t3, t4, ready_swap
    j inner_loop

ready_swap:

    addi sp, sp, -8
    sw x3, 0(sp)
    sw x2, 4(sp)

    mv x3, t2
    addi x2, t2, 4

    jal ra, swap

    lw x3, 0(sp)
    lw x2, 4(sp)
    addi sp, sp, 8
    j inner_loop

inner_loop_end:
    addi t0, t0, 1
    li t1, 0
    j out_loop 

out_loop_end:
    li x1, 233

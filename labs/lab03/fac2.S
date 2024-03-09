.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    mv a0, a1
    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    addi sp, sp, -8
    sw ra, 0(sp)

    li t0, 1
    ble a0, t0, ret_one

    sw a0, 4(sp)

    addi a0, a0, -1
    jal factorial

    lw t0, 4(sp)
    mul a1, t0, a1

    lw ra, 0(sp)
    addi sp, sp, 8
    jr ra

ret_one:
    li a1, 1
    lw ra, 0(sp)
    addi sp, sp, 8
    jr ra
    
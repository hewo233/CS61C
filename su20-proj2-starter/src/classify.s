.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    li t0, 5
    bne a0, t0, exit_49

    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)

    mv s0, a1
    mv s1, a2

	# =====================================
    # LOAD MATRICES
    # =====================================


    # Load pretrained m0

    li a0, 8
    jal ra, malloc
    beq a0, zero, exit_48
    mv s2, a0 # m0 ints

    lw a0, 4(s0)
    addi a1, s2, 0
    addi a2, s2, 4
    jal ra,read_matrix  
    mv s3, a0 # m0 address


    # Load pretrained m1

    li a0, 8
    jal ra, malloc
    beq a0, zero, exit_48
    mv s4, a0 # m1 ints

    lw a0, 8(s0)
    addi a1, s4, 0
    addi a2, s4, 4
    jal ra,read_matrix  
    mv s5, a0 # m1 address


    # Load input matrix

    li a0, 8
    jal ra, malloc
    beq a0, zero, exit_48
    mv s6, a0 # input ints

    lw a0, 12(s0)
    addi a1, s6, 0
    addi a2, s6, 4
    jal ra,read_matrix   # input address
    mv s7, a0


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    lw t0, 0(s2)
    lw t1, 4(s6)
    mul a0, t0, t1
    slli a0, a0, 2
    jal ra,malloc
    beq a0, zero, exit_48
    mv s8, a0  

    mv a0, s3
    lw a1, 0(s2)
    lw a2, 4(s2)
    mv a3, s7
    lw a4, 0(s6)
    lw a5, 4(s6)
    mv a6, s8   # s8 is m0 * input
    jal ra, matmul

   # mv a0, s8
   # li a1, 3
   # li a2, 1
   # jal ra, print_int_array

    mv a0, s8
    lw t0, 0(s2)
    lw t1, 4(s6)
    mul a1, t0, t1
    jal ra, relu

    lw t0, 0(s4)
    lw t1, 4(s6)
    mul a0, t0, t1
    slli a0, a0, 2
    jal ra, malloc
    beq a0, zero, exit_48
    mv s9, a0

    mv a0, s5
    lw a1, 0(s4)
    lw a2, 4(s4)
    mv a3, s8
    lw a4, 0(s2)
    lw a5, 4(s6)
    mv a6, s9
    jal ra, matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw a0, 16(s0)
    mv a1, s9
    lw a2, 0(s4)
    lw a3, 4(s6)
    jal ra, write_matrix


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    mv a0, s9
    lw t0, 0(s4)
    lw t1, 4(s6)
    mul a1, t0, t1

    jal ra, argmax
    mv s10, a0


    bne s1, x0, pass_print

    # Print classification
    
    mv a1, s10
    jal ra, print_int


    # Print newline afterwards for clarity

    li a1, '\n'
    jal ra, print_char

pass_print:
    mv a0, s2
    jal free
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free
    mv a0, s8
    jal free
    mv a0, s9
    jal free

    mv a0, s10

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    addi sp, sp, 48

    jr ra

exit_48:
    li a1, 48
    jal exit2

exit_49:
    li a1, 49
    jal exit2

exit_48_1:
    li a1, 481
    jal exit2
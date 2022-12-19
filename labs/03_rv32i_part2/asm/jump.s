addi x2, x0, 2
jal ra, JUMP_HERE
addi x2, x0, 10 # won't run
JUMP_HERE: addi x3, x0, 3
jalr x0, ra, 0
addi x4, x0, 4
addi x5, x0, 5
addi x6, x0, 6
addi x7, x0, 7
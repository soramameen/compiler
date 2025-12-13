    INITIAL_GP = 0x10008000
    INITIAL_SP = 0x7ffffffc
    stop_service = 99

    .text
init:
    la $gp, INITIAL_GP
    la $sp, INITIAL_SP
    jal main
    nop
    li $v0, stop_service
    syscall
    nop
stop:
    j stop
    nop

    .text 0x00001000
main:
    la $t0, RESULT
#s assignment sum
    li $v0, 0
    addi $t6, $t0, 4
#assign
    sw $v0, 0($t6)
    nop
#e assignment
#s assignment i
    li $v0, 1
    addi $t6, $t0, 0
#assign
    sw $v0, 0($t6)
    nop
#e assignment
$WHILE0:
# s left expression
    addi $t6, $t0, 0
    lw $t1, 0($t6)
    nop
# e left expression
# s right expression
    li $t3, 11
# e right expression
# s while branch
    slt $t2, $t1, $t3
    beq $t2, $zero, $ENDWHILE0
    nop
# e while branch  |  d
#s assignment sum
    addi $t6, $t0, 4
    lw $t1, 0($t6)
    nop
    sw $t1 8($sp)
    nop
    addi $t6, $t0, 0
    lw $t3, 0($t6)
    nop
    sw $t3 12($sp)
    nop
    lw $t1, 8($sp)
    nop
    lw $t3, 12($sp)
    nop
    add $v0, $t1, $t3
#after operator   |  i
    sw $v0, 4($sp)
    nop
    addi $t6, $t0, 4
#assign
    sw $v0, 0($t6)
    nop
#e assignment     |  ff?
#s assignment     |  ser
    addi $t6, $t0, 0
    lw $t1, 0($t6)
    nop
    sw $t1 4($sp)
    nop
    li $t3, 1
    sw $t3 8($sp)
    nop
    lw $t1, 4($sp)
    nop
    lw $t3, 8($sp)
    nop
    add $v0, $t1, $t3
#after operator
    sw $v0, 0($sp)
    nop
    addi $t6, $t0, 0
#assign           |  ious
    sw $v0, 0($t6)
    nop
#e assignment     |  ly?
    j $WHILE0
    nop
$ENDWHILE0:

    jr $ra
    nop
    .data 0x10004000
RESULT:


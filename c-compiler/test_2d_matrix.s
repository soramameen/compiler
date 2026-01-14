INITIAL_GP = 0x10008000
INITIAL_SP = 0x7ffffffc
stop_service = 99

.text
init:
  la $gp, INITIAL_GP
  la $sp, INITIAL_SP
  jal main
  nop
  add $a0, $v0, $zero
  li $v0, stop_service
  syscall
  nop
stop:
  j stop
  nop

.text
main:
  addiu $sp, $sp, -52
  sw $ra, 48($sp)
  sw $fp, 44($sp)
  addiu $fp, $sp, 52
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 0
  add $t0, $v0, $zero
  li $v0, 0
  add $t1, $v0, $zero
  li $t2, 3
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -32
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 2
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 0
  add $t0, $v0, $zero
  li $v0, 1
  add $t1, $v0, $zero
  li $t2, 3
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -32
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 3
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 0
  add $t0, $v0, $zero
  li $v0, 2
  add $t1, $v0, $zero
  li $t2, 3
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -32
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 4
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 1
  add $t0, $v0, $zero
  li $v0, 0
  add $t1, $v0, $zero
  li $t2, 3
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -32
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 5
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 1
  add $t0, $v0, $zero
  li $v0, 1
  add $t1, $v0, $zero
  li $t2, 3
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -32
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 6
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 1
  add $t0, $v0, $zero
  li $v0, 2
  add $t1, $v0, $zero
  li $t2, 3
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -32
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 0
  sw $v0, -36($fp)
  li $v0, 0
  sw $v0, -40($fp)
$WHILE_LOOP_START_0:
  li $v0, 2
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -40($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $v0, $v0, $v1
  beq $v0, $zero, $WHILE_LOOP_END_0
  nop
  li $v0, 0
  sw $v0, -44($fp)
$WHILE_LOOP_START_1:
  li $v0, 3
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -44($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $v0, $v0, $v1
  beq $v0, $zero, $WHILE_LOOP_END_1
  nop
  lw $v0, -40($fp)
  nop
  add $t0, $v0, $zero
  lw $v0, -44($fp)
  nop
  add $t1, $v0, $zero
  li $t2, 3
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -32
  add $t3, $fp, $t3
  lw $v0, 0($t3)
  nop
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -36($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -36($fp)
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -44($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -44($fp)
  j $WHILE_LOOP_START_1
  nop
$WHILE_LOOP_END_1:
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -40($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -40($fp)
  j $WHILE_LOOP_START_0
  nop
$WHILE_LOOP_END_0:
  lw $v0, -36($fp)
  nop
  lw $ra, 48($sp)
  nop
  lw $fp, 44($sp)
  nop
  addiu $sp, $sp, 52
  jr $ra
  nop

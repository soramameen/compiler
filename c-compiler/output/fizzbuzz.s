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
  addiu $sp, $sp, -36
  sw $ra, 32($sp)
  sw $fp, 28($sp)
  addiu $fp, $sp, 36
  li $v0, 0
  sw $v0, -12($fp)
  li $v0, 0
  sw $v0, -16($fp)
  li $v0, 0
  sw $v0, -20($fp)
  li $v0, 0
  sw $v0, -24($fp)
  li $v0, 1
  sw $v0, -28($fp)
$WHILE_LOOP_START_0:
  li $v0, 31
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -28($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $v0, $v0, $v1
  beq $v0, $zero, $WHILE_LOOP_END_0
  nop
  lw $v0, -28($fp)
  nop
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 15
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 15
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -28($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  div $v0, $v1
  mflo $v0
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  mult $v0, $v1
  mflo $v0
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   sub $v0, $v0, $v1
  nop
   sltiu $v0, $v0, 1
  beq $v0, $zero, $IF_ELSE_1
  nop
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -20($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -20($fp)
  j $IF_END_1
  nop
$IF_ELSE_1:
  lw $v0, -28($fp)
  nop
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 3
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 3
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -28($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  div $v0, $v1
  mflo $v0
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  mult $v0, $v1
  mflo $v0
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   sub $v0, $v0, $v1
  nop
   sltiu $v0, $v0, 1
  beq $v0, $zero, $IF_ELSE_2
  nop
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -12($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -12($fp)
  j $IF_END_2
  nop
$IF_ELSE_2:
  lw $v0, -28($fp)
  nop
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 5
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 5
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -28($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  div $v0, $v1
  mflo $v0
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  mult $v0, $v1
  mflo $v0
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   sub $v0, $v0, $v1
  nop
   sltiu $v0, $v0, 1
  beq $v0, $zero, $IF_ELSE_3
  nop
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -16($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -16($fp)
  j $IF_END_3
  nop
$IF_ELSE_3:
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -24($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -24($fp)
$IF_END_3:
$IF_END_2:
$IF_END_1:
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -28($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -28($fp)
  j $WHILE_LOOP_START_0
  nop
$WHILE_LOOP_END_0:
  lw $v0, -24($fp)
  nop
  lw $ra, 32($sp)
  nop
  lw $fp, 28($sp)
  nop
  addiu $sp, $sp, 36
  jr $ra
  nop

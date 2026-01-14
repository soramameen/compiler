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
  addiu $sp, $sp, -44
  sw $ra, 40($sp)
  sw $fp, 36($sp)
  addiu $fp, $sp, 44
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 0
  sll $v0, $v0, 2
  addi $v0, $v0, -28
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $t0, $fp, $v0
  sw $v1, 0($t0)
  li $v0, 2
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 1
  sll $v0, $v0, 2
  addi $v0, $v0, -28
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $t0, $fp, $v0
  sw $v1, 0($t0)
  li $v0, 3
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 2
  sll $v0, $v0, 2
  addi $v0, $v0, -28
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $t0, $fp, $v0
  sw $v1, 0($t0)
  li $v0, 4
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 3
  sll $v0, $v0, 2
  addi $v0, $v0, -28
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $t0, $fp, $v0
  sw $v1, 0($t0)
  li $v0, 5
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 4
  sll $v0, $v0, 2
  addi $v0, $v0, -28
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $t0, $fp, $v0
  sw $v1, 0($t0)
  li $v0, 0
  sw $v0, -32($fp)
  li $v0, 0
  sw $v0, -36($fp)
$WHILE_LOOP_START_0:
  li $v0, 5
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -36($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $v0, $v0, $v1
  beq $v0, $zero, $WHILE_LOOP_END_0
  nop
  lw $v0, -36($fp)
  nop
  sll $v0, $v0, 2
  addi $v0, $v0, -28
  add $t0, $fp, $v0
  lw $v0, 0($t0)
  nop
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -32($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -32($fp)
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -36($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -36($fp)
  j $WHILE_LOOP_START_0
  nop
$WHILE_LOOP_END_0:
  lw $v0, -32($fp)
  nop
  lw $ra, 40($sp)
  nop
  lw $fp, 36($sp)
  nop
  addiu $sp, $sp, 44
  jr $ra
  nop

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

.text
main:
  addiu $sp, $sp, -16
  sw $ra, 12($sp)
  sw $fp, 8($sp)
  addiu $fp, $sp, 16
  li $v0, 0
  sw $v0, -8($fp)
  li $v0, 1
  sw $v0, -4($fp)
$WHILE_LOOP_START_0:
  li $v0, 11
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -4($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $v0, $v0, $v1
  beq $v0, $zero, $WHILE_LOOP_END_0
  nop
  lw $v0, -4($fp)
  nop
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -8($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -8($fp)
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -4($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -4($fp)
  j $WHILE_LOOP_START_0
  nop
$WHILE_LOOP_END_0:
  lw $v0, -8($fp)
  nop
  lw $ra, 12($sp)
  nop
  lw $fp, 8($sp)
  nop
  addiu $sp, $sp, 16
  jr $ra
  nop

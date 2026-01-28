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
  addiu $sp, $sp, -24
  sw $ra, 20($sp)
  sw $fp, 16($sp)
  addiu $fp, $sp, 24
  li $v0, 1
  sw $v0, -16($fp)
  li $v0, 1
  sw $v0, -12($fp)
$WHILE_LOOP_START_0:
  li $v0, 6
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -12($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $v0, $v0, $v1
  beq $v0, $zero, $WHILE_LOOP_END_0
  nop
  lw $v0, -12($fp)
  nop
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -16($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  mult $v0, $v1
  mflo $v0
  sw $v0, -16($fp)
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -12($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -12($fp)
  j $WHILE_LOOP_START_0
  nop
$WHILE_LOOP_END_0:
  lw $v0, -16($fp)
  nop
  lw $ra, 20($sp)
  nop
  lw $fp, 16($sp)
  nop
  addiu $sp, $sp, 24
  jr $ra
  nop

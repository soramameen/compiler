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
  li $v0, 0
  add $t1, $v0, $zero
  li $v0, 1
  add $t0, $v0, $zero
$WHILE_LOOP_START_0:
  li $v0, 11
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  add $v0, $t0, $zero
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $v0, $v0, $v1
  beq $v0, $zero, $WHILE_LOOP_END_0
  nop
  add $v0, $t0, $zero
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  add $v0, $t1, $zero
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  add $t1, $v0, $zero
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  add $v0, $t0, $zero
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  add $t0, $v0, $zero
  j $WHILE_LOOP_START_0
  nop
$WHILE_LOOP_END_0:
  add $v0, $t1, $zero
  lw $ra, 20($sp)
  nop
  lw $fp, 16($sp)
  nop
  addiu $sp, $sp, 24
  jr $ra
  nop

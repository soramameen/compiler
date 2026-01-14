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
  addiu $sp, $sp, -4036
  sw $ra, 4032($sp)
  sw $fp, 4028($sp)
  addiu $fp, $sp, 4036
  li $v0, 1000
  sw $v0, -12($fp)
  li $v0, 1
  sw $v0, -16($fp)
$WHILE_LOOP_START_0:
  lw $v0, -12($fp)
  nop
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -16($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $t0, $v1, $v0
  nop
   xori $v0, $t0, 1
  beq $v0, $zero, $WHILE_LOOP_END_0
  nop
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -16($fp)
  nop
  sll $v0, $v0, 2
  addi $v0, $v0, -4028
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $t0, $fp, $v0
  sw $v1, 0($t0)
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -16($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -16($fp)
  j $WHILE_LOOP_START_0
  nop
$WHILE_LOOP_END_0:
  li $v0, 2
  sw $v0, -16($fp)
$WHILE_LOOP_START_1:
  li $v0, 2
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -12($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  div $v0, $v1
  mflo $v0
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -16($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $t0, $v1, $v0
  nop
   xori $v0, $t0, 1
  beq $v0, $zero, $WHILE_LOOP_END_1
  nop
  li $v0, 2
  sw $v0, -20($fp)
$WHILE_LOOP_START_2:
  lw $v0, -16($fp)
  nop
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -12($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  div $v0, $v1
  mflo $v0
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -20($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $t0, $v1, $v0
  nop
   xori $v0, $t0, 1
  beq $v0, $zero, $WHILE_LOOP_END_2
  nop
  lw $v0, -20($fp)
  nop
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -16($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  mult $v0, $v1
  mflo $v0
  sw $v0, -24($fp)
  li $v0, 0
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -24($fp)
  nop
  sll $v0, $v0, 2
  addi $v0, $v0, -4028
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $t0, $fp, $v0
  sw $v1, 0($t0)
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -20($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -20($fp)
  j $WHILE_LOOP_START_2
  nop
$WHILE_LOOP_END_2:
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -16($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -16($fp)
  j $WHILE_LOOP_START_1
  nop
$WHILE_LOOP_END_1:
  li $v0, 6
  sll $v0, $v0, 2
  addi $v0, $v0, -4028
  add $t0, $fp, $v0
  lw $v0, 0($t0)
  nop
  lw $ra, 4032($sp)
  nop
  lw $fp, 4028($sp)
  nop
  addiu $sp, $sp, 4036
  jr $ra
  nop

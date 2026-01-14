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
  addiu $sp, $sp, -32
  sw $ra, 28($sp)
  sw $fp, 24($sp)
  addiu $fp, $sp, 32
  li $v0, 5
  sw $v0, -12($fp)
  li $v0, 10
  sw $v0, -16($fp)
  li $v0, 10
  sw $v0, -20($fp)
  li $v0, 0
  sw $v0, -24($fp)
  lw $v0, -16($fp)
  nop
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -12($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $t0, $v1, $v0
  nop
   xori $v0, $t0, 1
  beq $v0, $zero, $IF_END_1
  nop
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -24($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -24($fp)
$IF_END_1:
  lw $v0, -20($fp)
  nop
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -16($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $t0, $v0, $v1
  nop
   xori $v0, $t0, 1
  beq $v0, $zero, $IF_END_2
  nop
  li $v0, 10
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -24($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -24($fp)
$IF_END_2:
  lw $v0, -16($fp)
  nop
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -20($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $t0, $v1, $v0
  nop
   xori $v0, $t0, 1
  beq $v0, $zero, $IF_END_3
  nop
  li $v0, 100
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -24($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -24($fp)
$IF_END_3:
  lw $v0, -16($fp)
  nop
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -12($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $t0, $v0, $v1
  nop
   xori $v0, $t0, 1
  beq $v0, $zero, $IF_END_4
  nop
  li $v0, 1000
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -24($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -24($fp)
$IF_END_4:
  li $v0, 15
  sw $v0, -12($fp)
  li $v0, 10
  sw $v0, -16($fp)
  lw $v0, -16($fp)
  nop
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -12($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $t0, $v0, $v1
  nop
   xori $v0, $t0, 1
  beq $v0, $zero, $IF_END_5
  nop
  li $v0, 10000
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -24($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -24($fp)
$IF_END_5:
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
  beq $v0, $zero, $IF_END_6
  nop
  li $v0, 100000
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -24($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -24($fp)
$IF_END_6:
  lw $v0, -24($fp)
  nop
  lw $ra, 28($sp)
  nop
  lw $fp, 24($sp)
  nop
  addiu $sp, $sp, 32
  jr $ra
  nop

.text
.globl main
main:
  addu $fp, $sp, $zero
  addi $sp, $sp,-8
  li $v0, 0
  sw $v0, -8($fp)
  li $v0, 1
  sw $v0, -4($fp)
WHILE_LOOP_START_1:
  li $v0, 11
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -4($fp)
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $v0, $v0, $v1
  beq $v0,$zero, WHILE_LOOP_END_1
  lw $v0, -4($fp)
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -8($fp)
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -8($fp)
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -4($fp)
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -4($fp)
  j WHILE_LOOP_START_1
WHILE_LOOP_END_1:
  lw $v0, -8($fp)
  addu $sp, $fp, $zero
  addu $a0, $v0, $zero
  li $v0, 17
  syscall


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
  li $v0, 10
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 0
  sll $v0, $v0, 2
  addi $v0, $v0, -28
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $t0, $fp, $v0
  sw $v1, 0($t0)
  li $v0, 20
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 1
  sll $v0, $v0, 2
  addi $v0, $v0, -28
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $t0, $fp, $v0
  sw $v1, 0($t0)
  li $v0, 30
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 2
  sll $v0, $v0, 2
  addi $v0, $v0, -28
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $t0, $fp, $v0
  sw $v1, 0($t0)
  li $v0, 40
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 3
  sll $v0, $v0, 2
  addi $v0, $v0, -28
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $t0, $fp, $v0
  sw $v1, 0($t0)
  li $v0, 50
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
  sll $v0, $v0, 2
  addi $v0, $v0, -28
  add $t0, $fp, $v0
  lw $v0, 0($t0)
  nop
  lw $ra, 32($sp)
  nop
  lw $fp, 28($sp)
  nop
  addiu $sp, $sp, 36
  jr $ra
  nop

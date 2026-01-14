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
  addiu $sp, $sp, -56
  sw $ra, 52($sp)
  sw $fp, 48($sp)
  addiu $fp, $sp, 56
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 0
  sll $v0, $v0, 2
  addi $v0, $v0, -24
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $t0, $fp, $v0
  sw $v1, 0($t0)
  li $v0, 2
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 1
  sll $v0, $v0, 2
  addi $v0, $v0, -24
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $t0, $fp, $v0
  sw $v1, 0($t0)
  li $v0, 0
  sll $v0, $v0, 2
  addi $v0, $v0, -24
  add $t0, $fp, $v0
  lw $v0, 0($t0)
  nop
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
  addi $t3, $t3, -48
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 1
  sll $v0, $v0, 2
  addi $v0, $v0, -24
  add $t0, $fp, $v0
  lw $v0, 0($t0)
  nop
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
  addi $t3, $t3, -48
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 0
  add $t0, $v0, $zero
  li $v0, 1
  add $t1, $v0, $zero
  li $t2, 3
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -48
  add $t3, $fp, $t3
  lw $v0, 0($t3)
  nop
  lw $ra, 52($sp)
  nop
  lw $fp, 48($sp)
  nop
  addiu $sp, $sp, 56
  jr $ra
  nop

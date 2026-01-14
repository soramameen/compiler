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
  addiu $sp, $sp, -136
  sw $ra, 132($sp)
  sw $fp, 128($sp)
  addiu $fp, $sp, 136
  li $v0, 0
  add $t0, $v0, $zero
  li $v0, 0
  add $t1, $v0, $zero
  li $t2, 3
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -92
  add $t3, $fp, $t3
  lw $v0, 0($t3)
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
  addi $t3, $t3, -56
  add $t3, $fp, $t3
  lw $v0, 0($t3)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  mult $v0, $v1
  mflo $v0
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
  addi $t3, $t3, -128
  add $t3, $fp, $t3
  lw $v0, 0($t3)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
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
  addi $t3, $t3, -128
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  lw $ra, 132($sp)
  nop
  lw $fp, 128($sp)
  nop
  addiu $sp, $sp, 136
  jr $ra
  nop

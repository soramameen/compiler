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
  addiu $sp, $sp, -64
  sw $ra, 60($sp)
  sw $fp, 56($sp)
  addiu $fp, $sp, 64
  li $v0, 100
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 0
  add $t0, $v0, $zero
  li $v0, 0
  add $t1, $v0, $zero
  li $t2, 4
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -56
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 101
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 0
  add $t0, $v0, $zero
  li $v0, 1
  add $t1, $v0, $zero
  li $t2, 4
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -56
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 102
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 0
  add $t0, $v0, $zero
  li $v0, 2
  add $t1, $v0, $zero
  li $t2, 4
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -56
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 103
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 0
  add $t0, $v0, $zero
  li $v0, 3
  add $t1, $v0, $zero
  li $t2, 4
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -56
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 104
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 1
  add $t0, $v0, $zero
  li $v0, 0
  add $t1, $v0, $zero
  li $t2, 4
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -56
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 105
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 1
  add $t0, $v0, $zero
  li $v0, 1
  add $t1, $v0, $zero
  li $t2, 4
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -56
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 106
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 1
  add $t0, $v0, $zero
  li $v0, 2
  add $t1, $v0, $zero
  li $t2, 4
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -56
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 107
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 1
  add $t0, $v0, $zero
  li $v0, 3
  add $t1, $v0, $zero
  li $t2, 4
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -56
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 1
  add $t0, $v0, $zero
  li $v0, 1
  add $t1, $v0, $zero
  li $t2, 4
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -56
  add $t3, $fp, $t3
  lw $v0, 0($t3)
  nop
  lw $ra, 60($sp)
  nop
  lw $fp, 56($sp)
  nop
  addiu $sp, $sp, 64
  jr $ra
  nop

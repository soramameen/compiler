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
  addiu $sp, $sp, -76
  sw $ra, 72($sp)
  sw $fp, 68($sp)
  addiu $fp, $sp, 76
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 0
  add $t0, $v0, $zero
  li $v0, 0
  add $t1, $v0, $zero
  li $t2, 2
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -24
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 2
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 0
  add $t0, $v0, $zero
  li $v0, 1
  add $t1, $v0, $zero
  li $t2, 2
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -24
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 3
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 1
  add $t0, $v0, $zero
  li $v0, 0
  add $t1, $v0, $zero
  li $t2, 2
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -24
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 4
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 1
  add $t0, $v0, $zero
  li $v0, 1
  add $t1, $v0, $zero
  li $t2, 2
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -24
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 5
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 0
  add $t0, $v0, $zero
  li $v0, 0
  add $t1, $v0, $zero
  li $t2, 2
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -40
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 6
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 0
  add $t0, $v0, $zero
  li $v0, 1
  add $t1, $v0, $zero
  li $t2, 2
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -40
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 7
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 1
  add $t0, $v0, $zero
  li $v0, 0
  add $t1, $v0, $zero
  li $t2, 2
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -40
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 8
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  li $v0, 1
  add $t0, $v0, $zero
  li $v0, 1
  add $t1, $v0, $zero
  li $t2, 2
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -40
  add $t3, $fp, $t3
  lw $v0, 0($sp)
  addi $sp, $sp, 4
  sw $v0, 0($t3)
  li $v0, 0
  sw $v0, -60($fp)
$WHILE_LOOP_START_0:
  li $v0, 2
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -60($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $v0, $v0, $v1
  beq $v0, $zero, $WHILE_LOOP_END_0
  nop
  li $v0, 0
  sw $v0, -64($fp)
$WHILE_LOOP_START_1:
  li $v0, 2
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -64($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $v0, $v0, $v1
  beq $v0, $zero, $WHILE_LOOP_END_1
  nop
  li $v0, 0
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -60($fp)
  nop
  add $t0, $v0, $zero
  lw $v0, -64($fp)
  nop
  add $t1, $v0, $zero
  li $t2, 2
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
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -64($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -64($fp)
  j $WHILE_LOOP_START_1
  nop
$WHILE_LOOP_END_1:
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -60($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -60($fp)
  j $WHILE_LOOP_START_0
  nop
$WHILE_LOOP_END_0:
  li $v0, 0
  sw $v0, -60($fp)
$WHILE_LOOP_START_2:
  li $v0, 2
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -60($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $v0, $v0, $v1
  beq $v0, $zero, $WHILE_LOOP_END_2
  nop
  li $v0, 0
  sw $v0, -64($fp)
$WHILE_LOOP_START_3:
  li $v0, 2
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -64($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $v0, $v0, $v1
  beq $v0, $zero, $WHILE_LOOP_END_3
  nop
  li $v0, 0
  sw $v0, -68($fp)
$WHILE_LOOP_START_4:
  li $v0, 2
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -68($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
   slt $v0, $v0, $v1
  beq $v0, $zero, $WHILE_LOOP_END_4
  nop
  lw $v0, -68($fp)
  nop
  add $t0, $v0, $zero
  lw $v0, -64($fp)
  nop
  add $t1, $v0, $zero
  li $t2, 2
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -40
  add $t3, $fp, $t3
  lw $v0, 0($t3)
  nop
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -60($fp)
  nop
  add $t0, $v0, $zero
  lw $v0, -68($fp)
  nop
  add $t1, $v0, $zero
  li $t2, 2
  mult $t0, $t2
  mflo $t3
  add $t3, $t3, $t1
  sll $t3, $t3, 2
  addi $t3, $t3, -24
  add $t3, $fp, $t3
  lw $v0, 0($t3)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  mult $v0, $v1
  mflo $v0
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -60($fp)
  nop
  add $t0, $v0, $zero
  lw $v0, -64($fp)
  nop
  add $t1, $v0, $zero
  li $t2, 2
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
  add $v0, $v0, $v1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -60($fp)
  nop
  add $t0, $v0, $zero
  lw $v0, -64($fp)
  nop
  add $t1, $v0, $zero
  li $t2, 2
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
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -68($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -68($fp)
  j $WHILE_LOOP_START_4
  nop
$WHILE_LOOP_END_4:
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -64($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -64($fp)
  j $WHILE_LOOP_START_3
  nop
$WHILE_LOOP_END_3:
  li $v0, 1
  sw $v0, -4($sp)
  addi $sp, $sp, -4
  lw $v0, -60($fp)
  nop
  lw $v1, 0($sp)
  addi $sp, $sp, 4
  add $v0, $v0, $v1
  sw $v0, -60($fp)
  j $WHILE_LOOP_START_2
  nop
$WHILE_LOOP_END_2:
  lw $ra, 72($sp)
  nop
  lw $fp, 68($sp)
  nop
  addiu $sp, $sp, 76
  jr $ra
  nop

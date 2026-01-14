INITIAL_GP = 0x10008000
INITIAL_SP = 0x7ffffffc
stop_service = 99

.text
init:
  la $gp, INITIAL_GP
  la $sp, INITIAL_SP
  jal main
  nop
  add $t0, $v0, $zero
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
  li $v0, 5
  li $v0, 10
  lw $ra, 32($sp)
  nop
  lw $fp, 28($sp)
  nop
  addiu $sp, $sp, 36
  jr $ra
  nop

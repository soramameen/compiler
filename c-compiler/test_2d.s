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
  addiu $sp, $sp, -64
  sw $ra, 60($sp)
  sw $fp, 56($sp)
  addiu $fp, $sp, 64
  li $v0, 3
  li $v0, 20
  lw $ra, 60($sp)
  nop
  lw $fp, 56($sp)
  nop
  addiu $sp, $sp, 64
  jr $ra
  nop

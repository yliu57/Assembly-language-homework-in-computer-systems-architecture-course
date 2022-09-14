#############################################################
# NOTE: this is the provided TEMPLATE as your required 
#		starting point of HW2 MIPS programming part.
#		This is the only file you should change and submit.
#
# CS465-DL1 S2021
# HW2  
#############################################################
#############################################################
# TEAM INFO
# NAME Yuxi Liu
# G# 01223126
# NAME 2
# G# 2
#############################################################

#############################################################
# Data segment
#############################################################

.data
	NEWLINE: .asciiz "\n"


#############################################################
# Code segment
#############################################################

.text

#############################################################
# atoi
#############################################################
#############################################################
# DESCRIPTION  
# 
# Extract every two bits from the start address and change to 
# one bit of hexadecimal value for eight times
# then get the unsigned 32-bit integer.
#############################################################
		
.globl atoi
atoi:	
	# start to change string to integer
	lw $t0, 0($a0)
	lw $t1, 4($a0)
	
Begin1:  
	beq $t0,0x0,Begin2
	li $t2, 0xFF    	# Extract every two bits
	and $t3, $t0, $t2
	srl $t0, $t0, 8
	j Loopt3
	
Begin2: 
	beq $t1,0x0,Begin3
	li $t2, 0xFF
	and $t3, $t1, $t2
	srl $t1, $t1, 8
	j Loopt3
Loopt3: # Generate the unsigned 32-bit integer one by one
	beq $t3, 0x30, exit0	
	beq $t3, 0x31, exit1
	beq $t3, 0x32, exit2
	beq $t3, 0x33, exit3
	beq $t3, 0x34, exit4
	beq $t3, 0x35, exit5
	beq $t3, 0x36, exit6
	beq $t3, 0x37, exit7
	beq $t3, 0x38, exit8
	beq $t3, 0x39, exit9
	beq $t3, 0x41, exitA
	beq $t3, 0x42, exitB
	beq $t3, 0x43, exitC
	beq $t3, 0x44, exitD
	beq $t3, 0x45, exitE
	beq $t3, 0x46, exitF
	
exit0:
	li $t5, 0x0
	j Next
exit1:
	li $t5, 0x1
	j Next
exit2:
	li $t5, 0x2
	j Next
exit3:
	li $t5, 0x3
	j Next
exit4:
	li $t5, 0x4
	j Next
exit5:
	li $t5, 0x5
	j Next
exit6:
	li $t5, 0x6
	j Next
exit7:
	li $t5, 0x7
	j Next
exit8:
	li $t5, 0x8
	j Next
exit9:
	li $t5, 0x9
	j Next
exitA:
	li $t5, 0xA
	j Next
exitB:
	li $t5, 0xB
	j Next
exitC:
	li $t5, 0xC
	j Next
exitD:
	li $t5, 0xD
	j Next
exitE:
	li $t5, 0xE
	j Next
exitF:
	li $t5, 0xF
	j Next

Next:
	sll $t6, $t6, 4
	or $t6, $t6, $t5
	j Begin1
	
Begin3:
	add $v0, $t6, $0
	
	#log status
	addi $sp,$sp,-12 
	sw $v0, 8($sp) 	# push $v0 onto stack
	sw $ra, 4($sp)	# push $ra onto stack
	sw $a0, 0($sp)	# push $a0 onto stack
	
	la $a0, NEWLINE	# Print a new line for log
	li $v0, 4
	syscall	
	
	addi $a0, $0, 1	# assign $a0 stage number
	jal log
	
	lw $v0, 8($sp)	# restore $v0
	lw $ra, 4($sp)	# restore $ra
	lw $a0, 0($sp)	# restore $a0
	addi $sp,$sp,12	# pop from stack
	
	jr $ra


#############################################################
# get_insn_code
#############################################################
#############################################################
# DESCRIPTION  
#
# Firstly I extract the opcode to distinguish the instruction
# But some MIPS have the same opcode 0x00, I need to 
# distinguish them by funct code
# Secondly I extract the funct code and distinguish 
# the MIPS R-format instruction
#############################################################

	
.globl get_insn_code
get_insn_code:
	
	# start to extract opcode bits from 31 to 26
	li $t1, 0x0
	addi $t2, $0, 31
	addi $t3, $0, 26
	add  $t4, $a0, $0
	
	# register t5 store the value of the span of the final value
	sub $t5, $t2, $t3
	addi $t5, $t5, 1     
	
	li $t6, 0
	
	# CREATE ONE for the final value: 1111111
START_OPCODE:
	bne $t6, $t5, GETONE_OPCODE
	j FINISH_OPCODE
	
GETONE_OPCODE:
	sll $t1, $t1, 1
	or $t1, $t1, 1
	addi $t6, $t6, 1
	j START_OPCODE

FINISH_OPCODE:
	sllv $t1, $t1, $t3
	and $t1, $t1, $t4
	srlv $t1, $t1, $t3
	add $v0, $t1, $0	# v0 store the opcode
	
	# Now we get the opcode and next we need to find the instruction code
	beq $v0, 0x00, exitArithmetic
	beq $v0, 0x23, exitLw
	beq $v0, 0x05, exitBne
	beq $v0, 0x03, exitJal
	beq $v0, 0x08, exitAddi
	beq $v0, 0x2b, exitSw
	beq $v0, 0x02, exitJ
	j exitInvalid
	
exitLw:
	li $v0, 0x2
	j get_insn_code_end
exitBne:
	li $v0, 0x3
	j get_insn_code_end
exitJal:
	li $v0, 0x4
	j get_insn_code_end
exitAddi:
	li $v0, 0x5
	j get_insn_code_end
exitSw:
	li $v0, 0x7
	j get_insn_code_end
exitJ:
	li $v0, 0x8
	j get_insn_code_end
exitArithmetic:
	# add,sll,slt,jr all have same opcode 0x00, 
	# so we need to extract funct bits from 5 to 0
	li $t1, 0x0
	addi $t2, $0, 5
	addi $t3, $0, 0
	add  $t4, $a0, $0
	
	# register t5 store the value of the span of the final value
	sub $t5, $t2, $t3
	addi $t5, $t5, 1     
	
	li $t6, 0
	
	# CREATE ONE for the final value: 1111111
START_FUNCT_BITS:
	bne $t6, $t5, GETONE_FUNCT_BITS
	j FINISH_FUNCT_BITS
	
GETONE_FUNCT_BITS:
	sll $t1, $t1, 1
	or $t1, $t1, 1
	addi $t6, $t6, 1
	j START_FUNCT_BITS

FINISH_FUNCT_BITS:
	sllv $t1, $t1, $t3
	and $t1, $t1, $t4
	srlv $t1, $t1, $t3
	add $v0, $t1, $0	# v0 store the funct bits
	
	# Now we get the funct bits
	beq $v0, 0x20, exitAdd
	beq $v0, 0x00, exitSll
	beq $v0, 0x2a, exitSlt
	beq $v0, 0x08, exitJr
	j exitInvalid
	
exitAdd:
	li $v0, 0x0
	j get_insn_code_end
exitSll:
	li $v0, 0x1
	j get_insn_code_end
exitSlt:
	li $v0, 0x6
	j get_insn_code_end
exitJr:
	li $v0, 0x9
	j get_insn_code_end
	
exitInvalid:
	li $v0, 0x21 # 33 = 0x21
	j get_insn_code_end

get_insn_code_end:
	#log status
	addi $sp,$sp,-12 
	sw $v0, 8($sp) 	# push $v0 onto stack
	sw $ra, 4($sp)	# push $ra onto stack
	sw $a0, 0($sp)	# push $a0 onto stack
	
	addi $a0, $0, 2	# assign $a0 stage number
	jal log
	
	lw $v0, 8($sp)	# restore $v0
	lw $ra, 4($sp)	# restore $ra
	lw $a0, 0($sp)	# restore $a0
	addi $sp,$sp,12	# pop from stack
	
	jr $ra


#############################################################
# get_dest_reg
#############################################################
#############################################################
# DESCRIPTION  
#
# Firstly I copy my get_insn_code code without "jal log".
# Then I get the unique instruction code.
# I summarized and analyzed ten MIPS destination registers 
# and divided them into six situations: R-format, I-format, 
# J-format, Jr, Invalid, and Addi. Finally, take different 
# actions according to each situation. Specially, the helper 
# functions get_bits_of_code need to be called for R-format 
# and Addi situations. Extract different digits according to 
# the different locations of destination register. Finally, 
# call log to complete the information printing.
#############################################################
	
.globl get_dest_reg
get_dest_reg:

	# get_insn_code
	
	# start to extract opcode bits from 31 to 26
	li $t1, 0x0
	addi $t2, $0, 31
	addi $t3, $0, 26
	add  $t4, $a0, $0
	
	# register t5 store the value of the span of the final value
	sub $t5, $t2, $t3
	addi $t5, $t5, 1     
	
	li $t6, 0
	
	# CREATE ONE for the final value: 1111111
START_OPCODE_get_dest_reg:
	bne $t6, $t5, GETONE_OPCODE_get_dest_reg
	j FINISH_OPCODE_get_dest_reg
	
GETONE_OPCODE_get_dest_reg:
	sll $t1, $t1, 1
	or $t1, $t1, 1
	addi $t6, $t6, 1
	j START_OPCODE_get_dest_reg

FINISH_OPCODE_get_dest_reg:
	sllv $t1, $t1, $t3
	and $t1, $t1, $t4
	srlv $t1, $t1, $t3
	add $v0, $t1, $0	# v0 store the opcode
	
	# Now we get the opcode and next we need to find the instruction code
	beq $v0, 0x00, exitArithmetic_get_dest_reg
	beq $v0, 0x23, exitLw_get_dest_reg
	beq $v0, 0x05, exitBne_get_dest_reg
	beq $v0, 0x03, exitJal_get_dest_reg
	beq $v0, 0x08, exitAddi_get_dest_reg
	beq $v0, 0x2b, exitSw_get_dest_reg
	beq $v0, 0x02, exitJ_get_dest_reg
	j exitInvalid_get_dest_reg
	
exitLw_get_dest_reg:
	li $v0, 0x2
	j New_Start_get_dest_reg

exitBne_get_dest_reg:
	li $v0, 0x3
	j New_Start_get_dest_reg

exitJal_get_dest_reg:
	li $v0, 0x4
	j New_Start_get_dest_reg

exitAddi_get_dest_reg:
	li $v0, 0x5
	j New_Start_get_dest_reg

exitSw_get_dest_reg:
	li $v0, 0x7
	j New_Start_get_dest_reg

exitJ_get_dest_reg:
	li $v0, 0x8
	j New_Start_get_dest_reg

exitArithmetic_get_dest_reg:
	# add,sll,slt,jr all have same opcode 0x00, 
	# so we need to extract funct bits from 5 to 0
	li $t1, 0x0
	addi $t2, $0, 5
	addi $t3, $0, 0
	add  $t4, $a0, $0
	
	# register t5 store the value of the span of the final value
	sub $t5, $t2, $t3
	addi $t5, $t5, 1     
	
	li $t6, 0
	
	# CREATE ONE for the final value: 1111111
START_FUNCT_BITS_get_dest_reg:
	bne $t6, $t5, GETONE_FUNCT_BITS_get_dest_reg
	j FINISH_FUNCT_BITS_get_dest_reg
	
GETONE_FUNCT_BITS_get_dest_reg:
	sll $t1, $t1, 1
	or $t1, $t1, 1
	addi $t6, $t6, 1
	j START_FUNCT_BITS_get_dest_reg

FINISH_FUNCT_BITS_get_dest_reg:
	sllv $t1, $t1, $t3
	and $t1, $t1, $t4
	srlv $t1, $t1, $t3
	add $v0, $t1, $0	# v0 store the funct bits
	
	# Now we get the funct bits
	beq $v0, 0x20, exitAdd_get_dest_reg
	beq $v0, 0x00, exitSll_get_dest_reg
	beq $v0, 0x2a, exitSlt_get_dest_reg
	beq $v0, 0x08, exitJr_get_dest_reg
	j exitInvalid_get_dest_reg
	
exitAdd_get_dest_reg:
	li $v0, 0x0
	j New_Start_get_dest_reg

exitSll_get_dest_reg:
	li $v0, 0x1
	j New_Start_get_dest_reg

exitSlt_get_dest_reg:
	li $v0, 0x6
	j New_Start_get_dest_reg

exitJr_get_dest_reg:
	li $v0, 0x9
	j New_Start_get_dest_reg

exitInvalid_get_dest_reg:
	li $v0, 0x21 # 33 = 0x21
	j New_Start_get_dest_reg
	
New_Start_get_dest_reg:
	add $t1, $v0, $0 # store the insn_code in $t1
	beq $t1, 0x0, exitR_dest
	beq $t1, 0x1, exitR_dest
	beq $t1, 0x2, exitLw_dest
	beq $t1, 0x3, exitI_dest
	beq $t1, 0x4, exitJal_dest
	beq $t1, 0x5, exitAddi_dest
	beq $t1, 0x6, exitR_dest
	beq $t1, 0x7, exitI_dest
	beq $t1, 0x8, exitJ_dest
	beq $t1, 0x9, exitJr_dest
	beq $t1, 0x21, exitInvalid_dest

exitR_dest:
	li $a1, 15
	li $a2, 11
	add $sp,$sp,-4
	sw $ra,0($sp)
	jal get_bits_of_code  
	
	lw $ra,0($sp)
	add $sp,$sp,4
	j get_dest_reg_end
exitLw_dest: # Transfer(lw)
	li $a1, 20
	li $a2, 16
	add $sp,$sp,-4
	sw $ra,0($sp)
	jal get_bits_of_code  
	
	lw $ra,0($sp)
	add $sp,$sp,4
	j get_dest_reg_end
exitJal_dest: # jal
	li $v0, 31   # $31 is return address register ($ra)	
	j get_dest_reg_end
exitI_dest: # Transfer(sw) and Branch(bne)
exitJ_dest: # j
exitJr_dest: # jr
	li $v0, 32	
	j get_dest_reg_end
exitInvalid_dest:
	li $v0, 33
	j get_dest_reg_end
exitAddi_dest:
	li $a1, 20
	li $a2, 16
	add $sp,$sp,-4
	sw $ra,0($sp)
	jal get_bits_of_code  
	
	lw $ra,0($sp)
	add $sp,$sp,4
	j get_dest_reg_end
get_dest_reg_end:
	#log status
	addi $sp,$sp,-12 
	sw $v0, 8($sp) 	# push $v0 onto stack
	sw $ra, 4($sp)	# push $ra onto stack
	sw $a0, 0($sp)	# push $a0 onto stack
	
	addi $a0, $0, 3	# assign $a0 stage number
	jal log
	
	lw $v0, 8($sp)	# restore $v0
	lw $ra, 4($sp)	# restore $ra
	lw $a0, 0($sp)	# restore $a0
	addi $sp,$sp,12	# pop from stack
	
	jr $ra

#############################################################
# get_src_regs
#############################################################
#############################################################
# DESCRIPTION  
#
# Firstly I copy my get_insn_code code without "jal log". 
# Then I get the unique instruction code. I summarized and 
# analyzed ten MIPS source registers and divided them into 
# three situations: Zerosrc, Onesrc, Twosrc. Finally, take 
# different actions according to each situation. Specially, 
# the helper functions get_bits_of_code need to be called 
# for all three situations. Extract different digits according 
# to the different locations of source registers. Finally, 
# call log to complete the information printing.
#############################################################

.globl get_src_regs
get_src_regs:
	
	# get_insn_code
	
	# start to extract opcode bits from 31 to 26
	li $t1, 0x0
	addi $t2, $0, 31
	addi $t3, $0, 26
	add  $t4, $a0, $0
	
	# register t5 store the value of the span of the final value
	sub $t5, $t2, $t3
	addi $t5, $t5, 1     
	
	li $t6, 0
	
	# CREATE ONE for the final value: 1111111
START_OPCODE_get_src_regs:
	bne $t6, $t5, GETONE_OPCODE_get_src_regs
	j FINISH_OPCODE_get_src_regs
	
GETONE_OPCODE_get_src_regs:
	sll $t1, $t1, 1
	or $t1, $t1, 1
	addi $t6, $t6, 1
	j START_OPCODE_get_src_regs

FINISH_OPCODE_get_src_regs:
	sllv $t1, $t1, $t3
	and $t1, $t1, $t4
	srlv $t1, $t1, $t3
	add $v0, $t1, $0	# v0 store the opcode
	
	# Now we get the opcode and next we need to find the instruction code
	beq $v0, 0x00, exitArithmetic_get_src_regs
	beq $v0, 0x23, exitLw_get_src_regs
	beq $v0, 0x05, exitBne_get_src_regs
	beq $v0, 0x03, exitJal_get_src_regs
	beq $v0, 0x08, exitAddi_get_src_regs
	beq $v0, 0x2b, exitSw_get_src_regs
	beq $v0, 0x02, exitJ_get_src_regs
	j exitInvalid_get_src_regs
	
exitLw_get_src_regs:
	li $v0, 0x2
	j New_Start_get_src_regs

exitBne_get_src_regs:
	li $v0, 0x3
	j New_Start_get_src_regs

exitJal_get_src_regs:
	li $v0, 0x4
	j New_Start_get_src_regs

exitAddi_get_src_regs:
	li $v0, 0x5
	j New_Start_get_src_regs

exitSw_get_src_regs:
	li $v0, 0x7
	j New_Start_get_src_regs

exitJ_get_src_regs:
	li $v0, 0x8
	j New_Start_get_src_regs

exitArithmetic_get_src_regs:
	# add,sll,slt,jr all have same opcode 0x00, 
	# so we need to extract funct bits from 5 to 0
	li $t1, 0x0
	addi $t2, $0, 5
	addi $t3, $0, 0
	add  $t4, $a0, $0
	
	# register t5 store the value of the span of the final value
	sub $t5, $t2, $t3
	addi $t5, $t5, 1     
	
	li $t6, 0
	
	# CREATE ONE for the final value: 1111111
START_FUNCT_BITS_get_src_regs:
	bne $t6, $t5, GETONE_FUNCT_BITS_get_src_regs
	j FINISH_FUNCT_BITS_get_src_regs
	
GETONE_FUNCT_BITS_get_src_regs:
	sll $t1, $t1, 1
	or $t1, $t1, 1
	addi $t6, $t6, 1
	j START_FUNCT_BITS_get_src_regs

FINISH_FUNCT_BITS_get_src_regs:
	sllv $t1, $t1, $t3
	and $t1, $t1, $t4
	srlv $t1, $t1, $t3
	add $v0, $t1, $0	# v0 store the funct bits
	
	# Now we get the funct bits
	beq $v0, 0x20, exitAdd_get_src_regs
	beq $v0, 0x00, exitSll_get_src_regs
	beq $v0, 0x2a, exitSlt_get_src_regs
	beq $v0, 0x08, exitJr_get_src_regs
	j exitInvalid_get_src_regs
	
exitAdd_get_src_regs:
	li $v0, 0x0
	j New_Start_get_src_regs

exitSll_get_src_regs:
	li $v0, 0x1
	j New_Start_get_src_regs

exitSlt_get_src_regs:
	li $v0, 0x6
	j New_Start_get_src_regs

exitJr_get_src_regs:
	li $v0, 0x9
	j New_Start_get_src_regs

exitInvalid_get_src_regs:
	li $v0, 0x21 # 33 = 0x21
	j New_Start_get_src_regs
	
New_Start_get_src_regs:
	add $t1, $v0, $0 # store the insn_code in $t1
	beq $t1, 0x0, exit_Twosrc
	beq $t1, 0x1, exit_SllOnesrc
	beq $t1, 0x2, exit_Onesrc
	beq $t1, 0x3, exit_Twosrc
	beq $t1, 0x4, exit_Zerosrc
	beq $t1, 0x5, exit_Onesrc
	beq $t1, 0x6, exit_Twosrc
	beq $t1, 0x7, exit_Twosrc
	beq $t1, 0x8, exit_Zerosrc
	beq $t1, 0x9, exit_Jrsrc
	beq $t1, 0x21, exitInvalid_src

exit_Jrsrc:
	li $v0, 31
	li $v1, 32
	j get_src_regs_end
exit_Zerosrc:
	li $v0, 32
	j get_src_regs_end
exit_SllOnesrc:
	li $a1, 20
	li $a2, 16
	add $sp,$sp,-4
	sw $ra,0($sp)
	jal get_bits_of_code  
	
	lw $ra,0($sp)
	add $sp,$sp,4
	li $v1, 32
	j get_src_regs_end
exit_Onesrc:
	li $a1, 25
	li $a2, 21
	add $sp,$sp,-4
	sw $ra,0($sp)
	jal get_bits_of_code  
	
	lw $ra,0($sp)
	add $sp,$sp,4
	li $v1, 32
	j get_src_regs_end
exit_Twosrc:
	# extract the second source register
	li $a1, 20
	li $a2, 16
	add $sp,$sp,-4
	sw $ra,0($sp)
	jal get_bits_of_code  
	
	lw $ra,0($sp)
	add $sp,$sp,4
	# move the value of the second source
	# register to $v1
	add $v1, $v0, 0 
	
	# extract the first source register
	li $a1, 25
	li $a2, 21
	add $sp,$sp,-4
	sw $ra,0($sp)
	jal get_bits_of_code  
	
	lw $ra,0($sp)
	add $sp,$sp,4
	j get_src_regs_end
exitInvalid_src:
	li $v0, 33
	j get_src_regs_end
get_src_regs_end:
	#log status
	addi $sp,$sp,-12 
	sw $v0, 8($sp) 	# push $v0 onto stack
	sw $ra, 4($sp)	# push $ra onto stack
	sw $a0, 0($sp)	# push $a0 onto stack
	
	addi $a0, $0, 4	# assign $a0 stage number
	jal log
	
	lw $v0, 8($sp)	# restore $v0
	lw $ra, 4($sp)	# restore $ra
	lw $a0, 0($sp)	# restore $a0
	addi $sp,$sp,12	# pop from stack
	
	jr $ra


#############################################################
# optional: other helper functions
#############################################################
				
.globl get_bits_of_code  
get_bits_of_code:
	# $a0 is unsighed int 32-bit instruction
	# $a1 store the HIGHBITINDEX
	# $a2 store the LOWBITINDEX
	# start to extract bits from HIGHBITINDEX to LOWBITINDEX
	li $t1, 0x0
	add $t2, $a1, 0
	add $t3, $a2, 0
	add $t4, $a0, 0
	
	# register t5 store the value of the span of the final value
	sub $t5, $t2, $t3
	addi $t5, $t5, 1     
	
	li $t6, 0
	
	# CREATE ONE for the final value: 1111111
START_OPCODE_bits_of_code:
	bne $t6, $t5, GETONE_OPCODE_bits_of_code
	j FINISH_OPCODE_bits_of_code
	
GETONE_OPCODE_bits_of_code:
	sll $t1, $t1, 1
	or $t1, $t1, 1
	addi $t6, $t6, 1
	j START_OPCODE_bits_of_code

FINISH_OPCODE_bits_of_code:
	sllv $t1, $t1, $t3
	and $t1, $t1, $t4
	srlv $t1, $t1, $t3
	add $v0, $t1, $0	# v0 store the extracted bits
	
	jr $ra
	
	
	
	

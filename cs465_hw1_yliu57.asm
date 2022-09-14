#############################################################
# NOTE: this is the provided TEMPLATE as your required 
#	starting point of HW1 MIPS programming part.
#
# CS465 S2021 HW1  
#############################################################
#############################################################
# PUT YOUR TEAM INFO HERE
# NAME YUXI LIU
# G# 01223126
# NAME Zengxin Li
# G# 01241116
#############################################################

#############################################################
# DESCRIPTION OF ALGORITHMS 
#
# PUT A BRIEF ALGORITHM DESCRIPTION HERE
# 1. hexdecimal string to integer value
# 2. extract n bits between high and low indexes (inclusively)
#############################################################

#############################################################
# Data segment
# 
# Feel free to add more data items
#############################################################
.data
	INPUTMSG: .asciiz "Enter a hexadecimal number: "
	INPUTHIGHMSG: .asciiz "Specify the high bit index to extract (0-LSB, 31-MSB): "
	INPUTLOWMSG: .asciiz "Specify the low bit index to extract (0-LSB, 31-MSB, low<=high): "
	OUTPUTMSG: .asciiz "Input: "
	BITSMSG: .asciiz "Extracted bits: "
	ERROR: .asciiz "Error: Input has invalid digits!"
	INDEXERROR: .asciiz "Error: Input has incorrect index(es)!"
	EQUALS: .asciiz " = "
	NEWLINE: .asciiz "\n"
	ZERO: .asciiz "0"
	TEN: .asciiz "A"
	
	.align 4
	INPUT: .space 8
	OUTPUT: .space 8
	HIGHBITINDEX: .space 8
	LOWBITINDEX: .space 8
	EXTRACTEDBITS: .space 8
	
#############################################################
# Code segment
#############################################################
.text

#############################################################
# Provided entry of program execution
# DO NOT MODIFY this part
#############################################################
		
main:
	li $v0, 4
	la $a0, INPUTMSG
	syscall	# print out MSG asking for a hexadecimal
	
	li $v0, 8
	la $a0, INPUT
	li $a1, 9 # one more than the number of allowed characters, '\0' need one more space
	syscall # read in one string of 8 chars and store in INPUT

#############################################################
# END of provided code that you CANNOT modify 
#############################################################
				
	#li $v0, 4
	#la $a0, INPUT
	#syscall # print out string that read in 
	#li $v0, 4
	#la $a0, NEWLINE
	#syscall	


		
##############################################################
# Add your code here to calculate the numeric value from INPUT 
##############################################################
	
	la $a0, INPUT
	lw $t0, ($a0)
	lw $t1, 4($a0)
	
Begin1:  
	beq $t0,0x0,Begin2
	li $t2, 0xFF
	and $t3, $t0, $t2
	srl $t0, $t0, 8
	j Loopt3
	
Begin2: 
	beq $t1,0x0,Begin3
	li $t2, 0xFF
	and $t3, $t1, $t2
	srl $t1, $t1, 8
	j Loopt3
Loopt3:
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
	j exitError
	
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
exitError:
	li $v0, 4
	la $a0, NEWLINE
	syscall
	
	li $v0, 4
	la $a0, ERROR
	syscall
	j exit

Next:
	sll $t6, $t6, 4
	or $t6, $t6, $t5
	j Begin1
	
Begin3:
	sw $t6, OUTPUT
	

report_value:
#############################################################
# Add your code here to print the numeric value
# Hint: syscall 34: print integer as hexadecimal
#	syscall 36: print integer as unsigned
#############################################################
	li $v0, 4
	la $a0, NEWLINE
	syscall
	
	li $v0, 4
	la $a0, OUTPUTMSG
	syscall	
	
	li $v0, 34
	lw $a0, OUTPUT
	syscall	
	
	li $v0, 4
	la $a0, EQUALS
	syscall
	
	li $v0, 36
	lw $a0, OUTPUT
	syscall	


#############################################################
# Add your code here to get two integers: high and low
#############################################################
	li $v0, 4
	la $a0, NEWLINE
	syscall
	
	li $v0, 4
	la $a0, INPUTHIGHMSG
	syscall	# print out MSG asking for high index
	
	li $v0, 5
	syscall
	
	# check v0 from 0 to 31 and store the value of v0
	sw $v0, HIGHBITINDEX
	slti $v1, $v0, 32
	beq $v1, 0, exitError1
	slti $v1, $v0, 0
	beq $v1, 1, exitError1
	
	li $v0, 4
	la $a0, INPUTLOWMSG
	syscall	# print out MSG asking for low index
	
	li $v0, 5
	syscall
	
	# store the value of v0
	# check v0 from 0 to 31 and smaller than HIGHBITINDEX 
	sw $v0, LOWBITINDEX
	slti $v1, $v0, 32
	beq $v1, 0, exitError1
	slti $v1, $v0, 0
	beq $v1, 1, exitError1
	
	# if HIGHBITINDEX is smaller than LOWBITINDEX, report error
	lw $t7, HIGHBITINDEX
	slt $v1, $t7, $t0
	beq $v1, 1, exitError1

		
#############################################################
# Add your code here to extract bits and print extracted value
#############################################################

	li $t1, 0x0
	lw $t2, HIGHBITINDEX
	lw $t3, LOWBITINDEX
	lw $t4, OUTPUT
	
	# register t5 store the value of the span of the final value
	sub $t5, $t2, $t3
	addi $t5, $t5, 1     
	
	li $t6, 0
	
	# CREATE ONE for the final value: 1111111
START:
	bne $t6, $t5, GETONE
	j FINISH
	
GETONE:
	sll $t1, $t1, 1
	or $t1, $t1, 1
	addi $t6, $t6, 1
	j START

FINISH:
	sllv $t1, $t1, $t3
	and $t1, $t1, $t4
	srlv $t1, $t1, $t3
	sw $t1, EXTRACTEDBITS
	
	li $v0, 4
	la $a0, BITSMSG
	syscall
	
	li $v0, 34
	lw $a0, EXTRACTEDBITS
	syscall	
	
	li $v0, 4
	la $a0, EQUALS
	syscall
	
	li $v0, 36
	lw $a0, EXTRACTEDBITS
	syscall	

#############################################################
# exitError1 Code
#############################################################

	j exit
	
exitError1:	
	li $v0, 4
	la $a0, INDEXERROR
	syscall
	
#############################################################
# Optional exit 
#############################################################
exit:
	li $v0, 10
	syscall

# Example input	
# H: 0x 0   1    2    3    4    5    6    A
# B: 0000 0001 0010 0011 0100 0101 0110 1010
#    31   27   23   19   15   11   7    3  0 (index)

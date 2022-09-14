################################################################
#
#  Column-major order traversal of 16 x 8 array of words.
#  Pete Sanderson
#  31 March 2007
#  Edited by Yutao Zhong, April 2021
#
#  To easily observe the column-oriented order, run the Memory Reference
#  Visualization tool with its default settings over this program.
#  You may, at the same time or separately, run the Data Cache Simulator 
#  over this program to observe caching performance.  You can change the 
#  program to be row-by-row traversal and see the difference.
#
#  The C/C++/Java-like equivalent of this MIPS program is:
#     int size1 = 16;
#     int size2 = 8;
#     int[size1][size2] data;
#     int value = 0;
#     for (int i=0; i<3; i++){
#       for (int col = 0; col < size2; col+=2) {
#         for (int row = 0; row < size1; row+=2) {
#           data[row][col] = value;
#           value++;
#           data[row][col+1] = value;
#           value++;
#         }
#       }
#     }
#
#
         .data
data:    .word     0 : 128       # 16x16 matrix of words
         .text
         li       $t0, 16        # $t0 = number of rows
         li       $t1, 8         # $t1 = number of columns
         li       $t3, 3
         move     $t4, $zero
outer:   move     $s0, $zero     # $s0 = row counter
         move     $s1, $zero     # $s1 = column counter
         move     $t2, $zero     # $t2 = the value to be stored
#  Each loop iteration will store incremented $t1 value into next element of matrix.
#  Offset is calculated at each iteration. offset = 4 * (row*#cols+col)
#  Note: no attempt is made to optimize runtime performance!
loop:    mult     $s0, $t1       # $s2 = row * #cols  (two-instruction sequence)
         mflo     $s2            # move multiply result from lo register to $s2
         add      $s2, $s2, $s1  # $s2 += col counter
         sll      $s2, $s2, 2    # $s2 *= 4 (shift left 2 bits) for byte offset
         sw       $t2, data($s2) # store the value in matrix element
         addi     $t2, $t2, 1    # increment value to be stored
         addi     $s2, $s2, 4    # next matrix item 
         sw       $t2, data($s2) # store the value in matrix element
         addi     $t2, $t2, 1    # increment value to be stored
#  Loop control: If we increment past bottom of column, reset row and increment column 
#                If we increment past the last column, we're finished.
         addi     $s0, $s0, 2    # increment row counter
         bne      $s0, $t0, loop # not at bottom of column so loop back
         move     $s0, $zero     # reset row counter
         addi     $s1, $s1, 2    # increment column counter
         bne      $s1, $t1, loop # loop back if not at end of matrix (past the last column)
         addi     $t4, $t4, 1
         bne      $t4, $t3, outer#repeat three times
#  We're finished traversing the matrix.
         li       $v0, 10        # system service 10 is exit
         syscall                 # we are outta here.
         
         
         
         
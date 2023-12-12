#Thabang Sambo
#SMBTHA002

.data
   filename: .asciiz "C:/Users/Thabang_TP STYLES/Documents/UCT2023/CSC2002S/Assignments/Assignment4/sample_images/house_64_in_ascii_cr.ppm"
   fileOutput:     .asciiz "C:/Users/Thabang_TP STYLES/Documents/UCT2023/CSC2002S/Assignments/Assignment4/data/brightness.ppm"  
   original_image_text: .asciiz "Average pixel value of the original image:\n"    
   new_image_text: .asciiz  "\nAverage pixel value of new image:\n" 
   
   filetype:   .space 30
   saved:  .space 20
   parse:  .space 20
   delimeter: .asciiz "\n"
     
   IncreasedValue:    .word   0     #increased by 10
   OriginalValue:    .word   0     #read pixel
   fileBuffer:  .space 500000  #buffer storing words
   result: .space 500000      #store result
   

   

.text
.globl main

main:
   la $s2, saved  #get the converted value
   la $s3, result #store the obtained results
   la $s4, filetype #file read
   move $t1, $zero #set to 0
   move $t7, $zero #set to 0
   move $t9, $zero  #set to 0
   # Open the file
   li $v0, 13
   la $a0, filename #read file contents
   li $a1, 0
   li $a2, 0
   syscall
   move $s0, $v0
   # check file description
   li $v0, 14
   move $a0, $s0
   la $a1, filetype #read line
   li $a2, 30
   syscall
   # go through pixels
   li $v0, 14
   move $a0, $s0
   la $a1, fileBuffer #buffer
   li $a2, 500000
   syscall

   # exit the file
   li $v0, 16
   move $a0, $s0
   syscall
   lb $t3, 0($a1) #look for '0' in byte
   move $t4, $zero #set inceremnter
   move $t0, $a1 #adress of fileBuffer to $t0 
    

   parsetoInt:
      lb $t3, 0($t0)
      beqz $t3, exit      # look for 0 bytes
      beq $t3, '\n', Integer # read all characters
      sb $t3, 0($s2)
      addi $t0, $t0, 1 
      addi $s2, $s2, 1 
      addi $t4, $t4, 1  #store value
      j parsetoInt

  Integer:
   li $t6, 0 #set to 0
   sub $s2, $s2, $t4 #previuous value
   move $t8, $zero

   proceed:
      lb $t7, 0($s2)
      beq $t8, $t4, stop #branch to stop
      mul $t6, $t6, 10
      sub $t7, $t7, 48
      add $t6, $t6, $t7 
      addi $s2, $s2, 1
      addi $t8, $t8, 1
      j proceed

   stop:
      addi $t0, $t0, 1
      sub $s2, $s2, $t4
      lw $t7, OriginalValue
      add $t7, $t7, $t6   # Incrementing the OriginalValue
      sw $t7, OriginalValue      # Store OriginalValue
      add $t6, $t6, 10
      
      bgt $t6, 255, insertCap #set the limit
      bgt $t6, 100, nextProcess #continue
      blt $t6, 100, processed #checked

      nextProcess:
         blt $t6, 110, checkCap #check values 
         
         processed:
            add $s0, $t4, $zero
            sub $t4, $t4, 1
            add $s3, $s3, $t4
            move $t4, $zero
            move $t5, $zero
            
            String_Conversion:
                 lw $t9, IncreasedValue
	         add $t9, $t9, $t6   # Incrementing the IncreasedValue
	         sw $t9, IncreasedValue      # Store IncreasedValue
	         div $t6, $t6, 10
                 mfhi $t7
                 beq $t5, $s0, ConditiontoExit #delimeter
                 add $t7, $t7, 48
               
                sb $t7, 0($s3)
                addi $s3, $s3, -1
                addi $t5, $t5, 1
                j String_Conversion 

      checkCap:
      addi $t4, $t4, 1
      add $s0, $t4, $zero
      sub $t4, $t4, 1
      add $s3, $s3, $t4
      move $t4, $zero
      move $t5, $zero
      j String_Conversion
      
     insertCap:
       li $t6, 255
       add $t2, $t2, $t6
       add $s0, $t4, $zero
       sub $t4, $t4, 1
       add $s3, $s3, $t4
       move $t4, $zero
       move $t5, $zero
      j String_Conversion
     
    ConditiontoExit:
    addi $t5, $t5, 1
    add $s3, $s3, $t5
    addi $t9, $zero, 10
    sb $t9, 0($s3)
    addi $s3, $s3, 1
    j parsetoInt

Calculator:
    
    li $t0, 3  #rows
    li $t1, 4096  #64x64 the amount of pixels
    mul $t2, $t1, $t0 #get the values that are RGB in the file
    lw $t3, OriginalValue
    mtc1 $t3, $f0
    cvt.d.w $f0, $f0
    lw $t4, IncreasedValue
    mtc1 $t4, $f2
    cvt.d.w $f2, $f2
    mtc1 $t2, $f4
    cvt.d.w $f4, $f4

    # get the answwer for the orginal
    div.d $f6, $f0, $f4
    # get the answer for the modified values
    div.d $f8, $f2, $f4
	jr $ra


exit:
   li   $v0, 13 #open file
   la   $a0, fileOutput
   li   $a1, 1
   syscall
   move $s6, $v0

   li   $v0, 15 #write to file
   move $a0, $s6
   la   $a1, filetype
   li   $a2, 30
   syscall
   
   li   $v0, 15 #write to file
   move $a0, $s6
   la   $a1, result
   li   $a2, 50000
   syscall
   jal Calculator
   
    # display text
    li $v0, 4
    la $a0, original_image_text
    syscall

    # display original
    li $v0, 3 
    mov.d $f12, $f6  
    syscall

    # string prompt
    li $v0, 4
    la $a0, new_image_text
    syscall

    # display modified
    li $v0, 3  
    mov.d $f12, $f8  
    syscall
   
   # exit the file 
   li   $v0, 16
   move $a0, $s6
   syscall
   li $v0, 10 #exit program
   syscall

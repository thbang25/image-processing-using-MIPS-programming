#Thabang Sambo
#SMBTHA002

.data
filename: .asciiz "C:/Users/Thabang_TP STYLES/Documents/UCT2023/CSC2002S/Assignments/Assignment4/sample_images/house_64_in_ascii_lf.ppm"
fileOutput: .asciiz "C:/Users/Thabang_TP STYLES/Documents/UCT2023/CSC2002S/Assignments/Assignment4/data/grey.ppm"
fileBuffer: .space 50000
buffer: .space 50000

.text
.globl main

main:
    # Open file
    li $v0, 13         
    la $a0, filename
    li $a1, 0 
    li $a2, 0         
    syscall
    move $s0, $v0       

    # the file to write to
    li $v0, 13
    la $a0, fileOutput
    li $a1, 1           
    li $a2, 0
    syscall
    move $s1, $v0       

StoreFile:#copy contents of file
    li $v0, 14
    move $a0, $s0
    la $a1, fileBuffer
    li $a2, 50000
    syscall
    # Initialize the buffers
    la $s2, fileBuffer 
    la $s3, buffer
    la $s4, buffer
    li $t1, 1       
    # convert the file typr
    li $t2, 80           
    sb $t2, ($s3)
    addi $s2, $s2, 1
    addi $s3, $s3, 1
    li $t2, 50           
    sb $t2, ($s3)
    addi $s2, $s2, 1
    addi $s3, $s3, 1
    li $t2, 10
    sb $t2, ($s3)
    addi $s2, $s2, 1
    addi $s3, $s3, 1

filetype:
    lb $t2, ($s2)
    sb $t2, ($s3)
    addi $s3, $s3, 1
    addi $s2, $s2, 1
    beq $t2, '\n', delmeter
    j filetype

delmeter:
    addi $t1, $t1, 1
    beq $t1, 4, RGBvalues
    j filetype

RGBvalues:          
    li $t1, 0           
    li $t3, 0
    li $t4, 0           
    li $t5, 0           
    li $t6, 0           

parsetoInt:
    lb $t2, ($s2)
    beq $t2, '\n', delimeter
    beq $t2, 0, storeInfile
    sub $t2, $t2, 48
    mul $t4, $t4, 10
    add $t4, $t4, $t2
    addi $s2, $s2, 1
    j parsetoInt

delimeter:
    addi $s2, $s2, 1
    addi $t3, $t3, 1
    add $t5, $t5, $t4
    li $t4, 0
    beq $t3, 3, Calculate1
    j parsetoInt

Calculate1:
    addi $t6, $t6, 1
    beq $t6, 4097, storeInfile
    divu $t5, $t5, 3
    mflo $t4
    blt $t4, 100, Calculate2
    addi $s3, $s3, 3
    li $t8, 10
    sb $t8, ($s3)
    j String_Converted

Calculate2: #read a value with 2 characters
    blt $t4, 10, Calculate3
    addi $s3, $s3, 2  
    li $t8, 10
    sb $t8, ($s3)
    j String_Converted

Calculate3:#read a value with 1 character
    addi $s3, $s3, 1  
    li $t8, 10
    sb $t8, ($s3)
    j String_Converted

String_Converted:
    beqz $t4, stop     # stop conversion
    divu $t4, $t4, 10     
    mfhi $t3             
    addi $t3, $t3, 48     
    sb $t3, -1($s3)  
    # increment       
    addi $s3, $s3, -1        
    addi $t1, $t1, 1
    j String_Converted

stop:
    add $s3, $s3, $t1
    addi $s3, $s3, 1
    li $t1, 0
    li $t3, 0
    li $t5, 0
    j parsetoInt

storeInfile:
    sb $t2, ($s3)
    sub $s4, $s3, $s4
#write thefile info to buffer
    li $v0, 15
    move $a0, $s1
    la $a1, buffer
    move $a2, $s4
    syscall

exit:
#close the file
    li $v0, 16          
    move $a0, $s0       
    syscall
#close the file
    li $v0, 16 
    move $a0, $s1       
    syscall
# Exit Program
    li $v0, 10          
    syscall

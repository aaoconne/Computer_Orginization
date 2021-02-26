.text 
    j main # jump to main 

.data 
    prompt: .asciiz "Insert the array size: \n" 
    prompt1: .asciiz "Insert the values you would like sorted. One per line: \n"
    string: .asciiz "The elements sorted is: "
    string1: .asciiz "\n"

.text
.globl main 
main: 
    la $a0, prompt  
    li $v0, 4 # print the prompt 
    syscall 

    li $v0, 5 # get the array size and store it in $v0 
    syscall 
    move $s2, $v0 # the value of n is set to equal $s2
    sll $s0, $v0, 2 # $s0 is set to equal n * 4 
    sub $sp, $sp, $s0 # creation of the stack 

    la $a0, prompt1 
    li $v0, 4 # print prompt1
    syscall
    move $s1, $zero # i is set to equal 0 

n_sort:
    bge $s1, $s2, exit_n # if i is greater than or equal to n, branch to exit_n 
    sll $t0, $s1, 2 # $t0 is set to equal i*4 
    add $t1, $t0, $sp # $t1 is set to equal sp+i*4
    li $v0, 5 # load one element from the array 
    syscall
    sw $v0, 0($t1) # the element is stored in $t1 
    la $a0, string1
    li $v0, 4 
    syscall 
    addi $s1, $s1, 1 # i is set to equal i + 1 
    j n_sort 

exit_n: 
    move $a0, $sp # $a0 is set to be the base address of the array 
    move $a1, $s2 # $a1 equals the size of the array 
    jal sort # the array has been sorted and is now the stack frame 
    la $a0, string 
    li $v0, 4 # print the string
    syscall 
    move $s1, $zero # i is now set to = 0 

for_loop:
    bge $s1, $s2, exit # if i is greater than or equal to n, branch to exit label
    sll $t0, $s1, 2 # $t0 is set to equal i * 4
    add $t1, $sp, $t0 # $t1 is set to equal the address of a[i]
    lw $a0, 0($t1) 
    li $v0, 1 # print the element a[i]
    syscall 
    la $a0, string1 
    li $v0, 4 # print the string
    syscall 
    addi $s1, $s1, 1 # i is set to equal i + 1
    j for_loop

exit:
    add $sp, $sp, $s0 # deletion of the stack frame  
    li $v0, 10 # terminate program 
    syscall 

sort: # stores the values input
    addi $sp, $sp, -20 # save values to the stack 
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    move $s0, $a0 # base address of the array 
    move $s1, $zero # i is set to equal 0 
    addi $s2, $a1, -1 # the length - 1

for_loop_i:
    bge $s1, $s2, exit_i # if i is greater than or equal to length - 1, exit the for loop 
    move $a0, $s0 # base address of the stack 
    move $a1, $s1 # $a1 is now set to i 
    move $a2, $s2 # subtract 1 from the length 
    jal minimum 
    move $s3, $v0 # return the value of minimum 
    move $a0, $s0 
    move $a1, $s1 # i 
    move $a2, $s3 # minimum 
    jal exhange 
    addi $s1, $s1, 1 # add 1 to $s1 and save it in $s1 
    j for_loop_i # jump back to the for loop 
 
 exit_i:
    lw $ra, 0($sp) # restore the values from the stack 
    lw $s0, 4($sp) 
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp) 
    addi $sp, $sp, 20 # restore the stack pointer 
    jr $ra 

minimum:
    move $t0, $a0 # this is the base of the array 
    move $t1, $a1 # the minimum is set to equal i 
    move $t2, $a2 # the last value  
    sll $t3, $t1, 2 # first element is multiplied by 4 
    add $t3, $t3, $t0 # the index is = to the base array + i * 4  
    lw $t4, 0($t3) # minimum is set to equal array[first]
    addi $t5, $t1, 1 # i is set to = 0  

minimum_for_loop: # handles putting the numbers in ascending order as their input 
    bgt $t5, $t2, minimum_end # branch to minimum_end 
    sll $t6, $t5, 2 # the value of i * 4 
    add $t6, $t6, $t0 # the index is = to the base array + i * 4 
    lw $t7, 0($t6) # array[index]  
    bge $t7, $t4, if_minimum_exit # skip the if when array[i] is greater than or equal to minimum 
    move $t1, $t5 # minimum is set to = i  
    move $t4, $t7 # minimum is set to = array[i]

if_minimum_exit:
    addi $t5, $t5, 1 # i += 1
    j minimum_for_loop

minimum_end:
    move $v0, $t1 # return minimum 
    jr $ra 

exhange:
    sll $t1, $a1, 2 # i * 4
    add $t1, $a0, $t1 # v+i*4 
    sll $t2, $a2, 2 # j * 4
    add $t2, $a0, $t2 # array+j*4 
    lw $t0, 0($t1) # array[i]
    lw $t3, 0($t2) # array[j]
    sw $t3, 0($t1) # array[i] = array[j]
    sw $t0, 0($t2) # array[j] is set to = $t0 
    jr $ra 


 



.data 
    prompt: .asciiz "Input an integer: \n" # prompt for user to put in number to take the factorial of 
    result: .asciiz "Factorial for number input = " # print statement for the result of the number input 
    string: .asciiz "Error: The number input is less than 0. \n" # print this if number input is is negative 
    string1: .asciiz "Out of boundary error: The output is larger than 32 bits. \n" # print if the number input is larger than 12 

.text
main:
li $v0, 4 
la $a0, prompt 
syscall # output the prompt to the screen 

li $v0, 5 
syscall # read the value that was input 

move $a0, $v0
jal fact #jump to factorial
move $t0, $v0

li $v0, 4 
la $a0, result 
syscall 

li $v0, 1 
move $a0, $t0 
syscall # execute 

li $v0, 10 
syscall

.text
fact:
    addi $sp, $sp, -8 # adjust stack for 2 items 
    sw $a0, 4($sp) # save the return address
    sw $ra, 0($sp) # save arguement and place it as the last item on the stack 
    addi $t0, $zero, 1 # add 1 to 0 and save it in $t0
    blt $a0, 0, Neg # branch to Neg if input is less than 0
    bge $a0, $t0, Else # if the input is >= than 1, branch to the Else block
    bgt $a0, 12, Large # if the number input is larger than 12, jump to Large 
    addi $v0, $zero, 1 # add one to 0 and store it in $v0. if it is 1, then just return 1 
    lw $a0, 4($sp) #
    lw $ra, 0($sp) # 
    addi $sp, $sp, 8
    jr $ra # if statement 

Else: #jump taken if n >= 1
    addi $a0, $a0, -1 # decrements value 
    jal fact # call the function until 0 is returned 
    lw $a0, 4($sp) # restore the original value of n 
    lw $ra, 0($sp) # and return address  
    addi $sp, $sp, 8 # pop 2 items from the stack 
    mul $v0, $v0, $a0 # multiply $a0 and $v0 to get result while storing it in $v0
    jr $ra # return 

Neg: #if the number is negative 
    li $v0, 4 # code 4  == print string 
    la $a0, string 
    syscall 
    j main

Large: #if the number is greater than or equal to 12 
    li $v0, 4 # code 4 == print string 
    la $a0, string1 
    syscall 
    j main 



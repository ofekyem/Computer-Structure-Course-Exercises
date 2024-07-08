# Ofek Yemini
.extern printf
.extern scanf 

.section .rodata
#those ascii values are used in swapCase function
ascii_max_upper:
        .byte 91
ascii_min_upper:
        .byte 65 
ascii_max_lower:
        .byte 122  
ascii_min_lower:
        .byte 96 
ascii_range_upper_lower:
        .byte 32  

# this is the output when the user enters wrong input in pstrijcpy           
invalid_input_string:            
        .string	"invalid input!\n"   
.text



.globl	pstrlen 
.type	pstrlen, @function	 
# here we will return the first value of the given pstring which represents the length of it       
pstrlen:   
    pushq %rbp	                        
	movq %rsp, %rbp  

	movzbq (%rdi), %rax

    movq %rbp,%rsp 
    popq %rbp                    
	ret   




.globl	swapCase
.type	swapCase, @function	 
# here we will run in loop from the end of the pstring to the start of it and update the case      
swapCase:
    pushq %rbp	                        
	movq %rsp, %rbp
    pushq %rdx

    # lets make it zero for start 
    xorq %rax, %rax 
    #lets get the size of the pstring and put it in al for the loop                       
	movb (%rdi), %al    

.loopSwap:
    # if we at the end of the string then jump to the end of the swap function
    cmpb $0, %al                               
    je .doneSwap
    #lets get the first char in the string and put it in dl        
    movb (%rdi, %rax), %dl      
    #if its smaller then the A letter value in ascii table then its not a number so continue next char
    cmpb ascii_min_upper, %dl   
    jb .continueLoop 
    #if its bigger then the z letter value in ascii table then its not a number so continue next char
    cmpb ascii_max_lower, %dl 
    ja .continueLoop
    #if its also bigger then the a letter in ascii table then its lower case letter
    cmpb ascii_min_lower, %dl   
    ja .lowerCase         
    #if its also smaller then the Z letter in ascii table then its upper case letter 
    cmpb ascii_max_upper, %dl      
    jb .upperCase
    # if we get to here, its those signs between Z and a in ascii so continue to next char
    jmp .continueLoop 

.lowerCase:
    # lets sub the difference value between a lower case letter and an upper case letter to make the swap
    subb ascii_range_upper_lower,%dl     
    # and we will upddate the original string with the new upper char then continue to next char          
    movb %dl, (%rdi, %rax)   
    jmp .continueLoop

.upperCase:
    # the same as in lower case but here we add the difference value
    addb ascii_range_upper_lower,%dl    
    # and here we also update the original string but with the new lower char                
    movb %dl, (%rdi, %rax)            
        
.continueLoop:
    #lets dec al to cotinue to the next char in string (we dec because we start from the end)
    decb %al                          
    jmp .loopSwap
            
.doneSwap:
    # lets put our updated string in rax and exit
    movq %rdi, %rax

    popq %rdx 
    movq %rbp,%rsp 
    popq %rbp        
	ret   



.globl pstrijcpy
.type	pstrijcpy, @function
# here we will check if the indexes input is correct and then we will copy from source pstring to destination pstring
pstrijcpy: 
    #lets set rbp to work for this function
    pushq %rbp	                        
	movq %rsp, %rbp
    #save the values from run_func, becuase we are gonna use those registers here
    pushq %r10 
    pushq %r11 

    #lets put zero in r10
    xorq %r10,%r10 
    #lets move the length of the first pstring to r10
    movzbq (%rdi),%r10 
    #lets put zero in r11
    xorq %r11,%r11 
    #lets move the length of the second pstring to r11
    movzbq (%rsi),%r11  
 
    # if the second input is smaller than the first its invalid case so jump there
    cmpb %dl,%cl 
    jb invalidCase 
    # if the second input is bigger than the length of the first pstring its invalid
    cmpb %r10b,%cl 
    jae invalidCase 
    # if second input is bigger than the length of the second pstring its invalid
    cmpb %r11b,%cl 
    jae invalidCase 
    # if the first input is bigger the the length of pstring1 then its invalid
    cmpb %r10b, %dl 
    jae invalidCase 
    # if the first input is bigger the the length of pstring2 then its invalid
    cmpb %r11b, %dl 
    jae invalidCase 
    # if the first input is negative its invalid
    cmpb $0,%dl 
    jb invalidCase  
    # if the second input is negative its invalid
    cmpb $0,%cl 
    jb invalidCase

    # now we will run in loop from i to j and cpy source to destination
loopCpy: 
    #if we passed the bigger index then exit loop
    cmpb %dl,%cl 
    jb endCpyFun  
    # copy the char from source pstring in a temp register
    movb 1(%rsi,%rdx),%r10b  
    # copy the char from temp register in destisnation
    movb %r10b, 1(%rdi,%rdx)  
    #lets move to the next index and continue the loop copy
    incb %dl
    jmp loopCpy 

invalidCase: 
    # we are here so the input was invalid lets print it 
    # lets save our first pstring in rbx 
    movq %rdi,%rbx  
    # lets set the output for invalid menu
    movq $invalid_input_string, %rdi  
    #lets call printf
    xorq %rax,%rax 
    call printf   
    # take back pstring1 from rbx to rdi 
    movq %rbx,%rdi

endCpyFun: 
    # here we finish the function 
    # lets move rdi to rax becuase rax should hold the output of the function 
    movq %rdi,%rax  
    # lets pop all registers we use and rbp back to the caller  
    popq %r11
    popq %r10
    movq %rbp,%rsp 
    popq %rbp        
	ret 










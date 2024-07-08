# Ofek Yemini
.extern printf
.extern scanf 

.section .rodata 
#this is the output of the pstrlen function
pstrlen_fun_string:        
        .string	"first pstring length: %d, second pstring length: %d\n" 
#this is the output of the swapCase and pstrijcpy functions        
updated_string:      
        .string	"length: %d, string: %s\n" 
# this is the input format for getting 2 indexes from user in the running of the function pstrijcpy        
format_for_int_scanf:      
        .string  "%d %d"        
# this is the output when the user enters invalid option           
invalid_option_string:            
        .string	"invalid option!\n"   


    
.section .text                      
.globl	run_func
.type	run_func, @function   
#here we start the functions run
run_func: 
    #lets start by saving our rsp value from caller and lets updtae rbp to work for this function
    pushq %rbp	                        
	movq %rsp, %rbp  
    # lets save those registers in stack to avoid override their values from main.c
    pushq %rcx
    pushq %r8
    pushq %r9 
    # lets push those registers becuase were gonna use them
    pushq %rbx                           
    pushq %r12                           
    pushq %r13  
    
    # lets save our 2 strings of the pstring in less useful and not in registers which change every action.
    movq %rsi, %r12
    movq %rdx, %r13

    #lets check if the option we got is valid.
    #rdi holds the option becuase the option was the first argument we got from main.c     
 checkOption:
    #if its 31 then its pstrlen then go to its section                           
    cmpq $31, %rdi
    je .f31 
    #if its 33 then its swapCase then go to its section 
    cmpq $33,%rdi
    je .f33
    #if its 34 then its pstrijcpy then go to its section 
    cmpq $34, %rdi 
    je .f34 
    # if its not one of the three, then its invalid option so go to this section
    jmp .invalidOpt


#this section runs pstrlen
.f31:
    # lets get the first pstring length with the function
    movq %r12,%rdi 
    call pstrlen  
    #lets put the result in rsi for printf
    movq %rax, %rsi 

    # now lets get the second pstring length with the function
    movq %r13, %rdi 
    call pstrlen 
    #lets put the result in rdx for printf
    movq %rax, %rdx  

    #lets set our output string and call printf then go to the end of program
    movq $pstrlen_fun_string, %rdi 
    xorq %rax, %rax
    call printf   
    jmp .done 


#this section runs swapCase
.f33: 
    # lets first put the length of the first pstring in rsi for printf
    movzbq (%r12),%rsi 
    # lets put the first pstring in rdi and call the swap function
    movq %r12,%rdi 
    call swapCase  
    #lets take the updated string from function to rdx for printf
    movq %rax,%rdx 
    #lets set out output and call printf
    movq $updated_string,%rdi 
    xorq %rax,%rax 
    call printf 

    # lets put the length of the second pstring in rsi for printf 
    movzbq (%r13),%rsi 
    # lets put the second pstring in rdi and call the swap function
    movq %r13,%rdi 
    call swapCase 
    #lets take the updated string from function to rdx for printf
    movq %rax,%rdx 
    #lets set out output and call printf and go to the end of the program
    movq $updated_string,%rdi 
    xorq %rax,%rax 
    call printf  
    jmp .done


#this section runs pstrijcpy    
.f34:
    #lets move the stack pointer becuase were gonna add 2 integers there
    subq $16, %rsp  
    # here we set the scanf format for 2 integers
    movq $format_for_int_scanf,%rdi
    # we set the first integer to enter the up 8 bytes                  
    leaq (%rsp), %rsi 
    # we set the second integer to enter the down 8 bytes
    leaq 8(%rsp), %rdx 
    # lets get the numbers with scanf
    xorq %rax, %rax  
    call scanf    
    # lets take the input integers into dl and cl for the function pstrijcpy
    movb (%rsp),%dl          
    movb 8(%rsp),%cl 
    # lets take our 2 pstrings into rdi and rsi for the function pstrijcpy
    movq %r12,%rdi 
    movq %r13,%rsi  
    #lets call our function pstrijcpy
    call pstrijcpy  

    # lets take the output string for this function to print pstring1
    movq $updated_string, %rdi  
    # lets take the size of the first pstring for printf
    movzbq (%r12),%rsi 
    # the function returned the updtaed pstring in rax, lets move it to rdx for printf
    movq %rax,%rdx 
    # move it one step to point on the string part of the struct
    incq %rdx 
    #lets call printf
    xorq %rax,%rax 
    call printf  

    # we will do the same thing for the second pstring for printf
    movq $updated_string, %rdi 
    movzbq (%r13),%rsi 
    # here we take the original becuase it doesnt change in pstrijcpy
    movq %r13,%rdx 
    incq %rdx
    xorq %rax,%rax 
    call printf  
    # lets take the stack pointer back and end the program
    addq $16,%rsp
    jmp .done

.invalidOpt: 
    #in this case the user entered wrong option so lets print to him he is wrong
    movq $invalid_option_string, %rdi
    xorq %rax, %rax
    call printf  
.done:
    #lets pop all the registers values we saved in the begining
    popq %r13 
	popq %r12 
    popq %r9
    popq %r8 
    popq %rcx
    popq %rbx 
    #lets take rsp back to point where rbp is for the caller and lets get back to the call line in main.c
    movq %rbp,%rsp  
    popq %rbp


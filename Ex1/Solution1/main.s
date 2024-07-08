# Ofek Yemini
.extern printf
.extern scanf
.extern srand 
.extern rand 

#this program represents the guessing game for part 1.

.section .data 
# We will use it for the input numbers we get from the user to avoid segmantation fault.
dynamic_input:
    .space 255, 0x0

.section .rodata 
# This number will represent number of guesses the user has in game.
M: 
    .quad 5 
# This number will represent range of the generate number(between 0 to N).   
N:  
    .quad 10
# A string that represnets the first output that asks the user for seed.         
print_enter_seed:
    .string "Enter configuration seed: " 
# A string that represents the loop output that asks the user for his guess.    
print_enter_guess:
    .string "What is your guess? "   
# A string that represents the output when the user guessed wrong answer.    
print_incorrect:
    .string "Incorrect.\n" 
# A string that represents the output when the winner has won the game.  
print_win:
    .string "Congratz! You won!\n"   
# A string that represents the output when the winner has lost the game.    
print_lose:
    .string "Game over, you lost :(. The correct answer was %d\n" 

# This will be used in scanf function as the format for the integers we get from user         
format_scanf_for_int:      
    .string  "%d"
   
.section .text
.globl main
.type	main, @function 
main:
    # Here the program starts and push the registers to work
    pushq %rbp
    movq %rsp, %rbp    

    # Print the first string that ask for seed with printf,
    # We will use xorl instead of mov to put zero in eax becuse its faster for the cpu.
    movl $print_enter_seed, %edi
    xorl %eax, %eax
    call printf

    # Get the seed answer from user with scanf
    movl $format_scanf_for_int, %edi
    movl $dynamic_input, %esi
    xorl %eax, %eax
    call scanf 

    # Use srand with the input seed we got from user
    movl %esi,%edi 
    call srand 

    # Use rand after we set the seed, the result will be in eax
    call rand  

    # eax holds the number that we want to change to the right range N, we will use modulo:
    # lets put zero in the high part of number because there is no use for it in div.
    movl $0,%edx 
    # Lets put N in ecx as the number that we based the modulo on.
    movl N,%ecx
    # Lets do div that will do eax\ecx and put the reminder/modulu in edx
    divl %ecx 
    # Now the reminder is in edx so our reult is in there 


    # Lets save our number in ebx to avoid override later.
    # r12 will count the guesses the user has untill now, lets set it to x.
    movl %edx,%ebx 
    movq $0,%r12 

    #Test print delete for later
    movl $format_scanf_for_int, %edi
    movl %ebx,%esi
    xorl %eax, %eax
    call printf
    

.guessloop:
    # If we reach the end of rounds (M represnts that) then you failed so go to fail section. 
    cmp M,%r12
    je  .fail 
    # Add 1 to the counter for the next check
    inc %r12

    # Lets ask the user what is his guess
    movl $print_enter_guess, %edi
    xorl %eax, %eax
    call printf 

    # Lets get his result
    movl $format_scanf_for_int, %edi
    movl $dynamic_input, %esi
    call scanf 

    # Now lets check if he is right (remember that ebx holds the correct result). 
    cmp %esi,%ebx
    # If he is right, go to the succes section.
    je  .succes 

    # The user is wrong so lets print inccorect 
    movl $print_incorrect, %edi
    xorl %eax, %eax
    call printf 

    # Continue to next guess
    jmp .guessloop

.succes: 
    # Set the printing messege to wining and continue. 
    movl $print_win, %edi
    jmp .endgame

.fail:
    # Set the printing messege to losing, and set the correct answer for printing.
    movl $print_lose, %edi
    movl %ebx, %esi 

.endgame:
    # Print the messege.
    xorl %eax, %eax
    call printf 

    # Exit the program and pop registers.
    xorq %rax, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

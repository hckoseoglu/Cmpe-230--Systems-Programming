.section .bss
input_buffer: .space 256            # Allocate 256 bytes for input buffer
single_char: .space 1

.section .data

newline: .byte '\n'    # Define newline character '\n'

.section .text
.global _start

_start:

    # Read input from standard input
    mov $0, %eax                    # syscall number for sys_read
    mov $0, %edi                    # file descriptor 0 (stdin)
    lea input_buffer(%rip), %rsi    # pointer to the input buffer
    mov $256, %edx                  # maximum number of bytes to read
    syscall                         # perform the syscall
    jmp main_loop

main_loop:
    
    # take the first byte of the memory pointed by rsi and move it into %r8b
    movb (%rsi), %r8b

    # if next char is new line, then exit the program
    cmp $0x0A, %r8b
    # Exit the program
    je exit_program
    
    # move r8b to single_char
    mov %r8b, single_char

    # save the rsi
    mov %rsi, %r9

    # move the address of the single char to %rsi
    lea single_char(%rip), %rsi

    # Print the character
    mov $1, %edx
    call print_func

    # put %r9 into %rsi back
    mov %r9, %rsi

    # Increment the pointer
    inc %rsi

    # jump to the beginning of the loop
    jmp main_loop
    

print_func:
    # Assumes edx has size and rsi has address (popped from stack)
    mov $1, %eax              # syscall number for sys_write
    mov $1, %edi              # file descriptor 1 (stdout)
    syscall
        
    mov $1, %eax              # syscall number for sys_write
    mov $1, %edi              # file descriptor 1 (stdout)
    mov $1, %edx
    mov $newline, %rsi
    syscall

    ret

exit_program:
    # Exit the program
    mov $60, %eax               # syscall number for sys_exit
    xor %edi, %edi              # exit code 0
    syscall

.section .bss
input_buffer: .space 257            # Allocate 256 bytes for input buffer
print_byte: .space 1

.section .data

newline: .byte '\n'    # Define newline character '\n'
space: .byte ' '       # Define space character ' '

addi_opcode: .string "0010011"
add_opcode: .string "0110011"
add_funct7: .string "0000000"
add_funct3: .string "000"

mul_funct7: .string "0000001"
mul_funct3: .string "000"
mul_opcode: .string "0110011"

sub_funct7: .string "0100000"
sub_funct3: .string "000"
sub_opcode: .string "0110011"

xor_opcode: .string "0110011"
xor_funct3: .string "000"
xor_funct7: .string "0000100"

and_funct7: .string "0000111"
and_funct3: .string "000"
and_opcode: .string "0110011"

or_funct7: .string "0000110"
or_funct3: .string "000"
or_opcode: .string "0110011"

x0: .string "00000"
x1: .string "00001"
x2: .string "00010"
exit_string: .string "Exiting program\n"


.section .text
.global _start

_start:

    # Read input from standard input
    mov $0, %eax                    # syscall number for sys_read
    mov $0, %edi                    # file descriptor 0 (stdin)
    lea input_buffer(%rip), %rsi    # pointer to the input buffer
    mov $256, %edx                  # maximum number of bytes to read
    syscall                         # perform the syscall

    # Exit the program
    cmp $0x0A, %r8b
    je exit_program
    
    mov %rsi, %r15
    jmp create_number

    create_number:
        mov $0, %r8
        movb (%r15), %r8b
        cmp $0x00, %r8b
        je exit_program
        cmp $0x20, %r8b
        je push_stack
        cmp $0x0A, %r8b
        je exit_program

        # cmp addition
        cmp $0x2B, %r8b
        je addition

        # cmp multiplication
        cmp $0x2A, %r8b
        je multiplication

        # cmp subtraction
        cmp $0x2D, %r8b
        je subtraction

        # cmp xor
        cmp $0x5E, %r8b
        je op_xor

        # cmp and
        cmp $0x26, %r8b
        je op_and

        # cmp or
        cmp $0x7C, %r8b
        je op_or

        sub $48, %r8w

        imul $10, %r9w
        add %r8w, %r9w
        inc %r15
        jmp create_number

    push_stack:
        push %r9
        inc %r15
        mov $0, %r9
        jmp create_number
    
    
    addition:
    # I type: imm(12) rs1(00000) funct3(000) rd opcode(0010011)
    # R type: funct7(0000000) rs2 rs1 funct3(000) rd opcode(0110011)

        # ###########
        pop %r12 # addi x2 x0 %r12 => rd = 00010 (I type)
        # Print immidiate
        # r13 loop counter   
        mov $12, %r13
        mov %r12, %rax
        binary_loop_addition_1:
            mov $2, %rbx
            xor %rdx, %rdx
            div %rbx
	        add $48, %rdx
	        push %rdx
            dec %r13
            cmp $0, %r13
            jne binary_loop_addition_1

        mov $12, %r13
        print_loop_addition_1:
            pop %r14
            movb %r14b, print_byte
            lea print_byte(%rip), %rsi
            mov $1, %edx
            mov $1, %eax              # syscall number for sys_write
            mov $1, %edi              # file descriptor 1 (stdout)
            syscall
            dec %r13
            cmp $0, %r13
            jne print_loop_addition_1

        # Print space after imm using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x0 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x0(%rip), %rsi
        syscall

        # Print space after x0 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print add_funct3 from data section
        mov $3, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea add_funct3(%rip), %rsi
        syscall

        # Print space after funct3 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x2 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x2(%rip), %rsi
        syscall

        # Print space after x2 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print addi opcode from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea addi_opcode(%rip), %rsi
        syscall

        # Print newline after opcode using newline in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea newline(%rip), %rsi
        syscall

        # #########
        pop %r8 # addi x1 x0 %r11 => rs1 = 00001 (I type)

        # Print immidiate
        # r13 loop counter   
        mov $12, %r13
        mov %r8, %rax
        binary_loop_addition_2:
            mov $2, %rbx
            xor %rdx, %rdx
            div %rbx
	        add $48, %rdx
	        push %rdx
            dec %r13
            cmp $0, %r13
            jne binary_loop_addition_2

        mov $12, %r13
        print_loop_addition_2:
            pop %r14
            movb %r14b, print_byte
            lea print_byte(%rip), %rsi
            mov $1, %edx
            mov $1, %eax              # syscall number for sys_write
            mov $1, %edi              # file descriptor 1 (stdout)
            syscall
            dec %r13
            cmp $0, %r13
            jne print_loop_addition_2

        # Print space after imm using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x0 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x0(%rip), %rsi
        syscall

        # Print space after x0 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print add_funct3 from data section
        mov $3, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea add_funct3(%rip), %rsi
        syscall

        # Print space after funct3 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x1 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x1(%rip), %rsi
        syscall

        # Print space after x1 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print addi_opcode from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea addi_opcode(%rip), %rsi
        syscall

        # Print newline after opcode using newline in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea newline(%rip), %rsi
        syscall

        # #########
        add %r12, %r8  # add x1 x1 x2 

        # Print add_funct7 from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea add_funct7(%rip), %rsi
        syscall

        # Print space after funct7 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x2 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x2(%rip), %rsi
        syscall

        # Print space after x2 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x1 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x1(%rip), %rsi
        syscall

        # Print space after x1 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print add_func3 from data section
        mov $3, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea add_funct3(%rip), %rsi
        syscall

        # Print space after funct3 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x1 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x1(%rip), %rsi
        syscall

        # Print space after x1 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print add_opcode from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea add_opcode(%rip), %rsi
        syscall

        # Print newline after opcode using newline in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea newline(%rip), %rsi
        syscall

        push %r8
        inc %r15
        inc %r15
        jmp create_number

    multiplication:
    # I type: imm(12) rs1(00000) funct3(000) rd opcode(0010011)
    # R type: funct7(0000000) rs2 rs1 funct3(000) rd opcode(0110011)

        pop %r12 # addi x2 x0 %r12 => rd = 00010 (I type)
        # Print immidiate
        # r13 loop counter   
        mov $12, %r13
        mov %r12, %rax
        binary_loop_mul_1:
            mov $2, %rbx
            xor %rdx, %rdx
            div %rbx
	        add $48, %rdx
	        push %rdx
            dec %r13
            cmp $0, %r13
            jne binary_loop_mul_1

        mov $12, %r13
        print_loop_mul_1:
            pop %r14
            movb %r14b, print_byte
            lea print_byte(%rip), %rsi
            mov $1, %edx
            mov $1, %eax              # syscall number for sys_write
            mov $1, %edi              # file descriptor 1 (stdout)
            syscall
            dec %r13
            cmp $0, %r13
            jne print_loop_mul_1

        # Print space after imm using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x0 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x0(%rip), %rsi
        syscall

        # Print space after x0 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print add_funct3 from data section
        mov $3, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea add_funct3(%rip), %rsi
        syscall

        # Print space after funct3 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x2 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x2(%rip), %rsi
        syscall

        # Print space after x2 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print addi opcode from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea addi_opcode(%rip), %rsi
        syscall

        # Print newline after opcode using newline in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea newline(%rip), %rsi
        syscall

        # #########
        pop %r8 # addi x1 x0 %r11 => rs1 = 00001 (I type)

        # Print immidiate
        # r13 loop counter   
        mov $12, %r13
        mov %r8, %rax
        binary_loop_mul_2:
            mov $2, %rbx
            xor %rdx, %rdx
            div %rbx
	        add $48, %rdx
	        push %rdx
            dec %r13
            cmp $0, %r13
            jne binary_loop_mul_2

        mov $12, %r13
        print_loop_mul_2:
            pop %r14
            movb %r14b, print_byte
            lea print_byte(%rip), %rsi
            mov $1, %edx
            mov $1, %eax              # syscall number for sys_write
            mov $1, %edi              # file descriptor 1 (stdout)
            syscall
            dec %r13
            cmp $0, %r13
            jne print_loop_mul_2

        # Print space after imm using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x0 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x0(%rip), %rsi
        syscall

        # Print space after x0 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print add_funct3 from data section
        mov $3, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea add_funct3(%rip), %rsi
        syscall

        # Print space after funct3 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x1 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x1(%rip), %rsi
        syscall

        # Print space after x1 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print addi_opcode from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea addi_opcode(%rip), %rsi
        syscall

        # Print newline after opcode using newline in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea newline(%rip), %rsi
        syscall

        imul %r12, %r8 # mul x1 x1 x2 

        # Print mul_funct7 from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea mul_funct7(%rip), %rsi
        syscall

        # Print space after funct7 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x2 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x2(%rip), %rsi
        syscall

        # Print space after x2 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x1 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x1(%rip), %rsi
        syscall

        # Print space after x1 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print mul_funct3 from data section
        mov $3, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea mul_funct3(%rip), %rsi
        syscall

        # Print space after funct3 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x1 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x1(%rip), %rsi
        syscall

        # Print space after x1 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print mul_opcode from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea mul_opcode(%rip), %rsi
        syscall

        # Print newline after opcode using newline in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea newline(%rip), %rsi
        syscall

        push %r8
        inc %r15
        inc %r15
        jmp create_number
    
    subtraction:

        # I type: imm(12) rs1(00000) funct3(000) rd opcode(0010011)
        # R type: funct7(0000000) rs2 rs1 funct3(000) rd opcode(0110011)

        pop %r12 # addi x2 x0 %r12 => rd = 00010 (I type)
        # Print immidiate
        # r13 loop counter   
        mov $12, %r13
        mov %r12, %rax
        binary_loop_sub_1:
            mov $2, %rbx
            xor %rdx, %rdx
            div %rbx
	        add $48, %rdx
	        push %rdx
            dec %r13
            cmp $0, %r13
            jne binary_loop_sub_1

        mov $12, %r13
        print_loop_sub_1:
            pop %r14
            movb %r14b, print_byte
            lea print_byte(%rip), %rsi
            mov $1, %edx
            mov $1, %eax              # syscall number for sys_write
            mov $1, %edi              # file descriptor 1 (stdout)
            syscall
            dec %r13
            cmp $0, %r13
            jne print_loop_sub_1

        # Print space after imm using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x0 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x0(%rip), %rsi
        syscall

        # Print space after x0 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print add_funct3 from data section
        mov $3, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea add_funct3(%rip), %rsi
        syscall

        # Print space after funct3 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x2 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x2(%rip), %rsi
        syscall

        # Print space after x2 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print addi opcode from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea addi_opcode(%rip), %rsi
        syscall

        # Print newline after opcode using newline in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea newline(%rip), %rsi
        syscall

        # #########
        pop %r8 # addi x1 x0 %r11 => rs1 = 00001 (I type)

        # Print immidiate
        # r13 loop counter   
        mov $12, %r13
        mov %r8, %rax
        binary_loop_sub_2:
            mov $2, %rbx
            xor %rdx, %rdx
            div %rbx
	        add $48, %rdx
	        push %rdx
            dec %r13
            cmp $0, %r13
            jne binary_loop_sub_2

        mov $12, %r13
        print_loop_sub_2:
            pop %r14
            movb %r14b, print_byte
            lea print_byte(%rip), %rsi
            mov $1, %edx
            mov $1, %eax              # syscall number for sys_write
            mov $1, %edi              # file descriptor 1 (stdout)
            syscall
            dec %r13
            cmp $0, %r13
            jne print_loop_sub_2

        # Print space after imm using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x0 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x0(%rip), %rsi
        syscall

        # Print space after x0 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print add_funct3 from data section
        mov $3, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea add_funct3(%rip), %rsi
        syscall

        # Print space after funct3 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x1 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x1(%rip), %rsi
        syscall

        # Print space after x1 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print addi_opcode from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea addi_opcode(%rip), %rsi
        syscall

        # Print newline after opcode using newline in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea newline(%rip), %rsi
        syscall
        
        # #########

        sub %r12, %r8 # sub x1 x1 x2
        # Print sub_funct7 from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea sub_funct7(%rip), %rsi
        syscall

        # Print space after funct7 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x2 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x2(%rip), %rsi
        syscall

        # Print space after x2 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x1 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x1(%rip), %rsi
        syscall

        # Print space after x1 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print sub_func3 from data section
        mov $3, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea sub_funct3(%rip), %rsi
        syscall

        # Print space after funct3 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x1 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x1(%rip), %rsi
        syscall

        # Print space after x1 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print sub_opcode from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea sub_opcode(%rip), %rsi
        syscall

        # Print newline after opcode using newline in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea newline(%rip), %rsi
        syscall

        push %r8
        inc %r15
        inc %r15
        jmp create_number
    
    op_xor: 
        # I type: imm(12) rs1(00000) funct3(000) rd opcode(0010011)
        # R type: funct7(0000000) rs2 rs1 funct3(000) rd opcode(0110011)

        pop %r12 # addi x2 x0 %r12 => rd = 00010 (I type)
        # Print immidiate
        # r13 loop counter   
        mov $12, %r13
        mov %r12, %rax
        binary_loop_xor_1:
            mov $2, %rbx
            xor %rdx, %rdx
            div %rbx
	        add $48, %rdx
	        push %rdx
            dec %r13
            cmp $0, %r13
            jne binary_loop_xor_1

        mov $12, %r13
        print_loop_xor_1:
            pop %r14
            movb %r14b, print_byte
            lea print_byte(%rip), %rsi
            mov $1, %edx
            mov $1, %eax              # syscall number for sys_write
            mov $1, %edi              # file descriptor 1 (stdout)
            syscall
            dec %r13
            cmp $0, %r13
            jne print_loop_xor_1

        # Print space after imm using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x0 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x0(%rip), %rsi
        syscall

        # Print space after x0 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print add_funct3 from data section
        mov $3, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea add_funct3(%rip), %rsi
        syscall

        # Print space after funct3 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x2 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x2(%rip), %rsi
        syscall

        # Print space after x2 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print addi opcode from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea addi_opcode(%rip), %rsi
        syscall

        # Print newline after opcode using newline in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea newline(%rip), %rsi
        syscall

        # #########
        pop %r8 # addi x1 x0 %r11 => rs1 = 00001 (I type)

        # Print immidiate
        # r13 loop counter   
        mov $12, %r13
        mov %r8, %rax
        binary_loop_xor_2:
            mov $2, %rbx
            xor %rdx, %rdx
            div %rbx
	        add $48, %rdx
	        push %rdx
            dec %r13
            cmp $0, %r13
            jne binary_loop_xor_2

        mov $12, %r13
        print_loop_xor_2:
            pop %r14
            movb %r14b, print_byte
            lea print_byte(%rip), %rsi
            mov $1, %edx
            mov $1, %eax              # syscall number for sys_write
            mov $1, %edi              # file descriptor 1 (stdout)
            syscall
            dec %r13
            cmp $0, %r13
            jne print_loop_xor_2

        # Print space after imm using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x0 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x0(%rip), %rsi
        syscall

        # Print space after x0 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print add_funct3 from data section
        mov $3, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea add_funct3(%rip), %rsi
        syscall

        # Print space after funct3 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x1 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x1(%rip), %rsi
        syscall

        # Print space after x1 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print addi_opcode from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea addi_opcode(%rip), %rsi
        syscall

        # Print newline after opcode using newline in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea newline(%rip), %rsi
        syscall
        
        # #########
        xor %r12, %r8

        # Print xor_funct7 from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea xor_funct7(%rip), %rsi
        syscall

        # Print space after funct7 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x2 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x2(%rip), %rsi
        syscall

        # Print space after x2 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x1 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x1(%rip), %rsi
        syscall

        # Print space after x1 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print xor_funct3 from data section
        mov $3, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea xor_funct3(%rip), %rsi
        syscall

        # Print space after funct3 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x1 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x1(%rip), %rsi
        syscall

        # Print space after x1 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print xor_opcode from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea xor_opcode(%rip), %rsi
        syscall

        # Print newline after opcode using newline in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea newline(%rip), %rsi
        syscall

        push %r8
        inc %r15
        inc %r15
        jmp create_number

    op_and:
        # I type: imm(12) rs1(00000) funct3(000) rd opcode(0010011)
        # R type: funct7(0000000) rs2 rs1 funct3(000) rd opcode(0110011)

        pop %r12 # addi x2 x0 %r12 => rd = 00010 (I type)
        # Print immidiate
        # r13 loop counter   
        mov $12, %r13
        mov %r12, %rax
        binary_loop_and_1:
            mov $2, %rbx
            xor %rdx, %rdx
            div %rbx
	        add $48, %rdx
	        push %rdx
            dec %r13
            cmp $0, %r13
            jne binary_loop_and_1

        mov $12, %r13
        print_loop_and_1:
            pop %r14
            movb %r14b, print_byte
            lea print_byte(%rip), %rsi
            mov $1, %edx
            mov $1, %eax              # syscall number for sys_write
            mov $1, %edi              # file descriptor 1 (stdout)
            syscall
            dec %r13
            cmp $0, %r13
            jne print_loop_and_1

        # Print space after imm using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x0 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x0(%rip), %rsi
        syscall

        # Print space after x0 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print add_funct3 from data section
        mov $3, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea add_funct3(%rip), %rsi
        syscall

        # Print space after funct3 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x2 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x2(%rip), %rsi
        syscall

        # Print space after x2 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print addi opcode from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea addi_opcode(%rip), %rsi
        syscall

        # Print newline after opcode using newline in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea newline(%rip), %rsi
        syscall

        # #########
        pop %r8 # addi x1 x0 %r11 => rs1 = 00001 (I type)

        # Print immidiate
        # r13 loop counter   
        mov $12, %r13
        mov %r8, %rax
        binary_loop_and_2:
            mov $2, %rbx
            xor %rdx, %rdx
            div %rbx
	        add $48, %rdx
	        push %rdx
            dec %r13
            cmp $0, %r13
            jne binary_loop_and_2

        mov $12, %r13
        print_loop_and_2:
            pop %r14
            movb %r14b, print_byte
            lea print_byte(%rip), %rsi
            mov $1, %edx
            mov $1, %eax              # syscall number for sys_write
            mov $1, %edi              # file descriptor 1 (stdout)
            syscall
            dec %r13
            cmp $0, %r13
            jne print_loop_and_2

        # Print space after imm using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x0 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x0(%rip), %rsi
        syscall

        # Print space after x0 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print add_funct3 from data section
        mov $3, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea add_funct3(%rip), %rsi
        syscall

        # Print space after funct3 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x1 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x1(%rip), %rsi
        syscall

        # Print space after x1 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print addi_opcode from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea addi_opcode(%rip), %rsi
        syscall

        # Print newline after opcode using newline in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea newline(%rip), %rsi
        syscall
        
        # #########
        and %r12, %r8

        # Print xor_funct7 from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea and_funct7(%rip), %rsi
        syscall

        # Print space after funct7 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x2 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x2(%rip), %rsi
        syscall

        # Print space after x2 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x1 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x1(%rip), %rsi
        syscall

        # Print space after x1 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print xor_funct3 from data section
        mov $3, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea and_funct3(%rip), %rsi
        syscall

        # Print space after funct3 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x1 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x1(%rip), %rsi
        syscall

        # Print space after x1 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print xor_opcode from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea and_opcode(%rip), %rsi
        syscall

        # Print newline after opcode using newline in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea newline(%rip), %rsi
        syscall

        push %r8
        inc %r15
        inc %r15
        jmp create_number
    
    op_or:
        
        # I type: imm(12) rs1(00000) funct3(000) rd opcode(0010011)
        # R type: funct7(0000000) rs2 rs1 funct3(000) rd opcode(0110011)

        pop %r12 # addi x2 x0 %r12 => rd = 00010 (I type)
        # Print immidiate
        # r13 loop counter   
        mov $12, %r13
        mov %r12, %rax
        binary_loop_or_1:
            mov $2, %rbx
            xor %rdx, %rdx
            div %rbx
	        add $48, %rdx
	        push %rdx
            dec %r13
            cmp $0, %r13
            jne binary_loop_or_1

        mov $12, %r13
        print_loop_or_1:
            pop %r14
            movb %r14b, print_byte
            lea print_byte(%rip), %rsi
            mov $1, %edx
            mov $1, %eax              # syscall number for sys_write
            mov $1, %edi              # file descriptor 1 (stdout)
            syscall
            dec %r13
            cmp $0, %r13
            jne print_loop_or_1

        # Print space after imm using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x0 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x0(%rip), %rsi
        syscall

        # Print space after x0 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print add_funct3 from data section
        mov $3, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea add_funct3(%rip), %rsi
        syscall

        # Print space after funct3 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x2 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x2(%rip), %rsi
        syscall

        # Print space after x2 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print addi opcode from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea addi_opcode(%rip), %rsi
        syscall

        # Print newline after opcode using newline in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea newline(%rip), %rsi
        syscall

        # #########
        pop %r8 # addi x1 x0 %r11 => rs1 = 00001 (I type)

        # Print immidiate
        # r13 loop counter   
        mov $12, %r13
        mov %r8, %rax
        binary_loop_or_2:
            mov $2, %rbx
            xor %rdx, %rdx
            div %rbx
	        add $48, %rdx
	        push %rdx
            dec %r13
            cmp $0, %r13
            jne binary_loop_or_2

        mov $12, %r13
        print_loop_or_2:
            pop %r14
            movb %r14b, print_byte
            lea print_byte(%rip), %rsi
            mov $1, %edx
            mov $1, %eax              # syscall number for sys_write
            mov $1, %edi              # file descriptor 1 (stdout)
            syscall
            dec %r13
            cmp $0, %r13
            jne print_loop_or_2

        # Print space after imm using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x0 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x0(%rip), %rsi
        syscall

        # Print space after x0 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print add_funct3 from data section
        mov $3, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea add_funct3(%rip), %rsi
        syscall

        # Print space after funct3 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x1 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x1(%rip), %rsi
        syscall

        # Print space after x1 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print addi_opcode from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea addi_opcode(%rip), %rsi
        syscall

        # Print newline after opcode using newline in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea newline(%rip), %rsi
        syscall

        # #########
        or %r12, %r8
        # Print or_funct7 from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea or_funct7(%rip), %rsi
        syscall

        # Print space after funct7 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x2 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x2(%rip), %rsi
        syscall

        # Print space after x2 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x1 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x1(%rip), %rsi
        syscall

        # Print space after x1 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print or_funct3 from data section
        mov $3, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea or_funct3(%rip), %rsi
        syscall

        # Print space after funct3 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print x1 from data section
        mov $5, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea x1(%rip), %rsi
        syscall

        # Print space after x1 using space in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea space(%rip), %rsi
        syscall

        # Print or_opcode from data section
        mov $7, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea or_opcode(%rip), %rsi
        syscall

        # Print newline after opcode using newline in data section
        mov $1, %edx
        mov $1, %eax              # syscall number for sys_write
        mov $1, %edi              # file descriptor 1 (stdout)
        lea newline(%rip), %rsi
        syscall

        push %r8
        inc %r15
        inc %r15
        jmp create_number
    

print_func:
    # Assumes edx has size and rsi has address (popped from stack)
    mov $8, %edx
    mov $1, %eax              # syscall number for sys_write
    mov $1, %edi              # file descriptor 1 (stdout)
    syscall
    ret

exit_program:

    mov $60, %eax               # syscall number for sys_exit
    xor %edi, %edi              # exit code 0
    syscall


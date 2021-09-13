from pwn import *

ram = "2c 00 0c 00 07 00 ea 02 0d 00 06 ff 0d 01 06 fe 0d 02 06 fd 0d 03 06 fc 0d 04 06 fb 0d 05 06 fa 0d 06 06 f9 0d 07 06 f8 0d 08 06 f7 0d 09 06 f6 0d 0a 06 f5 0d 0b 06 f4 0d 0c 06 f3 0d 0d 06 f2 0d 0e 06 f1 0d 0f 06 f0 0d 10 06 ef 0d 11 06 ee 0d 12 06 ed 0d 13 06 ec 0d 14 06 eb 0d 15 06 ea 0d 16 06 e9 0d 17 06 e8 0d 18 06 e7 0d 19 06 e6 0d 1a 06 e5 0d 1b 06 e4 0d 1c 06 e3 0d 1d 06 e2 0d 1e 06 e1 0d 1f 06 e0"

r = remote("rev.chal.csaw.io", 5002)
print(r.recvuntil(b"WELCOME\n"))
r.sendline(ram)

r.recvuntil("ENT\\n")
flag = r.recvuntil("xx")
flag = flag.decode()[:-3].split()
flag = [ chr(int(c, 16)) for c in flag ]
print("".join(flag))

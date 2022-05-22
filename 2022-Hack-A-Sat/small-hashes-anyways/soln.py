import sys
import string
import random
from pwn import *

# Create an initial flag that is 114 characters long with the known flag prefix
flag = b"flag{november314425india3:".ljust(113, b"a") + b"}"
flag = bytearray(flag)

while True:
    p = process(["qemu-microblaze", "-L", "/opt/cross/microblaze-linux", "small_hashes_anyways"])
    p.recvline()

    print(f"Trying {flag}")
    p.sendline(flag)
    resp = p.recvline()
    print(resp)

    # If there is an incorrect value, choose a new random value to try at that reported index
    if b"mismatch" in resp:
        data = resp.split()

        # The response uses indices starting at 1 not 0
        index = int(data[1]) - 1
        flag[index] = ord(random.choice(string.ascii_letters + string.digits + string.punctuation))
    else:
        print(f"The flag is: {flag}")
        sys.exit(0)

    p.close()

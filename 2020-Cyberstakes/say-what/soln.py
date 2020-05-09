import binascii
import string
import base64

# Base64 decode the pasword and undo the reversing of the bytes
password = b"e3n3WxMt9w5Hcf0GE3XOCSMM/k4vHeIYg7ToHMu3+2I="
password = bytearray(base64.b64decode(password)[::-1])

# Xor is invertible by xoring with itself, so we copy the original function
# Take note of the zero-based indexing here versus in the macro itself
for i in range(1, len(password)):
    password[i - 1] = password[i - 1] ^ ((32 + i) % 256)

# Undo the individual character encodings
for i in range(len(password)):
    x = i % 4

    if x == 0:
        # Reswap the first and second characters
        m = password[i]
        password[i] = password[i + 1]
        password[i + 1] = m

        # Flipping the minus sign inverts the increment operation on the first character
        password[i] = ((password[i] + 104) + 256) % 256

    elif x == 3:
        # Reverse the xor first before inverting the previous character
        password[i] = password[i] ^ password[i - 1]

        # The multiply / divide operation is invertible by being repeated on the character
        password[i - 1] = (password[i - 1] * 16) % 256 + int(password[i - 1] / 16)

print(password)


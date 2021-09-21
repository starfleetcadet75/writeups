from z3 import *

def movsx(v):
    return ZeroExt(32 - 8, v)

def imul(a, b, c = None):
    if c is None:
        return a * b
    else:
        return b * c

def xor_(r, v):
    return r ^ v

def or_(r, v):
    return r | v

def mov(_, r2):
    return r2

def shr(r1, c):
    return LShR(r1, c)

def shl(r1, c):
    return r1 << c


def calc():
    esp_0x10 = BitVec("esp_0x10", 8)
    esp_0x11 = BitVec("esp_0x11", 8)
    esp_0x12 = BitVec("esp_0x12", 8)

    eax = BitVec("eax", 32)
    ebx = BitVec("ebx", 32)
    ecx = BitVec("ecx", 32)
    edx = BitVec("edx", 32)
    esi = BitVec("esi", 32)
    edi = BitVec("edi", 32)
    ebp = BitVec("ebp", 32)

    edi = movsx(esp_0x10)
    edx = imul(edx, edi, 0x3039)
    edx = xor_(edx, 0x93E6BBCF)
    ebx = imul(ebx, edi, 0x0AEDCE)
    ebx = xor_(ebx, 0x2ECBBAE2)
    ecx = imul(ecx, edi, 0x2EF8F)
    ecx = xor_(ecx, 0x0A0A2A282)
    edi = imul(edi, 0x0DEDC7)
    edi = xor_(edi, 0x9BDFE6F7)

    s = Solver()
    s.add(esi == 0xFFF4A1CE)
    s.add(ebx == 0xB5A4A9A7)
    s.add(ecx == 0xF05A945C)
    s.add(edx == 0x9504A82D)
    s.add(esp_0x10 >= 32, esp_0x10 <= 126)
    s.add(esp_0x11 >= 32, esp_0x11 <= 126)

    s.check()
    print(s.model())

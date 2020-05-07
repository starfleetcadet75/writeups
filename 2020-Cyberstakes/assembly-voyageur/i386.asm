BITS 32
SECTION .text
global main
main:
mov eax, 0x28cb958d
mov ebx, 0xb643052
mov ecx, 0x8e44508f
mov edx, 0x10231413
mov esi, 0xcbb6536f
mov edi, 0x4ab7291d
lea ecx, [esi+8*edx-3605]
sub esi, ebx
shr esi, 4
not edi
or ecx, ebx
andn ebx, edx, eax
rol edx, 8
and ecx, esi
je label_qwqthrijuy
mov edx, esi
label_qwqthrijuy:
lea eax, [ecx+3101]
lea esi, [ebx+4*ecx+1359]
shl ecx, 14
xor ebx, eax
sal ecx, 8
lea ecx, [edi+4*esi+1864]
add edi, edx
cmpxchg ebx, ecx
and edi, eax
shl eax, 6
andn edi, ebx, esi
and eax, 0x1f
sarx edi, edx, eax
rol esi, 11
shr esi, 12
lea ebx, [edx+8*eax-3202]
and ebx, 0x1f
shlx edi, edx, ebx
db 0xcc
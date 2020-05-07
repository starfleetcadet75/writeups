.global main
.text
main:
msub x2, x2, x3, x5
ubfx x2, x3, 10, 7
sub x2, x6, x4, LSR #7
sub x2, x3, x4, ASR #3
add x2, x4, x1, ASR #12
bfi x4, x2, 1, 16
add x6, x4, x2, LSL #8
sub x6, x1, x2, LSL #6
add x4, x3, x1, LSL #11
clz x3, x6
rev x5, x6
sub x2, x5, x4, LSL #15
eon x3, x1, x6
cbnz x2, label_tfuqxxauwf
mov x4, x6
label_tfuqxxauwf:
sub x2, x5, x6, LSL #16
clz x6, x5
add x1, x2, x6, LSR #13
mul x5, x1, x4
msub x1, x1, x2, x6
ubfx x1, x6, 15, 10
mneg x5, x6, x1
sub x4, x1, x2
sub x3, x1, x2, LSL #13
mneg x3, x1, x6
eon x6, x1, x2, LSR 15
sub x1, x5, x4, ASR #15
add x6, x3, x2
clz x1, x2
mov x2, x4, ROR #6
bfi x2, x4, 3, 2
madd x1, x2, x4, x1
orr x3, x5, x2
add x2, x3, x1, ASR #2
neg x1, x3
orr x2, x1, x4
msub x3, x3, x1, x5
eon x5, x4, x6, ASR 14
mov x5, x4, LSR #14
cls x4, x2
rbit x5, x1
mneg x6, x1, x2
cls x2, x1
mov x6, x3, ROR #10
rbit x3, x2
eon x1, x6, x3
madd x2, x6, x5, x2

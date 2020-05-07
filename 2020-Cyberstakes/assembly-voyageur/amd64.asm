BITS 64
SECTION .text
global main
main:
xor rsi, rdi
lea rcx, [rbx+2*rax-2074]
rorx rdi, rax, 11
xor rdx, rax
and rdi, 0x1f
sarx rdx, rbx, rdi
test rsi, rax
setz bl
sar rax, 4
ror rax, 7
dec rsi
and rsi, 0x1f
shlx rdx, rbx, rsi
or rbx, rax
and rcx, 0x1f1f
bextr rdi, rbx, rcx
and rax, 0x1f
shrx rdx, rdi, rax
shl rcx, 4
test rdi, rcx
setne al
lea rax, [rdi+4*rsi+3292]
and rcx, 0x1f
sarx rdx, rax, rcx
popcnt rcx, rsi
test rax, rdx
cmovne rcx, rax
bswap rax
sar rdx, 2
inc rax
and rcx, 0x1f1f
bextr rdx, rdi, rcx
cmp rax, rsi
jnz label_iabbhypsko
mov rdi, rsi
label_iabbhypsko:
and rsi, 0x1f
shlx rax, rcx, rsi
sub rdx, rbx
lea rcx, [rdi+2*rax-1854]
test rdi, rbx
cmovz rcx, rbx
ror rdi, 3
test rdx, rdi
cmovne rcx, rdx
lea rsi, [rdx+1863]
lea rdi, [rbx+4*rcx+1648]
shl rbx, 11
shl rdi, 10
test rdx, rdi
jnz label_xnleuwvlyx
mov rcx, rdi
label_xnleuwvlyx:
shl rdi, 11
xor rax, rcx
lea rdx, [rax+1234]
lea rbx, [rax+3561]
sal rsi, 6
andn rcx, rsi, rdx
test rbx, rcx
cmovne rdi, rbx
and rax, 0x1f
sarx rcx, rbx, rax
and rdx, 0x1f
shlx rsi, rdi, rdx
mul rsi
and rdx, 0x1f1f
bextr rax, rbx, rdx
inc rax
sar rax, 8
xor rax, rcx
and rcx, 0x1f
sarx rdi, rsi, rcx
db 0xcc
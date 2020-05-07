.PHONY : all
all: i368 amd64 aarch64 mips ppc

i386: i386.asm
	nasm -f elf32 i386.asm -o i386.o
	gcc i386.o -m32 -o i386.bin -static

amd64: amd64.asm
	nasm -f elf64 amd64.asm -o amd64.o
	gcc amd64.o -o amd64.bin -static

aarch64: aarch64.asm
	aarch64-linux-gnu-as aarch64.asm -o aarch64.o
	aarch64-linux-gnu-gcc aarch64.o -o aarch64.bin -static

mips: mips.S
	mips-linux-gnu-gcc mips.S -o mips.bin -static

ppc: ppc.asm
	powerpc-linux-gnu-as ppc.asm -mregnames -o ppc.o
	powerpc-linux-gnu-gcc ppc.o -o ppc.bin -static

clean:
	rm -rf *.o *.bin

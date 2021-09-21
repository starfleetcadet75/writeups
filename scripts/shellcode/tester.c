// Useful for testing raw shellcode
// cat shellcode | ./tester
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>

int main(int argc, char** argv) {
    // Create a page of memory to place the shellcode in
    void* page = mmap(0x1337000, 0x1000, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_ANON, 0, 0);

    // Read the shellcode from stdin
    read(0, page, 0x1000);

    // Call the start of the shellcode
    ((void(*)())page)();

    return 0;
}


#define _GNU_SOURCE

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <dlfcn.h>
#include <string.h>
#include <signal.h>
#include "logging.h"

// Compile with: make ARCH=i386

struct user_regs_struct {
    int32_t ebx;
    int32_t ecx;
    int32_t edx;
    int32_t esi;
    int32_t edi;
    int32_t ebp;
    int32_t eax;
    int32_t xds;
    int32_t xes;
    int32_t xfs;
    int32_t xgs;
    int32_t orig_eax;
    int32_t eip;
    int32_t xcs;
    int32_t eflags;
    int32_t esp;
    int32_t xss;
};

void hexdump(const void* data, size_t size) {
    char ascii[17];
    size_t i, j;
    ascii[16] = '\0';

    for (i = 0; i < size; ++i) {
        printf("%02X ", ((unsigned char*)data)[i]);
        if (((unsigned char*)data)[i] >= ' ' && ((unsigned char*)data)[i] <= '~') {
            ascii[i % 16] = ((unsigned char*)data)[i];
        } else {
            ascii[i % 16] = '.';
        }
        if ((i+1) % 8 == 0 || i+1 == size) {
            printf(" ");
            if ((i+1) % 16 == 0) {
                printf("|  %s \n", ascii);
            } else if (i+1 == size) {
                ascii[(i+1) % 16] = '\0';
                if ((i+1) % 16 <= 8) {
                    printf(" ");
                }
                for (j = (i+1) % 16; j < 16; ++j) {
                    printf("   ");
                }
                printf("|  %s \n", ascii);
            }
        }
    }
}

FILE *(*original_fopen)(const char *pathname, const char *mode);
size_t (*original_strlen)(const char *s);
int (*original_strncmp)(const char *s1, const char *s2, size_t n);
int (*original_execve)(const char *pathname, char *const argv[], char *const envp[]);
int (*original_kill)(pid_t pid, int sig);
int (*original_memcmp)(const void *s1, const void *s2, size_t n);
int (*original_chmod)(const char *pathname, mode_t mode);
int (*original_nice)(int inc);
long (*original_ptrace)(long request, pid_t pid, void *addr, void *data);
int (*original_pivot_root)(const char *new_root, const char *put_old);
//void (*original_free)(void *);
//void *(*original_malloc)(size_t);
void *(*original_memcpy)(void *dest, const void *src, size_t n);
int (*original_truncate)(const char *path, off_t length);

__attribute__((constructor)) void preeny_hook_orig() {
    original_fopen = dlsym(RTLD_NEXT, "fopen");
    original_strlen = dlsym(RTLD_NEXT, "strlen");
    original_strncmp = dlsym(RTLD_NEXT, "strncmp");
    original_execve = dlsym(RTLD_NEXT, "execve");
    original_kill = dlsym(RTLD_NEXT, "kill");
    original_memcmp = dlsym(RTLD_NEXT, "memcmp");
    original_chmod = dlsym(RTLD_NEXT, "chmod");
    original_nice = dlsym(RTLD_NEXT, "nice");
    original_ptrace = dlsym(RTLD_NEXT, "ptrace");
    original_pivot_root = dlsym(RTLD_NEXT, "pivot_root");
    //original_free = dlsym(RTLD_NEXT, "free");
    //original_malloc = dlsym(RTLD_NEXT, "malloc");
    original_memcpy = dlsym(RTLD_NEXT, "memcpy");
    original_truncate = dlsym(RTLD_NEXT, "truncate");
}

FILE *fopen(const char *pathname, const char *mode) {
    if(!original_fopen)
        preeny_hook_orig();

    preeny_info("fopening %s\n", pathname);
    return original_fopen(pathname, mode);
}

size_t strlen(const char *s) {
    if(!original_strlen)
        preeny_hook_orig();

    preeny_info("strlengthing %s\n", s);
    return original_strlen(s);
}

int strncmp(const char *s1, const char *s2, size_t n) {
    if(!original_strncmp)
        preeny_hook_orig();

    preeny_info("strncmping %s with %s\n", s1, s2);
    return original_strncmp(s1, s2, n);
}

int execve(const char *pathname, char *const argv[], char *const envp[]) {
    if(!original_execve)
        preeny_hook_orig();

    int retval = original_execve(pathname, argv, envp);
    preeny_info("execve %s = %d\n", pathname, retval);
    return retval;
}

int kill(pid_t pid, int sig) {
    if(!original_kill)
        preeny_hook_orig();

    preeny_info("killing %d with %d\n", pid, sig);
    return original_kill(pid, sig);
}

int memcmp(const void *s1, const void *s2, size_t n) {
    if(!original_memcmp)
        preeny_hook_orig();

    preeny_info("memcmp %s with %s\n", s1, s2);
    hexdump(s2, 10);
    return original_memcmp(s1, s2, n);
}

int chmod(const char *pathname, mode_t mode) {
    if(!original_chmod)
        preeny_hook_orig();

    preeny_info("chmod %s\n", pathname);
    return original_chmod(pathname, mode);
}

int nice(int inc) {
    if(!original_nice)
        preeny_hook_orig();

    int retval = original_nice(inc);
    preeny_info("nice %d = %d\n", inc, retval);
    return retval;
}

long ptrace(long request, pid_t pid, void *addr, void *data) {
    int retval = original_ptrace(request, pid, addr, data);
    char* req = NULL;

    switch (request) {
        case 0:
            req = "TRACEME";
	    break;
	case 1:
            req = "PEEKTEXT";
	    break;
	case 2:
            req = "PEEKDATA";
	    break;
	case 3:
            req = "PEEKUSER";
	    break;
	case 4:
            req = "POKETEXT";
	    break;
	case 5:
            req = "POKEDATA";
	    break;
	case 6:
            req = "POKEUSER";
	    break;
	case 7:
            req = "CONT";
	    break;
	case 8:
            req = "KILL";
	    break;
	case 9:
            req = "SINGLESTEP";
	    break;
	case 10:
            req = "ATTACH";
	    break;
	case 11:
            req = "DETACH";
	    break;
	case 12:
            req = "GETREGS";
            struct user_regs_struct* regs = (struct user_regs_struct*) data;
	    //preeny_info("esp = %x\n", regs->esp);
	    //preeny_info("orig_eax = %x\n", regs->orig_eax);
	    preeny_info("eip = %x\n", regs->eip);
	    preeny_info("opcode = %x\n", (regs->orig_eax ^ 0xdeadbeef) * 0x1337cafe);
	    //int arg1 = original_ptrace(2, pid, regs->esp + 4, 0);
	    //preeny_info("arg1 = %x\n", arg1);
	    break;
	case 13:
            req = "SETREGS";
	    break;
	case 24:
            req = "SYSCALL";
	    break;
	case 31:
            req = "SYSEMU";
	    break;
	default:
	    req = "UNKNOWN";
	    break;
    }

    preeny_info("ptrace request:%s pid:%d addr:%x data:%x retval:%x\n", req, pid, addr, data, retval);
    return retval;
}

int pivot_root(const char *new_root, const char *put_old) {
    if(!original_pivot_root)
        preeny_hook_orig();

    preeny_info("pivot_root %s to %s\n", put_old, new_root);
    return original_pivot_root(new_root, put_old);
}

//void free(void *ptr) {
//    if(!original_free)
//	preeny_hook_orig();
//
//    preeny_info("free(%p)\n", ptr);
//    hexdump(ptr, 50);
//    preeny_info("\n]\n\n");
//    original_free(ptr);
//}

//void *malloc(size_t size) {
//    if(!original_malloc)
//        preeny_hook_orig();
//
//    void *r = original_malloc(size);
//    preeny_info("malloc(%d) == %p\n", size, r);
//    return r;
//}

void *memcpy(void *dest, const void *src, size_t n) {
    if(!original_memcpy)
        preeny_hook_orig();

    preeny_info("memcpy %p to %p (%d bytes)\n", src, dest, n);
    hexdump(src, n);
    return original_memcpy(dest, src, n);
}

int truncate(const char *path, off_t length) {
    if(!original_truncate)
        preeny_hook_orig();

    preeny_info("truncate %s %d\n", path, length);
    return original_truncate(path, length);
}


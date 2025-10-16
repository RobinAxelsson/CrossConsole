// no_libc.c  — build with:  gcc -nostdlib -static -s no_libc.c -o no_libc
// No includes, no libc. Direct syscalls via inline asm.

typedef __INTPTR_TYPE__ iptr;   // pointer-sized signed int (works with GCC/Clang)
typedef __UINTPTR_TYPE__ uptr;

enum { 
    SYS_write = 1, 
    SYS_exit = 60 
}; // x86-64 syscall numbers

static inline long print(const char *buf, long len) {
    long ret;

    __asm__ volatile (
        "syscall"
        : "=a"(ret)
        : "a"((long)SYS_write), "D"(1), "S"(buf), "d"(len)
        : "rcx", "r11", "memory"
    );
    return ret;
}

static inline void exit(long code) {
    __asm__ volatile (
        "syscall"
        :
        : "a"((long)SYS_exit), "D"(code)
        : "rcx", "r11", "memory"
    );
    
    __builtin_trap();
}

// Real ELF entry point. Kernel jumps here; there is no main().
void _start(void) {
    static const char msg[] = "Hello, Linux (no libc, C)\n";
    print(msg, (long)(sizeof(msg) - 1));
    print(msg, (long)(sizeof(msg) - 1));
    exit(0);
}
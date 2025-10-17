#include <windows.h>
#include <intrin.h>
#pragma intrinsic(__readgsqword)
#pragma comment(linker, "/SUBSYSTEM:CONSOLE")
#pragma comment(linker, "/ENTRY:Entry")

static void print(const void *ptr, int len)
{
    HANDLE h = GetStdHandle(STD_OUTPUT_HANDLE);
    DWORD written = 0;
    WriteFile(h, ptr, (DWORD)len, &written, NULL);
}

void __stdcall Entry(void)
{
    const char msg[] = "Win32, no CLR\r\n";
    print(msg, sizeof(msg)-1);
    print(msg, sizeof(msg)-1);
    print(msg, sizeof(msg)-1);
    
    LPVOID ptr0 = VirtualAlloc(0, 10240, MEM_COMMIT, PAGE_READWRITE);
    LPVOID ptr1 = VirtualAlloc(0, 10240, MEM_COMMIT, PAGE_READWRITE);
    LPVOID ptr2 = VirtualAlloc(0, 10240, MEM_COMMIT, PAGE_READWRITE);
    LPVOID ptr3 = VirtualAlloc(0, 10240, MEM_COMMIT, PAGE_READWRITE);
    LPVOID ptr4 = VirtualAlloc(0, 10240, MEM_COMMIT, PAGE_READWRITE);
    void *ptr = (void*)__readgsqword(0x30);

    struct _TEB *teb = NtCurrentTeb();

    for (;;) {
        Sleep(1000);
    }

    ExitProcess(0);
}
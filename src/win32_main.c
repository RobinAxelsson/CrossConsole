#include <windows.h>
#include <intrin.h>

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

    //PVOID peb = (PVOID)__readgsqword(0x60);

    ExitProcess(0);
}
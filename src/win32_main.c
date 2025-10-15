#include <windows.h>

#pragma comment(linker, "/SUBSYSTEM:CONSOLE")
#pragma comment(linker, "/ENTRY:Entry")

void __stdcall Entry(void)
{
    HANDLE h = GetStdHandle(STD_OUTPUT_HANDLE);
    const char msg[] = "Win32, no CLR\r\n";
    DWORD written = 0;
    WriteFile(h, msg, (DWORD)(sizeof(msg) - 1), &written, NULL);
    ExitProcess(0);
}
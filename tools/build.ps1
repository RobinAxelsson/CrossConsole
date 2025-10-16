#!/usr/bin/env pwsh

Push-Location $PSScriptRoot > $null
Set-Location ..
Remove-Item -Recurse -Force "bin" -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force "bin" | Out-Null
Set-Location "bin"

if ($IsWindows) {
    # Compile with assembly LISTING for inspection (not assemble-able)
    cl /nologo /TC /c /Zi /W4 /GS- /FC /FAs /Fa ..\src\win32_main.c

    link /nologo /DEBUG /PDB:win32_main.pdb /NODEFAULTLIB /SUBSYSTEM:CONSOLE /ENTRY:Entry .\win32_main.obj kernel32.lib
}
else {
    # 1. Preprocess .i
    gcc -std=c99 -Wall -Wextra -g -O0 -fno-pie -fno-stack-protector -Wno-unused-label -fno-builtin -nostdlib -E -o linux_main.i ../src/linux_main.c

    # 2. Compile: C → Assembly .s
    gcc -std=c99 -Wall -Wextra -g -O0 -fno-pie -fno-stack-protector -Wno-unused-label -fno-builtin -masm=intel -nostdlib -S -o linux_main.s linux_main.i

    # 3. Assemble: Assembly → Object
    as -o linux_main.o linux_main.s

    # 4. Link: Object → Executable
    ld -static -nostdlib -no-pie -e _start -o linux_main linux_main.o

    # 5. Optional: Disassemble final ELF (Intel syntax)
    objdump -M intel -d linux_main > linux_main_dump.s
}

Pop-Location > $null

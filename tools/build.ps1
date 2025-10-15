#!/usr/bin/env pwsh

Push-Location $PSScriptRoot > $null
Set-Location ..
Remove-Item -Recurse -Force out -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force out | Out-Null
Set-Location out
Write-Host "TEST"
if ($IsWindows) {
    "Compiling win32..."
    cl /nologo /TC /FC /FAs -Zi /W4 /GS- /c ..\src\win32_main.c
    link /nologo /DEBUG /PDB:win32_main.pdb /NODEFAULTLIB /SUBSYSTEM:CONSOLE /ENTRY:Entry .\win32_main.obj kernel32.lib
}
else {
    "Compiling for linux..."
    exit 0
    gcc -std=c99 -Wall -Wextra -O2 ../src/linux_main.c -o linux_main
}
Pop-Location > $null

#!/usr/bin/env pwsh

Push-Location $PSScriptRoot > $null
Set-Location ..
Remove-Item -Recurse -Force "bin" -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force "bin" | Out-Null
Set-Location "bin"

if ($IsWindows) {
    ml64 /c /Fo win32_masm.o ../src/win32_masm.s

    #does not give much output - maybe because it is copied
    link win32_masm.o /OUT:win32_main.exe /ENTRY:main kernel32.lib
}
else {
  echo "No linux asm implimented"
}

Pop-Location > $null

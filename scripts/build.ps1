#!/usr/bin/env pwsh

Push-Location $PSScriptRoot > $null
Set-Location ..
Remove-Item -Recurse -Force "bin" -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force "bin" | Out-Null
Set-Location "bin"

if ($IsWindows) {
    New-Item -ItemType Directory -Force "obj" | Out-Null

    Set-Location obj
    $clArgs = @(
        '/nologo'
        '/TC'             # treat as C source
        '/c'
        '/Zi'             # debug info
        '/W4'
        '/GS-'
        '/FC'
        '/FAs'
        '/Fa'
        '..\..\src\win32_main.c' # example - adapt as necessary
    )

    cl @clArgs

    Set-Location ..
    $linkArgs = @(
        '/nologo'
        '/DEBUG'
        '/PDB:win32_main.pdb'
        '/NODEFAULTLIB'
        '/SUBSYSTEM:CONSOLE'
        '/ENTRY:Entry'
        '.\obj\win32_main.obj'
        'kernel32.lib'
    )

    link @linkArgs
}
else {
    # Common flags reused for gcc
    $commonCFlags = @(
        '-std=c99'
        '-Wall'
        '-Wextra'
        '-g'
        '-O0'
        '-fno-pie'
        '-fno-stack-protector'
        '-Wno-unused-label'
        '-fno-builtin'
        '-nostdlib'
    )

    # 1. Preprocess .i
    $preArgs = $commonCFlags + @(
        '-E'
        '-o', 'linux_main.i'
        '../src/linux_main.c'
    )
    & gcc @preArgs

    # 2. Compile: C → Assembly .s
    $compileArgs = $commonCFlags + @(
        '-masm=intel'
        '-S'
        '-o', 'linux_main.s'
        'linux_main.i'
    )
    & gcc @compileArgs

    # 3. Assemble: Assembly → Object
    $asArgs = @(
        '-o', 'linux_main.o'
        'linux_main.s'
    )
    & as @asArgs

    # 4. Link: Object → Executable
    $ldArgs = @(
        '-static'
        '-nostdlib'
        '-no-pie'
        '-e', '_start'
        '-o', 'linux_main'
        'linux_main.o'
    )
    & ld @ldArgs

    # 5. Optional: Disassemble final ELF (Intel syntax)
    $objdumpArgs = @(
        '-M', 'intel'
        '-d'
        'linux_main'
    )

    $text = & objdump @objdumpArgs
    $text | Out-File -Encoding ASCII linux_main_dump.s
}

Pop-Location > $null

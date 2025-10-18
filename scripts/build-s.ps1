#!/usr/bin/env pwsh

Push-Location $PSScriptRoot > $null
Set-Location ..
Remove-Item -Recurse -Force "bin" -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force "bin" | Out-Null
Set-Location "bin"

if ($IsWindows) {                    # Only run this block on Windows hosts

    # --- ASSEMBLE (ml64) ---
    $mlArgs = @(
        "/c"                        # Compile only (produce .obj, do not link)
        "/Zi"                       # Generate debug information (for PDB)
        "/W3"                       # Enable level 3 warnings (default and useful)
        "/Fl:win32_masm.lst"        # Produce a listing file with source + assembly
        "/Sa"                       # Include source code in the listing file
        "/Fo" 
        "win32_masm.o"
        "../src/win32_masm.s"
    )
    ml64 @mlArgs                    # Run the assembler with the above arguments

    # --- LINK ---
    $linkArgs = @(
        "win32_masm.o"
        "/OUT:win32_main.exe"
        "/ENTRY:main"               # Specify entry point symbol
        "/SUBSYSTEM:CONSOLE"        # Build a console application
        "/DEBUG:FULL"               # Generate full debug info (rich PDB, best for stepping)
        "/PDB:win32_main.pdb"       # Name of the PDB file (debug symbols)
        "/MAP:win32_main.map"       # Generate a .map file (address-to-symbol lookup)
        "/VERBOSE:LIB"              # Show how libraries and symbols are resolved
        "/INCREMENTAL:NO"           # Disable incremental linking (cleaner addresses)
        "kernel32.lib"              # Link against kernel32 (Win32 API)
    )
    link @linkArgs                  # Run the linker with the above arguments

    Write-Host "Built win32_main.exe with symbols (win32_main.pdb) and map (win32_main.map)."  # Status message
}
else {

    $nasmArgs = @(
        "-felf64"
        "../src/linux_nasm.s"
        "-o"
        "linux_nasm.o"
    )
    nasm @nasmArgs

    $ldArgs = @(
        "-static"
        "-0"
        "linux_main"
        "linux_nasm.0"
    )

    ld @ldArgs
}

Pop-Location > $null

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
        "-felf64"              # output format: 64-bit ELF object
        "../src/linux_nasm.s"  # input file
        "-o", "linux_nasm.o"   # output object file
        "-g"                   # generate dwarf debug info (NASM built-in)
        "-F", "dwarf"          # explicitly specify DWARF debug format
        "-w+all"               # enable all warnings
        "-w-number-overflow"   # warn on numeric overflow

        #"-w+error"            # treat warnings as errors
        #"-dDEBUG"             # example macro definition (like -D in C)
        #"-l", "listing.lst"   # generate assembly listing
    )

    nasm @nasmArgs

    $ldArgs = @(
        "-static"              # link statically (no external libs)
        #"--strip-debug"       # strip debug symbols
        "-o", "linux_main"     # output executable
        "linux_nasm.o"         # object file to link

        #"-e", "_start"        # set entry point explicitly (if name differs)
        "-Map=output.map"      # generate map file DEBUG
        #"-z", "noexecstack"   # mark stack as non-executable (security)
        #"--gc-sections"       # remove unused sections (smaller binary)
        #"-pie"                # build position-independent executable (requires fPIC)
        #"-s"                  # strip ALL symbols (tiny binary, NO DEBUG!)
    )
    
    ld @ldArgs
}

Pop-Location > $null

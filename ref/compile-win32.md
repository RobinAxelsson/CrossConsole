# Compiler and linker flags

## COMPILER
---
# === Input / Output control ===
/c                 Compile only (no link)
/Fo<file|dir>      Object file name or output directory
/Fa[<file|dir>]    Assembly listing (.asm)
/Fd<file>          PDB file name
/Fe<file>          Executable name (when linking)
/FC                Show full source paths in diagnostics
/Fi<file>          Preprocessed output file
/Fp<file>          Name of precompiled header
/Fu<file>          Force use of precompiled header
/Zi                Create debug info (PDB)
/Z7                Embed debug info in .obj (old style)
/Zl                Omit default library names from .obj
/nologo            Suppress banner
/EP                Preprocess to stdout (no #line)
/P                 Preprocess to file (.i)
/MP                Multi-threaded compile
/I <dir>           Add include directory

# === Code generation / optimization ===
/O1                Optimize for size
/O2                Optimize for speed
/Od                Disable optimization
/Ox                Maximum optimization (no link-time)
/Oi                Generate intrinsic functions
/Og                Enable global optimizations
/Ob0,1,2           Inline expansion (none, default, aggressive)
/Ot,Os             Favor fast code or small code
/GF                Pool string literals
/Gy                Separate functions for linker (COMDAT)
/GL                Whole program optimization (requires /LTCG)
/arch:<SSE2|AVX|AVX2|...>  Set instruction set
/Gs                Disable stack probes
/GS-               Disable buffer security check
/GF-               Disable string pooling
/fp:<precise|fast|strict>  Floating-point behavior
/Qpar              Enable automatic parallelization
/volatile:<iso|ms> Volatile semantics

# === Warnings / diagnostics ===
/W0–4              Warning level
/WX                Treat warnings as errors
/wd<number>        Disable warning
/we<number>        Treat as error
/Wall              Enable all warnings
/analyze           Static code analysis
/Za                Disable language extensions
/Zc:<option>       Conformance options (e.g., /Zc:forScope)
/diagnostics:<column|caret>  Enhanced output formatting

# === Language / standard ===
/std:c89
/std:c99
/std:c11
/std:c17
/std:c++14 /std:c++17 /std:c++20 /std:c++latest
/TP                Treat all files as C++
/TC                Treat all files as C
/EHsc              Enable C++ exceptions (scoped)
/EHs, /EHa         Exception handling variants
/RTC1, /RTCs, /RTCu  Run-time checks (debug)

# === Preprocessor / defines ===
/D<name>[=<value>] Define symbol
/U<name>           Undefine symbol
/FI<file>          Force include file

# === Runtime / linking model ===
/MD, /MDd          Link against multithreaded DLL CRT
/MT, /MTd          Link against static CRT
/LD, /LDd          Create DLL
/GS                Enable security checks
/guard:cf          Enable Control Flow Guard
/GR-, /GR          Disable/enable RTTI (C++)
/clr               Enable .NET compilation

# === Output info ===
/FA, /FAc, /FAs, /FAcs  Assembly listing formats
/Fd                 Name of PDB file
/FR, /Fr           Source browser database (.sbr)
/showIncludes      Print included headers

# === Misc ===
/link <opts>       Pass options to linker
/?                 Show help for cl.exe

---

## LINKER

# === Input / Output ===
/OUT:<file>          Output executable or DLL name
/IMPLIB:<file>       Import library name (for DLLs)
/DEF:<file>          Module definition (.def) file
/PDB:<file>          Program database (debug info)
/MAP[:file]          Generate map file
/MAPINFO:EXPORTS     Include exports in map file
/NODEFAULTLIB        Ignore default libraries
/NOLOGO              Suppress banner
/VERBOSE             Show link progress
/LIBPATH:<dir>       Add library search directory

# === Subsystem / entry ===
/SUBSYSTEM:<CONSOLE|WINDOWS|NATIVE|EFI_APPLICATION|...> [,major.minor]
/ENTRY:<symbol>      Define entry point (e.g. Entry, mainCRTStartup)
/DRIVER[:UPONLY|WDM] For kernel-mode drivers
/ALIGN:<n>           Section alignment
/BASE:<addr>         Preferred load address
/DLL                 Create DLL
/EXE                 Create EXE (default)
/INCREMENTAL[:NO]    Enable/disable incremental link

# === Debug / symbols ===
/DEBUG[:FULL|FASTLINK]  Generate debug info
/DEBUGTYPE:{CV,COFF}    Debug format
/PDBSTRIPPED:<file>     Create stripped PDB
/INCLUDE:<symbol>       Force symbol inclusion
/IGNORE:<n>             Suppress specific linker warning
/LTCG[:NOSTATUS]        Link-time code generation (with /GL)
/PROFILE                Instrument for profiling
/RELEASE                Set checksum and strip debug info

# === Optimization / code generation ===
/OPT:REF               Eliminate unreferenced functions/data
/OPT:ICF               Identical COMDAT folding
/OPT:NOREF, /OPT:NOICF Disable those optimizations
/SAFESEH[:NO]          Register SEH handlers
/SAFESEH               Required for x86 CFG
/ORDER:@file           Control function order
/INCLUDE               Force include of symbol

# === Address space / memory ===
/STACK:reserve[,commit] Stack size
/HEAP:reserve[,commit]  Heap size
/FIXED                 No relocation
/DYNAMICBASE[:NO]      ASLR (Address Space Layout Randomization)
/HIGHENTROPYVA[:NO]    64-bit ASLR entropy
/LARGEADDRESSAWARE[:NO]  >2GB address space

# === Compatibility / manifest ===
/MANIFEST[:NO]         Embed manifest
/MANIFESTUAC:"level='asInvoker' uiAccess='false'"
/MANIFESTDEPENDENCY:"..."   Custom manifest dependency
/ALLOWISOLATION[:NO]   Isolation support
/VERBOSE:LIB           Show libraries searched

# === Import / export ===
/EXPORT:<name>[,@ordinal[,NONAME]][,DATA]
/IMPLIB:<file>         Output import library
/DEF:<file>            Definition file (exports)

/DELAYSIGN[:NO]        Delay-sign assembly
/DELAYLOAD:<dll>       Delay-load DLL
/DELAY:UNLOAD          Enable delay-unload

# === Misc ===
/SECTION:<name>,<attrs>  Override section attributes
/ALIGN:<n>               Section alignment
/RELEASE                 Remove debug info, add checksum
/NOENTRY                 For resource-only DLLs
/VERSION:<major[.minor]> Set PE version
/?                       Help for link.exe

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CWorld is a low-level Windows graphics application written in C, implementing direct pixel manipulation and basic 2D graphics rendering using the Win32 API. The project follows a handmade/game programming approach with manual memory management and direct Windows API interaction.

## Build System

The project uses PowerShell scripts and MSVC (Microsoft Visual C++ compiler) for building:

## Architecture

### Core Structure

The application is a single-file Windows application (`src/main.c`) that implements:

1. **Manual memory management**: Uses `VirtualAlloc`/`VirtualFree` for back buffer
2. **Direct rendering pipeline**:
   - Back buffer (`win32_offscreen_buffer`) stores 32-bit RGBA pixels
   - Custom software rendering functions write directly to pixel memory
   - `StretchDIBits` blits the back buffer to the window
3. **Message loop**: Standard Win32 event handling with `PeekMessage`/`DispatchMessage`
4. **Real-time rendering**: Continuous rendering with `InvalidateRect` + `Sleep(1)`


## Code Style

The project follows conventions documented in `ref/c_naming_conventions.md`:

- **Naming**: snake_case for functions/variables, optional module prefixes (`win32_`, `render_`)
- **Types**: Custom fixed-width typedefs (`int32`, `uint8`, etc.) defined in `main.c:9-17`
- **Structs**: Uses `typedef struct { ... } name` pattern
- **Globals**: Prefixed with `g_` (e.g., `g_back_buffer`, `g_running`)
- **Static**: File-local functions/globals use `static`
- **Constants**: ALL_CAPS defines (e.g., `BlackPixel`, `WhitePixel`)
- **Platform specific code** follows platform naming conventions - In Win32 code we follow the win32 convention

## Development Context

- The project references Handmade Hero (see `handmade-hero/*` comments by Casey Muratori)

## Claude Knowledge context

You are an expert senior C programmer and software engineer.
You are an expert assembly programmer
You support me in writing, debugging and reasoning about C code and low level programming.

You are fluent in Windows APIs and Linux/POSIX and can help port code between them.

Principles

Prefer simple, robust designs over clever complexity.
Favor early C standards (C89/C99). If you suggest newer features, note portable fallbacks.
Expand acronyms (spell out first use) and explain in plain language.
Compare C concepts and examples with C# and, where useful, small assembly snippets.
Embrace a pragmatic, data-oriented, simple-first mindset (à la Eskil Steenberg, Casey Muratori, John Carmack and Linus Torvalds).
Dont favour libraries (even the C standard library) prefer handmade code
Optimize for code that compiles on real compilers, not just committee-perfect edge cases.
When opinions matter, present at least one seasoned alternative and its trade-offs.

Answer Flow (flexible guidance)

Start with a brief orientation if it helps; include a minimal C89/C99 example when code clarifies the idea. Call out Windows vs. Linux differences only when they matter.
Use C# comparisons and a tiny assembly peek when that adds clarity.
Include safety notes (memory/threading/undefined behavior) and likely pitfalls as appropriate.
Offer alternatives with succinct pros/cons when there are real trade-offs.
Suggest simple tests or debugging tips when useful.

Communication

If something is ambiguous, ask one or two focused questions;
otherwise make reasonable assumptions and proceed.
When I share code, comment inside it, pointing out bugs, UB (undefined behavior), and readability issues.
Assume that parts of the code is more likely to produce bugs
Always provide pros and cons.

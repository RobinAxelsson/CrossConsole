# Concise C Conventions (Linux kernel × Eskil)

> A tight, pragmatic set you can paste into a repo as `STYLE.md`.

## Naming
- **snake_case everywhere** (files, functions, vars, struct members). Keep names short but clear.
- **Module prefix** for public symbols: `renderer_draw()`, `fs_open()`. File‑static helpers can drop the prefix.
- **Struct tags**: `struct span { int xmin, xmax; };` (no typedef by default).
- **Typedef only** for opaque/public handles or math vectors: `typedef struct renderer renderer_t;`, `typedef struct { float x,y,z; } vec3;`.
- **Enums/Macros**: ALL_CAPS, optional module prefix: `RENDERER_MAX_SPAN`, `SPAN_SOLID`.
- **Globals**: prefer file‑static over true globals. Optional prefixes: `s_` (file static), `g_` (exported). Example: `static int s_running;`.
- **Units in names**: `time_ms`, `width_px`, `angle_deg`, `bytes`.
- **Acronyms lowercase**: `http_client`, `id_map` (not `HTTPClient`).

## Files & Layout
- **Files**: one subsystem per `.c` file: `renderer.c`, `audio_mix.c`. Headers mirror: `renderer.h`.
- **Header guards**: `#ifndef RENDERER_H` or `PROJECT_RENDERER_H`. No `#pragma once` requirement.
- **Public API**: keep small; expose functions + opaque types only.

## Functions
- Verb + object: `renderer_init`, `renderer_shutdown`, `renderer_draw_span`.
- Return `int` for errors (`0` success, `-errno` on failure). Void only when it can’t fail.
- Pass large structs by `const *`. Small POD (plain old data) structs may be by value.
- Don’t hide allocation in `init()` unless documented as owning allocator.

## Structs & Data
- Prefer **plain structs** over clever abstractions.
- Order fields for cache locality and alignment (hot fields first). Avoid padding surprises.
- Document ownership in comments for pointer members: `/* owns */`, `/* borrows */`, `/* weak */`.

## Constants & Macros
- Compile‑time constants: `#define MAX_FOO 64` or `enum { MAX_FOO = 64 };` (use `enum` when a type is helpful).
- Typed constants in C99 modules: `static const int k_chunk = 4096;` (prefix `k_` optional).
- Macros are ALL_CAPS and parenthesize args: `#define ALIGN4(x) (((x)+3)&~3)`.

## Booleans & Types
- C99: `#include <stdbool.h>` and use `bool`.
- C89 fallback: `typedef int bool; #define true 1 #define false 0`.
- Avoid `_t` suffix unless it’s an opaque/public handle; POSIX reserves many `_t` names.
- Fixed widths when crossing boundaries: `<stdint.h>` types (`uint32_t`). Internally, prefer native `int/size_t` unless you need size guarantees.

## Error Handling
- Return `-errno` style codes; don’t print in library code. Caller decides logging.
- Validate inputs at API boundaries; assert internal invariants.
- Never crash on user data; prefer graceful failure paths.

## Memory & Ownership
- Creator frees unless API says otherwise (`create/destroy`, `init/clear`).
- Use `free(NULL)` safe behavior; set pointers to `NULL` after free.
- For arenas/pools, document lifetime and thread rules.

## Threading
- Non‑thread‑safe by default; use `*_mt` variants or document required external locking.
- Keep shared state minimal; prefer passing state structs (`context`) explicitly.

## Formatting (brief)
- K&R braces, tabs or 4 spaces—pick one project‑wide. Linux kernel uses tabs (8 cols).
- `type *p` (asterisk hugs the name). One declaration per line. Max line ≈ 100 cols.
- `static inline` for header helpers.

## Includes
- Order: own header first, then local, then system:
  ```c
  #include "renderer.h"
  #include "util/array.h"
  #include <stdio.h>
  #include <string.h>
  ```
- Headers must be self‑contained (compile on their own when included first).

## Comments & Docs
- Explain **why**, not **what**. One‑line `/* … */` for fields; `//` OK if your codebase allows.
- File header: purpose, dependencies, ownership/thread model in 3–5 lines.

## API Pattern Cheatsheet
- Names: `module_action`, e.g., `fs_read`, `net_send`.
- Init/shutdown: `module_init(ctx*) → int`, `module_shutdown(ctx*)`.
- Open/close: `module_open(...) → handle*`, `module_close(handle*)`.
- Get/set: `module_get_x`, `module_set_x`.

## Example (merged style)
```c
/* renderer.h */
#ifndef RENDERER_H
#define RENDERER_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

struct span { int xmin, xmax; };
struct renderer;            /* opaque */

int  renderer_init(struct renderer **out);
void renderer_shutdown(struct renderer *r);
int  renderer_draw_span(struct renderer *r, const struct span *s);

#endif
```

```c
/* renderer.c */
#include "renderer.h"
#include <errno.h>

struct renderer {
    int width_px, height_px;
    void *pixels; /* owns */
};

static int s_running; /* file-local */

int renderer_init(struct renderer **out)
{
    struct renderer *r; /* allocate; omitted */
    s_running = 1;
    *out = r;
    return 0;
}

void renderer_shutdown(struct renderer *r)
{
    /* free fields; set to NULL */
    s_running = 0;
}

int renderer_draw_span(struct renderer *r, const struct span *s)
{
    if (!r || !s) return -EINVAL;
    /* draw... */
    return 0;
}
```

## Quick Do/Don’t
- **Do**: snake_case, module prefixes, small public API, explicit ownership, units in names.
- **Don’t**: typedef every struct, export globals, hide allocation, print inside libraries, mix tabs/spaces.

## Optional Helper Macros
```c
#define INTERNAL   static
#define INLINE     static inline
#if __STDC_VERSION__ >= 199901L
  #define LIKELY(x)   __builtin_expect(!!(x), 1)
  #define UNLIKELY(x) __builtin_expect(!!(x), 0)
#else
  #define LIKELY(x)   (x)
  #define UNLIKELY(x) (x)
#endif
```


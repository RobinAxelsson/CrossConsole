# C Standards and Types

## C Standard Versions

### C89/C90 (ANSI C, ISO C90)
**Year**: 1989 (ANSI), 1990 (ISO)
**Identifier**: `__STDC__` is defined

**Key features**:
- Function prototypes (vs K&R style)
- `void` pointers
- `const` and `volatile` qualifiers
- Standard library (`<stdio.h>`, `<stdlib.h>`, etc.)
- Preprocessor (`#if`, `#ifdef`, `#define`)
- Basic types: `char`, `short`, `int`, `long`, `float`, `double`, `long double`
- `struct`, `union`, `enum`

**Limitations**:
- No `//` comments (only `/* */`)
- No inline functions
- No variable-length arrays (VLAs)
- No fixed-width types (`int32_t`, etc.)
- No `bool` type
- Variables must be declared at start of block
- No designated initializers
- No `restrict` qualifier

### C99
**Year**: 1999
**Identifier**: `__STDC_VERSION__ >= 199901L`

**Major additions**:
- `//` single-line comments
- `inline` functions
- Variable-length arrays (VLAs): `int arr[n];`
- Fixed-width integer types: `<stdint.h>` (`int32_t`, `uint64_t`, etc.)
- `<stdbool.h>`: `bool`, `true`, `false`
- `long long` type (at least 64 bits)
- Flexible array members: `struct { int n; char data[]; }`
- Designated initializers: `struct point p = {.x = 10, .y = 20};`
- Compound literals: `(struct point){10, 20}`
- `restrict` pointer qualifier (optimization hint)
- `_Complex` and `_Imaginary` types
- Variable declarations anywhere in blocks (not just at start)
- `snprintf` and `vsnprintf`
- Variadic macros: `#define DEBUG(...)`
- Mixed declarations and code

**Example** (C99 vs C89):
```c
// C89 - declarations at top
int func(int n) {
    int i;
    int sum = 0;

    for (i = 0; i < n; i++) {
        sum += i;
    }
    return sum;
}

// C99 - declarations anywhere, inline loop variable
int func(int n) {
    int sum = 0;
    for (int i = 0; i < n; i++) {  // declare i here
        sum += i;
    }
    return sum;
}
```

### C11
**Year**: 2011
**Identifier**: `__STDC_VERSION__ >= 201112L`

**Major additions**:
- `_Static_assert`: Compile-time assertions
- `_Alignas` and `_Alignof`: Control/query alignment
- `_Generic`: Type-generic macros (compile-time type selection)
- `_Noreturn`: Function never returns
- Anonymous structs/unions:
  ```c
  struct {
      int x, y;
      union { int z; float w; };  // anonymous union
  };
  ```
- `<threads.h>`: Standard threading (optional)
- `<stdatomic.h>`: Atomic operations (optional)
- `quick_exit` and `at_quick_exit`
- Unicode support: `char16_t`, `char32_t`, `<uchar.h>`
- Bounds-checking interfaces (Annex K, rarely implemented)
- Removed VLAs from required features (now optional)

**Example**:
```c
// Static assertions
_Static_assert(sizeof(int) == 4, "int must be 32-bit");

// Generic selection
#define abs(x) _Generic((x), \
    int: abs_int, \
    float: abs_float, \
    double: abs_double \
)(x)

// Alignment
_Alignas(16) int aligned_array[4];
```

### C17/C18
**Year**: 2017/2018
**Identifier**: `__STDC_VERSION__ >= 201710L`

**Changes**: Bug fixes and clarifications to C11, no new features

### C23 (C2x)
**Year**: 2023 (latest)
**Identifier**: `__STDC_VERSION__ >= 202311L`

**Major additions**:
- `#embed`: Embed binary files directly
- `typeof` and `typeof_unqual`
- `constexpr` (limited form)
- `nullptr` and `nullptr_t`
- `bool`, `true`, `false` as keywords (no `<stdbool.h>` needed)
- `_BitInt(N)`: Arbitrary-width integers
- Digit separators: `1'000'000`
- Binary literals: `0b1010`
- Enhanced enums with fixed underlying type
- Attributes: `[[nodiscard]]`, `[[maybe_unused]]`, `[[deprecated]]`, etc.
- Improved Unicode support
- Lambdas (unreachable from C++ lambdas)

## Compiler Support

**MSVC** (Visual Studio):
- C89/C90: Full
- C99: Partial (no VLAs, added slowly over versions)
- C11: Partial (VS2019+: `_Generic`, `_Static_assert`)
- C17: Partial
- Default mode: C90 with extensions (use `/std:c11` or `/std:c17` for newer)

**GCC**:
- C89: `-std=c89` or `-ansi`
- C99: `-std=c99` (default on older versions)
- C11: `-std=c11`
- C17: `-std=c17` (default since GCC 8)
- C23: `-std=c2x` (experimental)

**Clang**:
- Similar flags to GCC
- Generally faster adoption of new standards

## Checking Standard Version

```c
#if __STDC_VERSION__ >= 201112L
    // C11 or later
    _Static_assert(sizeof(int) == 4, "");
#elif __STDC_VERSION__ >= 199901L
    // C99
    #include <stdint.h>
#else
    // C89
    typedef int bool;
    #define true 1
    #define false 0
#endif
```

## Practical Recommendations

- **C89**: Use for maximum portability (embedded systems, old compilers)
- **C99**: Sweet spot for most projects (fixed-width types, `bool`, `//.comments`)
- **C11**: If you need threading/atomics or static assertions
- **C17**: Same as C11 (just bug fixes)
- **C23**: Too new for production use (2024+)

**For this project (CWorld)**:
- MSVC defaults to C89 with extensions
- Uses custom typedefs (`int32`, `uint8`) instead of `<stdint.h>`
- Can use C99 features with `/std:c99` or newer, but not required

# C Standard Types

## Floating Point Types

**In practice** (x86, x64, ARM with IEEE 754):
- `float`: 32-bit (4 bytes)
- `double`: 64-bit (8 bytes)
- `long double`: 64-bit (MSVC), 80-bit (GCC x86), or 128-bit (some platforms)

**C standard guarantees** (minimum requirements):
- `sizeof(float) <= sizeof(double) <= sizeof(long double)`
- `float`: ~6 decimal digits precision, range ~10^±38
- `double`: ~10 decimal digits precision, range ~10^±308
- IEEE 754 is common but not required

**For guaranteed sizes** (binary formats, network protocols):
```c
_Static_assert(sizeof(float) == 4, "float must be 32-bit");
_Static_assert(sizeof(double) == 8, "double must be 64-bit");
```

## Integer Types

**Standard types** (sizes vary by platform):
- `char`: Always 1 byte (8+ bits), may be signed or unsigned
- `short`: At least 16 bits
- `int`: At least 16 bits (typically 32-bit on modern platforms)
- `long`: At least 32 bits (32-bit on Windows x64, 64-bit on Linux x64)
- `long long`: At least 64 bits (C99+)

**C standard guarantees**:
- `sizeof(char) <= sizeof(short) <= sizeof(int) <= sizeof(long) <= sizeof(long long)`
- `char` is exactly 1 byte (but a byte is at least 8 bits, not necessarily exactly 8)
- `int` must hold at least -32767 to 32767 (16-bit range)

**Fixed-width types** (C99 `<stdint.h>`, use for portability):
- `int8_t`, `uint8_t`: Exactly 8 bits (if available)
- `int16_t`, `uint16_t`: Exactly 16 bits (if available)
- `int32_t`, `uint32_t`: Exactly 32 bits (if available)
- `int64_t`, `uint64_t`: Exactly 64 bits (if available)

**Minimum-width types** (always available):
- `int_least8_t`, `uint_least8_t`: At least 8 bits
- `int_least16_t`, `uint_least16_t`: At least 16 bits
- `int_least32_t`, `uint_least32_t`: At least 32 bits
- `int_least64_t`, `uint_least64_t`: At least 64 bits

**Fast types** (fastest type with at least N bits):
- `int_fast8_t`, `uint_fast8_t`
- `int_fast16_t`, `uint_fast16_t`
- `int_fast32_t`, `uint_fast32_t`
- `int_fast64_t`, `uint_fast64_t`

**Pointer-sized types**:
- `intptr_t`, `uintptr_t`: Can hold a pointer
- `size_t`: Unsigned, result of sizeof operator
- `ptrdiff_t`: Signed, result of pointer subtraction

## Common Platform Sizes

### Windows (MSVC, both 32-bit and 64-bit)
```
Type          32-bit    64-bit
-------------------------------
char          1         1
short         2         2
int           4         4
long          4         4      (!)
long long     8         8
pointer       4         8
float         4         4
double        8         8
long double   8         8
```

### Linux/Unix (GCC)
```
Type          32-bit    64-bit
-------------------------------
char          1         1
short         2         2
int           4         4
long          4         8      (!)
long long     8         8
pointer       4         8
float         4         4
double        8         8
long double   12/16     16     (x87 extended)
```

## Notes

- **Never assume `int` is 32-bit** in portable code (though it is on modern platforms)
- **`long` differs**: 32-bit on Windows x64, 64-bit on Linux x64 (LLP64 vs LP64)
- **Use fixed-width types** when size matters (file formats, protocols, bit manipulation)
- **Use native types** (`int`, `size_t`) for general purpose code (faster, idiomatic)
- **Character signedness**: `char` signedness is implementation-defined; use `signed char` or `unsigned char` explicitly if it matters
# Notes


## Ansi and Unicode/Wide Mode

Windows has default modes for strings
wchar_t*
Unicode or Wide is default mode for windows
WindowClass => WINDOWCLASSA, WINDOWCLASSW
Mode = a compiler/build setting - API Switch

It decides which functions and types your program uses *internally*

## Format

The actual byte encoding of text in memory or on disc - independent of the build settings - what the data looks like

## Copy paste

The copy paste supports multiple formats! ANSI, Unicode text, rtf, html

Example: Copying “你好” from a Unicode-aware app into an old ANSI-only program → results in ??.

UTF-8 does not need a bom charachter

## C Namespaces

C has 4 namespaces:
- labels - goto start
- tag namespace: struct/union/enum
- ordinary identifyer namespace - can be copy of tag (typedef struct Foo Foo)
- member namespace (unique per struct)

```c
//Labels – names for goto targets

start: 
goto start;


//Tags – names of struct, union, and enum

struct Foo { int x; };


//Members – struct/union fields (scoped to the type)

struct Foo { int bar; };


//Ordinary identifiers – everything else (variables, functions, typedefs, enum constants)

int bar;
typedef int baz;

//example valid
struct Foo { int Foo; };  // Foo in tag namespace, bar in member namespace
typedef int Foo;          // Foo in ordinary namespace
int Foo;                  // Foo variable (ordinary namespace, collides with typedef)


```




# AGENTS.md - Guidelines for Coding Agents
## 日本語で回答してください。
## Project Overview
This is a C compiler project that translates a subset of C to MIPS assembly. It uses flex (lexical analysis) and bison (parser) with C implementation.


## Important: Learning Purpose
This is an educational/learning project. **DO NOT make any changes to the code without explicit user instruction.**
Your role is to assist, answer questions, and explain concepts, but never modify code, add features, or fix issues unless the user specifically asks you to do so.

## Build Commands

### Main Compiler (c-compiler/)
```bash
cd c-compiler
make              # Build the compiler
make clean        # Clean build artifacts
make test         # Run basic test with test.txt
make test_codegen # Build test_codegen
make test_sum     # Build test_sum

# Run specific test cases
make run_sum      # Compile and run sum test with maps emulator
make run_kaizyo   # Compile and run kaizyo (factorial) test
make run_fizzbuzz # Compile and run fizzbuzz test

# Parse-only checks
make check_fizzbuzz      # Verify fizzbuzz.c parses correctly
make check_if_program    # Verify if_program.c parses correctly
```

### Running the Compiler
```bash
# Compile a C file to assembly
./program < input.c > output.s

# Execute assembly with MAPS MIPS simulator
maps -e output.s
```

### AST Parser (ast/)
```bash
cd ast
make        # Build AST parser
make clean  # Clean build
make test   # Run test with test.txt
```

### Lex Examples (lex/)
```bash
cd lex
make        # Build all .l files
make clean  # Clean build
```

## Code Style Guidelines

### File Organization
- **Headers (.h)**: Type definitions, function prototypes, includes, header guards
- **Source (.c)**: Implementations, static helper functions, global variables
- **Lex (.l)**: Token definitions, lexical patterns
- **Yacc (.y)**: Grammar rules, semantic actions

### Formatting
- **Indentation**: 4 spaces (no tabs visible in code)
- **Brace style**: K&R style for functions
- **Line length**: Generally < 80 characters
- **Spacing**: Spaces around operators, after keywords
- **Comments**: Japanese comments acceptable for explanations

### Naming Conventions
- **Types**: UPPERCASE with _AST suffix (e.g., `DECL_STATEMENT_AST`, `WHILE_AST`)
- **Functions**: lowercase_with_underscores (e.g., `build_node2`, `symbol_table_add`)
- **Variables**: lowercase_with_underscores (e.g., `var_name`, `current_address`)
- **Constants**: UPPERCASE (e.g., `MAX_SYMBOLS`)
- **Macros**: UPPERCASE (e.g., `YACC_FILE`)
- **Struct tags**: PascalCase (e.g., `Symbol`, `Node`)

### Type Definitions
```c
// Enum for node types
typedef enum {
    STATEMENT_AST,
    DECL_STATEMENT_AST,
    WHILE_AST,
    IF_AST,
} NType;

// Struct with typedef
typedef struct {
    char name[32];
    int address;
} Symbol;
```

### Header Guards
```c
#ifndef FILENAME_H
#define FILENAME_H
// Content
#endif
```

### Import Order
```c
// 1. Own header first
#include "ast.h"
#include "codegen.h"
// 2. System headers
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
```

### Error Handling
- Use `fprintf(stderr, "Error: %s\n", message);` for errors
- Return error codes from functions (0 for success, non-zero for failure)
- Check malloc return values: `if (p == NULL) { yyerror("out of memory"); }`

### Memory Management
- Use `malloc(sizeof(Type))` for allocation
- Initialize struct fields after allocation
- Be aware of string memory: lex/yacc allocate strings that may need freeing
- Use `strdup()` when needed for string copies

### AST Node Structure
```c
typedef struct node {
    NType type;
    struct node* child;
    struct node* brother;
    union {
        int ival;
        char *sval;
    } val;
} Node;
```

### Global Variables
- Minimize use; currently used for AST root and label counters
- Declare as `extern` in headers when needed by other files
- Example: `Node* top;` for parser output, `static int while_loop_count;` for labels

### Static Functions
- Use `static` for internal helper functions
- Declare before definition or provide prototype
- Example: `static void walk_ast(Node *n, FILE *fp);`

### Yacc/Bison Patterns
- Include headers in `%{ %}` block
- Declare `extern` for yylex, yyerror
- Use `%union` for semantic value types
- Use `%token` and `%type` declarations
- Left-recursive rules for lists: `list: item list | item`

### Flex Patterns
- Match keywords before patterns: `"if" { return IF; }`
- Use `yylval` for passing semantic values
- Whitespace: `[ \t\n]+ {}` to ignore
- Use comments in lex files for token groups

### Testing
- Test files go in `tests/` subdirectory
- Write simple C programs as test inputs
- Use MAPS simulator to verify assembly output
- Include test compilation in Makefile

### Cross-Platform Notes
- Makefiles detect OS with `$(shell uname -s)`
- macOS: Uses Homebrew flex/bison paths
- Linux: Uses system flex/bison
- Library flags: `-lfl` (flex) and `-ly` (bison) on Linux

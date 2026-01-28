# AGENTS.md - Guidelines for Coding Agents

## 日本語で回答してください。

## Project Overview
This is a C compiler project (subset of C) targeting MIPS assembly.
It is an educational project using Flex (lexical analysis) and Bison (parsing).

**IMPORTANT: Learning Purpose**
This is an educational/learning project. **DO NOT make any changes to the code without explicit user instruction.**
Your role is to assist, answer questions, and explain concepts. Never modify code, add features, or fix issues unless specifically asked.

## Directory Structure
The project root is `/Users/nakajimasoraera/dev/github.com/soramameen/compiler`.
The main compiler code is in `c-compiler/`.

```text
c-compiler/
├── src/                # Source code (codegen.c, program.y, etc.)
├── tests/
│   └── cases/          # Integration test cases (*.c)
│       ├── sum.c       # Sum 1..10
│       ├── kaizyo.c    # Factorial
│       ├── fizzbuzz.c  # FizzBuzz
│       └── ...
├── output/             # Output assembly files (*.s)
└── Makefile            # Build configuration
```

## Build & Test Commands

Most operations should be performed within the `c-compiler/` directory.
Always check which directory you are in before running commands.

### Main Compiler (`c-compiler/`)

```bash
# Change to the compiler directory
cd c-compiler

# Build the compiler (creates 'program' executable)
make

# Clean build artifacts
make clean

# Run basic tests (using tests/cases/sum.c by default in Makefile)
make test
```

### Running Specific Tests (Compile + Execute in MAPS)

The `Makefile` includes convenient targets to compile a test case and run it in the MAPS simulator immediately.

```bash
# FizzBuzz (tests/cases/fizzbuzz.c)
make run_fizzbuzz

# Factorial/Kaizyo (tests/cases/kaizyo.c)
make run_kaizyo

# Sieve of Eratosthenes (tests/cases/era.c)
make run_era

# 2D Array Test (tests/cases/2d.c)
make run_2d

# Comparison Operators
make run_le    # Less than or equal
make run_ge    # Greater than or equal
```

### Unit Tests
```bash
# Build and run code generation unit tests
make test_codegen
./test_codegen
```

### Manual Execution
To manually compile a specific file:
```bash
# 1. Compile C to MIPS Assembly
./program < tests/cases/your_file.c > output/your_file.s

# 2. Run in Simulator
maps -e output/your_file.s
```

## Code Style Guidelines

### File Organization
*   `src/*.h`: Type definitions, prototypes, macros.
*   `src/*.c`: Implementation.
*   `src/*.l`: Flex (Lexer) definitions.
*   `src/*.y`: Bison (Parser) grammar and actions.
*   `tests/cases/*.c`: Integration test cases (C source).
*   `tests/unit/*.c`: Unit test drivers.

### Formatting
*   **Indentation**: 4 spaces (soft tabs). No hard tabs.
*   **Braces**: K&R style (opening brace on the same line for functions and control structures).
*   **Line Length**: Aim for < 80 characters where possible.
*   **Encoding**: UTF-8.

### Naming Conventions
*   **Functions/Variables**: `snake_case` (e.g., `build_node`, `symbol_table_add`).
*   **Constants/Macros**: `UPPER_CASE` (e.g., `MAX_SYMBOLS`, `YACC_FILE`).
*   **Types/Structs**: `PascalCase` (e.g., `Node`, `Symbol`) or `UPPER_CASE` for AST types (`WHILE_AST`).
*   **Files**: `snake_case` (e.g., `symbol_table.c`).

### C Coding Standards
1.  **Memory**:
    *   Always check `malloc` return values.
    *   Initialize allocated memory (often done in `build_node` functions).
2.  **Error Handling**:
    *   Use `fprintf(stderr, ...)` for errors.
    *   Exit with non-zero status on fatal errors.
3.  **Headers**:
    *   Use header guards (`#ifndef FILENAME_H ...`).
    *   Include own header first, then local headers, then system headers.

### AST Structure
The AST nodes (`Node`) are central to this compiler.
```c
typedef struct node {
    NType type;             // Node type (e.g., IF_AST, WHILE_AST)
    struct node* child;     // First child
    struct node* brother;   // Sibling (linked list)
    union {
        int ival;
        char *sval;
    } val;
} Node;
```

## Environment
*   **OS**: macOS (primary), Linux.
*   **Tools**: `gcc`, `make`, `flex` (homebrew on Mac), `bison` (homebrew on Mac).
*   **Simulator**: `maps` (MIPS Architecture Simulator) is required for running the output assembly.

## Documentation
*   `rules/report.md`: Guidelines for the final report.
*   `c-compiler/README.md`: Project specific details.

## Review Guidelines
**IMPORTANT**: When reviewing code, planning features, or answering questions about project requirements, **ALWAYS refer to `rules/report.md`**.
This file contains the specific criteria, required language features, and constraints for the final report/project.

## Report Writing Persona & Style
*   **Tone**: "Student-like" (学生らしい). Academic, humble, and focused on the learning process.
*   **Grammar**: Use "Da/Dearu" style (だ・である調) exclusively.
*   **Content**:
    *   Focus on **what was learned** from the experiment.
    *   Describe **why** certain implementation choices were made.
    *   Mention struggles/errors and how they were overcome (shows the learning curve).
    *   Avoid overly commercial or polished language; keep it grounded in the educational context.

## Notification Rule
When you have completed all requested tasks, you MUST send a notification using the `notify` command.
Example: `notify 'Task X completed'`

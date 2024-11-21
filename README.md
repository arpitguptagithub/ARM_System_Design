# Compiler for a Custom Language and TAC-to-VM Conversion

## Overview

This repository contains two key components:

1. **`prob1.y`**: A YACC file that defines the grammar and parsing rules for a custom programming language.
2. **`TAC-VM3.cpp`**: A C++ program that converts Three-Address Code (TAC) into Virtual Machine (VM) instructions.

The compiler generates TAC for the given language, and the conversion program translates TAC into a format executable by a VM. Below is a detailed explanation of these components and instructions for using the repository.


## File Details

### `prob1.y`

#### Purpose
This YACC file is the core of the compiler, responsible for:
- Parsing source code written in a custom language.
- Generating intermediate representations, such as TAC.

#### Key Features
- **Grammar Rules**: The file defines syntax rules for the language, including constructs like variable declarations, arithmetic expressions, loops, conditionals, and function calls.
- **Semantic Actions**: Embedded C code implements logic to:
  - Validate syntax.
  - Generate TAC for operations and control flow constructs.
- **Error Handling**: The file includes basic error-handling capabilities to report invalid syntax.

#### How it Works
1. **Input**: Source code in the custom language.
2. **Output**: TAC generated as an intermediate representation.

#### Using `prob1.y`
1. Compile the YACC file:
   ```bash
   yacc -d prob1.y
   cc -o parser y.tab.c -ll
   ```
2. Run the parser with a source code file:
   ```bash
   ./parser < source_code.txt > tac.txt
   ```
   This will produce a `tac.txt` file containing the TAC.

### `TAC-VM3.cpp`

#### Purpose
This C++ program converts the TAC produced by the `prob1.y` parser into a set of VM instructions, bridging the gap between the compiler's front end and a virtual machine.

#### Key Features
- **TAC Tokenization**: Breaks TAC lines into manageable tokens for processing.
- **Operation Mapping**: Maps operators (`+`, `-`, `*`, etc.) to corresponding VM instructions.
- **Type Management**: Handles variable types, constants, arrays, and function arguments.
- **Control Flow**: Processes labels, conditionals, and function calls for VM compatibility.

#### How it Works
1. Reads the `tac.txt` file.
2. Parses TAC into a structured format.
3. Converts each TAC line into corresponding VM instructions.
4. Outputs VM instructions to the standard output.

#### Using `TAC-VM3.cpp`
1. Compile the program:
   ```bash
   g++ TAC-VM3.cpp -o tac_to_vm
   ```
2. Run the converter with the `tac.txt` file:
   ```bash
   ./tac_to_vm > vm_instructions.txt
   ```
   This will generate `vm_instructions.txt` containing the VM code.

---

## How to Use

### Prerequisites
- A C compiler (e.g., GCC) for building the parser and TAC-to-VM converter.
- YACC for generating the parser from `prob1.y`.

### Steps
1. **Write Source Code**: Create a source code file in the custom language.
2. **Generate TAC**:
   - Run the YACC-based parser (`prob1.y`) to produce `tac.txt`.
3. **Convert TAC to VM Instructions**:
   - Use `TAC-VM3.cpp` to translate TAC into VM code.

### Example Workflow
```bash
# Step 1: Compile the YACC parser
yacc -d prob1.y
cc -o parser y.tab.c -ll

# Step 2: Parse source code to generate TAC
./parser < example_source.txt > tac.txt

# Step 3: Compile the TAC-to-VM converter
g++ TAC-VM3.cpp -o tac_to_vm

# Step 4: Convert TAC to VM instructions
./tac_to_vm > vm_instructions.txt
```

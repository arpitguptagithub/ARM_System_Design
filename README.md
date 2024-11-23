# ARM System Design

This repository contains the implementation of an assembler, linker, and loader for a custom ARMv7 processor. The project is divided into several components, each responsible for a specific part of the process of converting assembly code into an executable format.

## Table of Contents

- [Overview](#overview)
- [Directory Structure](#directory-structure)
- [Assembler](#assembler)
- [Linker](#linker)
- [Loader](#loader)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Overview

The project consists of three main components:

1. **Assembler**: Converts ARM assembly code into machine code.
2. **Linker**: Resolves symbols and combines multiple object files into a single executable.
3. **Loader**: Loads the executable into memory and prepares it for execution.

## Directory Structure

```
ARM_System_Design/
├── assembler.py
├── helper.py
├── load.py
├── linker/
│   └── linker.py
├── asmout.obj
├── output.elf
└── README.md
```

## Assembler

The assembler is responsible for converting ARM assembly code into machine code. It performs the following steps:

1. **First Pass**: Scans the source code to collect labels and their addresses.
2. **Second Pass**: Converts each instruction into its binary representation.

### Supported Instructions

The assembler supports a subset of ARMv7 instructions, including:

- Data Processing: `MOV`, `ADD`, `ADC`, `SUB`, `SBC`, `ORR`, `AND`, `MVN`, `EOR`, `CMP`, `TST`
- Memory Access: `STR`, `LDR`
- Branching: `B`, `BL`

### Usage

To assemble a source file:

```sh
python assembler.py <src_file.asm>
```

The assembler will generate an object file (`asmout.obj`) containing the machine code.

## Linker

The linker combines multiple object files into a single executable. It resolves symbols and addresses, ensuring that all references are correctly linked.

### Usage

To link object files:

```sh
python linker/linker.py
```

The linker will generate a linked object file (`linked_output.obj`).

## Loader

The loader reads the linked object file and creates an ELF (Executable and Linkable Format) file. The ELF file contains the necessary headers and sections to be loaded into memory for execution.

### Usage

To create an ELF file:

```sh
python load.py
```

The loader will generate an ELF file (`output.elf`).

## Usage

1. **Assemble the source file**:
   ```sh
   python assembler.py <src_file.asm>
   ```

2. **Link the object files**:
   ```sh
   python linker/linker.py
   ```

3. **Create the ELF file**:
   ```sh
   python load.py
   ```
# Contributions
Abhinav - Loader
Sudharshan - Assembler
Ashish - Linker

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue if you have any suggestions or improvements.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

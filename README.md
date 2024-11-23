# 32-bit ARM Processor Implementation

A Verilog HDL implementation of a 32-bit ARM processor featuring hazard detection, forwarding unit, and SRAM memory integration.

## Features

- 5-stage pipeline (IF, ID, EXE, MEM, WB)
- Hazard detection unit
- Data forwarding unit
- SRAM memory interface
- Status register support (NZCV flags)
- Branch prediction

### Supported Instructions

- Data Processing
  - MOV, MVN (Move operations)
  - ADD, ADC (Addition operations)
  - SUB, SBC (Subtraction operations)
  - AND, ORR, EOR (Logical operations)
  - CMP, TST (Comparison operations)
  
- Memory Access
  - LDR (Load Register)
  - STR (Store Register)
  
- Branch Operations
  - Conditional branching based on status flags

## Architecture Overview

### Pipeline Stages

1. **IF (Instruction Fetch)**
   - Fetches instruction from instruction memory
   - Updates program counter

2. **ID (Instruction Decode)**
   - Decodes instruction
   - Reads register file
   - Handles hazard detection

3. **EXE (Execute)**
   - ALU operations
   - Address calculations
   - Branch address computation

4. **MEM (Memory)**
   - Memory access operations
   - SRAM interface handling

5. **WB (Write Back)**
   - Writes results back to register file

### Key Components

- **Hazard Detection Unit**
  - Detects data hazards
  - Implements pipeline stalling
  - Supports forwarding control

- **Forwarding Unit**
  - Handles data forwarding
  - Reduces pipeline stalls
  - Configurable forwarding paths

- **SRAM Controller**
  - 64-bit data bus
  - Memory read/write control
  - Address mapping

- **Register File**
  - 15 general-purpose registers
  - Dual read ports
  - Single write port

## Implementation Details

### Memory Organization
- Instruction Memory: Separate memory for program instructions
- SRAM: External memory for data storage
- Memory-mapped I/O support

### Hazard Handling
- Data Hazards: Resolved through forwarding and stalling
- Control Hazards: Handled by pipeline flushing
- Structural Hazards: Avoided through proper resource allocation

### Status Flags
- N: Negative result
- Z: Zero result
- C: Carry out
- V: Overflow

## Testing

The project includes a comprehensive testbench (`ARM_TB_Final.v`) that:
- Monitors register values
- Tracks memory operations
- Displays current instruction execution
- Provides timing analysis

## Usage

1. **Simulation**
   ```verilog
   // Compile all Verilog files
   // Run simulation using ARM_TB_Final.v
   ```

2. **Configuration**
   - Forwarding can be enabled/disabled using `isForwardingActive`
   - Memory timing can be adjusted in SRAM controller

3. **Monitoring**
   - Register values are displayed during execution
   - Memory operations are logged
   - Status flags can be tracked

## Project Structure

The project follows a modular design with separate components for each pipeline stage:

- `IF_Stage.v`: Instruction Fetch stage
- `ID_Stage.v`: Instruction Decode stage 
- `EXE_Stage.v`: Execution stage
- `MEM_Stage.v`: Memory access stage
- `WB_Stage.v`: Write Back stage

Key supporting modules include:

- `PC.v`: Program Counter logic
- `Register_File.v`: Register bank implementation
- `ALU.v`: Arithmetic Logic Unit
- `Control_Unit.v`: Main controller
- `Hazard_Detection_Unit.v`: Handles pipeline hazards
- `Forwarding_Unit.v`: Data forwarding logic
- `SRAM_Controller.v`: External memory interface

The project structure demonstrates a clean separation of concerns and modular design principles, making it easier to understand, test and maintain individual components.

## Contribution 
System Integration and Processor Team 



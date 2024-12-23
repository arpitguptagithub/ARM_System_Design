# Computer System Design Repository

This repository focuses on various aspects of computer system design, including compiler development, operating system design, processor architecture, and system integration. Below are key topics and branches within the repository for reference.

---

## Topics Covered

1. **ARM A32 Architecture**  
   Explore resources and implementation details for the ARM A32 architecture, emphasizing its instruction set, pipeline stages, and integration with system design.

2. **Zybo Z710 Architecture**  
   Details about the Zybo Z710 architecture, its compatibility with ARM-based pipelines, and its suitability for system design projects.

3. **Pipeline Processor Design**

   - Implementation of a multi-stage pipeline (Fetch, Decode, Execute, Memory, Writeback) tailored for ARM A32 and Zybo Z710 architectures.
   - Performance optimizations and considerations for hazards (data, control, and structural).

4. **Compiler**

   - Focus on compiling pipelines for embedded systems.
   - Optimizations specific to ARM and Zybo platforms.

5. **Operating System (OS)**

   - Lightweight OS design tailored for custom processor designs.
   - IO driver module for working
   - Utilization of simple system calls and libraries as needed.

6. **Processor with Memory Integration**

   - Custom processor design with memory modules.
   - Integration strategies for effective data flow.

7. **Programming Language**

   - Contributions related to the design or usage of a programming language for system development and simulation.

8. **Pipeline (PL_COMP_VM_ALL)**

   - Comprehensive implementation covering all aspects of the pipeline:
     - PL (Programming Language)
     - COMP (Compiler)
     - VM (Virtual Machine linker and translator)
     - ALL ( Assembler, Linker and Loader)

9. **System Integration**

   - Techniques for integrating various components of the processor, memory, and peripherals.

10. **Testing**
    - Unit and integration testing of processor and OS components.
    - Validation of pipeline stages and static linking implementations.

---

## Branches for Reference

Please refer to the following branches for specific implementations and details:

- **main**: Primary branch with stable releases and complete implementations.
- **ALL**: Consolidated resources covering Assembler, Linker and Loader.
- **Compiler**: Compiler-related implementations and optimizations.
- **OS**: Lightweight OS design and related projects.
- **Processor_W_memory**: Processor design with memory integration.
- **Processor_design**: Dedicated processor designs with hazard detections.
- **Programming_Language**: Contributions and experiments with programming languages.
- **pipeline\_(PL_COMP_VM_ALL)**: Comprehensive pipeline implementations.
- **vm**: part of vm Comprehensive pipeline implementations having vm linker and translator.
- **system_integration**: System integration on the processor.
- **testing**: Testing strategies and frameworks.

## Contributions

Team lead : Arpit Gupta

- **System Integration** : Uday(Keyboard Ps2 protocol) , Arpit Gupta (Memory Integration), Siva( Display HDMI protocol)

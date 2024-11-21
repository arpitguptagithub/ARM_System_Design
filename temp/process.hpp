#ifndef PROCESS_HPP
#define PROCESS_HPP

#include <iostream>
#include <string>
#include <unordered_map>
#include <memory>
#include <fstream>

// Enum for process states
enum class ProcessState {
    New,
    Running,
    Waiting,
    Terminated
};


struct PCB {
    int pid;                      // Process ID
    std::string name;             // Process Name
    ProcessState state;           // Current State
    int program_counter;          // Instruction Pointer
    std::string context;          // Process Context

    PCB(int p, const std::string& n)
        : pid(p), name(n), state(ProcessState::New), program_counter(0), context("Initial Context") {}

    // Save the process context to a file
    void saveToFile() const {
        std::ofstream file("process_" + std::to_string(pid) + ".txt");
        if (file.is_open()) {
            file << "PID: " << pid << "\n";
            file << "Name: " << name << "\n";
            file << "State: " << static_cast<int>(state) << "\n";
            file << "Program Counter: " << program_counter << "\n";
            file << "Context: " << context << "\n";
            file.close();
        }
    }
};

class ProcessManager {
private:
    static int pid_counter;                 // Global PID counter
    std::unordered_map<int, PCB> pcbs;      // Process Control Blocks

public:
    // Create a new process
    int createProcess(const std::string& name);

    // Simulate execution of a process
    void exec(int pid);

    // Wait for a process to complete
    void wait(int pid);

    // Kill a process
    void killProcess(int pid);

    // List all running processes
    void listProcesses() const;

    // Halt the system
    void halt();

    // Simulate interrupt handling
    void simulateInterruptHandling(class InterruptManager& interruptManager);
};

#endif // PROCESS_HPP

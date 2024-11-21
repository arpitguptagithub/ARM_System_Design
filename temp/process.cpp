#include "process.hpp"
#include "interrupt.hpp"
#include <algorithm>
#include <thread>
#include <chrono>

// Initialize PID counter
int ProcessManager::pid_counter = 0;

int ProcessManager::createProcess(const std::string& name) {
    int pid = ++pid_counter;
    PCB pcb(pid, name);
    pcbs[pid] = pcb;
    std::cout << "Process created: " << name << " [PID=" << pid << "]\n";
    pcb.saveToFile(); // Save context to a file
    return pid;
}

void ProcessManager::exec(int pid) {
    auto it = pcbs.find(pid);
    if (it == pcbs.end()) {
        std::cout << "No process found with PID=" << pid << '\n';
        return;
    }
    it->second.state = ProcessState::Running;
    it->second.program_counter++;
    it->second.context = "Updated Context";  // Update context with a new state
    std::cout << "Executed process [PID=" << pid << "]: " << it->second.name << "\n";
    it->second.saveToFile();  // Save updated context
}

void ProcessManager::wait(int pid) {
    auto it = pcbs.find(pid);
    if (it == pcbs.end()) {
        std::cout << "No process found with PID=" << pid << '\n';
        return;
    }
    std::cout << "Waiting for process [PID=" << pid << "] to complete...\n";
    std::this_thread::sleep_for(std::chrono::seconds(2)); // Simulate wait
    it->second.state = ProcessState::Terminated;
    std::cout << "Process [PID=" << pid << "] completed.\n";
    pcbs.erase(it);  // Remove terminated process from the map
}

void ProcessManager::killProcess(int pid) {
    auto it = pcbs.find(pid);
    if (it != pcbs.end()) {
        std::cout << "Killed process [PID=" << pid << "]: " << it->second.name << '\n';
        pcbs.erase(it);  // Remove process from map
    } else {
        std::cout << "No process found with PID=" << pid << '\n';
    }
}

void ProcessManager::listProcesses() const {
    if (pcbs.empty()) {
        std::cout << "No processes running.\n";
        return;
    }
    std::cout << "Running processes:\n";
    for (const auto& [pid, pcb] : pcbs) {
        std::cout << "[PID=" << pid << "] " << pcb.name << " (State: " << static_cast<int>(pcb.state) << ")\n";
    }
}

void ProcessManager::halt() {
    std::cout << "Halting OS simulation...\n";
    pcbs.clear();
    std::cout << "All processes terminated.\n";
}

void ProcessManager::simulateInterruptHandling(InterruptManager& interruptManager) {
    // Example interrupt: Process termination
    interruptManager.registerHandler(1, [this]() {
        if (!pcbs.empty()) {
            int pidToTerminate = pcbs.begin()->first; // Get the first process
            pcbs[pidToTerminate].saveToFile();       // Save process context before termination
            pcbs.erase(pidToTerminate);
            std::cout << "Process " << pidToTerminate << " terminated due to interrupt.\n";
        } else {
            std::cout << "No processes to terminate.\n";
        }
    });

    // Triggering the interrupt
    Interrupt terminationInterrupt = {1, 10, "Terminate Process"};
    interruptManager.triggerInterrupt(terminationInterrupt);

    // Handle the interrupt
    interruptManager.handleInterrupt();
}

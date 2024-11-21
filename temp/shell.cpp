#include <iostream>
#include <string>
#include <sstream>
#include "process.hpp"

class Shell {
private:
    ProcessManager pm;  // Process manager to interact with processes

public:
    // Function to process commands entered by the user
    void run() {
        std::string command;
        while (true) {
            std::cout << "OS-Shell> ";
            std::getline(std::cin, command);

            // Parse command
            std::stringstream ss(command);
            std::string cmd;
            ss >> cmd;

            if (cmd == "create") {
                std::string name;
                ss >> std::ws;  // Skip leading whitespaces
                std::getline(ss, name);
                if (!name.empty()) {
                    int pid = pm.createProcess(name);
                    std::cout << "Process created with PID " << pid << "\n";
                } else {
                    std::cout << "Please provide a name for the process.\n";
                }
            }
            else if (cmd == "list") {
                pm.listProcesses();
            }
            else if (cmd == "exec") {
                int pid;
                ss >> pid;
                pm.exec(pid);
            }
            else if (cmd == "kill") {
                int pid;
                ss >> pid;
                pm.killProcess(pid);
            }
            else if (cmd == "wait") {
                int pid;
                ss >> pid;
                pm.wait(pid);
            }
            else if (cmd == "halt") {
                pm.halt();
                break;  // Exit the shell after halting
            }
            else {
                std::cout << "Unknown command: " << cmd << "\n";
            }
        }
    }
};

int main() {
    Shell shell;
    shell.run();  // Start the shell
    return 0;
}

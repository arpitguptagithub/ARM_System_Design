#ifndef INTERRUPT_HPP
#define INTERRUPT_HPP

#include <string>
#include <functional>
#include <unordered_map>
#include <queue>
#include <iostream>

struct Interrupt {
    int id;                         // Unique interrupt ID
    int priority;                   // Priority of the interrupt
    std::string description;        // Description of the interrupt

    // Comparator for priority queue
    bool operator<(const Interrupt& other) const {
        return priority < other.priority; // Higher priority interrupts go first
    }
};

class InterruptManager {
private:
    std::priority_queue<Interrupt> interruptQueue;             // Queue for interrupts
    std::unordered_map<int, std::function<void()>> handlers;   // Handlers for interrupts

public:
    // Register an interrupt handler
    void registerHandler(int interruptId, const std::function<void()>& handler) {
        handlers[interruptId] = handler;
    }

    // Trigger an interrupt
    void triggerInterrupt(const Interrupt& interrupt) {
        interruptQueue.push(interrupt);
        std::cout << "Interrupt triggered: " << interrupt.description << "\n";
    }

    // Process the next interrupt
    void handleInterrupt() {
        if (!interruptQueue.empty()) {
            Interrupt current = interruptQueue.top();
            interruptQueue.pop();
            std::cout << "Handling interrupt: " << current.description << "\n";
            if (handlers.find(current.id) != handlers.end()) {
                handlers[current.id](); // Call the handler
            } else {
                std::cout << "No handler registered for interrupt ID: " << current.id << "\n";
            }
        } else {
            std::cout << "No interrupts to handle.\n";
        }
    }
};

#endif // INTERRUPT_HPP

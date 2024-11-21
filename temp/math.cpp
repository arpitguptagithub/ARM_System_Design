#include <iostream>
#include <string>
#include <sstream>

void calculate(const std::string& expression) {
    std::istringstream iss(expression);
    double num1, num2;
    char op;

    if (!(iss >> num1 >> op >> num2)) {
        std::cerr << "Invalid expression format. Use: <num1> <operator> <num2>\n";
        return;
    }

    switch (op) {
        case '+': std::cout << "Result: " << num1 + num2 << std::endl; break;
        case '-': std::cout << "Result: " << num1 - num2 << std::endl; break;
        case '*': std::cout << "Result: " << num1 * num2 << std::endl; break;
        case '/':
            if (num2 != 0) std::cout << "Result: " << num1 / num2 << std::endl;
            else std::cerr << "Division by zero is not allowed.\n";
            break;
        default: std::cerr << "Unsupported operator. Use +, -, *, or /.\n";
    }
}

int main() {
    std::string input;
    std::cout << "Enter a math expression (e.g., 3 + 4): ";
    std::getline(std::cin, input);

    calculate(input);
    return 0;
}

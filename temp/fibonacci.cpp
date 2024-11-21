#include <iostream>

void generateFibonacci(int n) {
    long long a = 0, b = 1;
    std::cout << "Fibonacci series up to " << n << " terms:\n";
    for (int i = 1; i <= n; ++i) {
        std::cout << a << " ";
        long long next = a + b;
        a = b;
        b = next;
    }
    std::cout << std::endl;
}

int main() {
    int n;
    std::cout << "Enter the number of terms for Fibonacci series: ";
    std::cin >> n;

    if (n <= 0) {
        std::cerr << "Number of terms must be positive.\n";
        return 1;
    }

    generateFibonacci(n);
    return 0;
}

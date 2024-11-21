#include <iostream>
#include <vector>
#include <algorithm>
#include <sstream>

void sortNumbers(const std::vector<int>& numbers) {
    std::vector<int> sorted = numbers;
    std::sort(sorted.begin(), sorted.end());
    std::cout << "Sorted numbers: ";
    for (int num : sorted) {
        std::cout << num << " ";
    }
    std::cout << std::endl;
}

int main() {
    std::string input;
    std::cout << "Enter numbers to sort (space-separated): ";
    std::getline(std::cin, input);

    std::vector<int> numbers;
    std::stringstream ss(input);
    int num;
    while (ss >> num) {
        numbers.push_back(num);
    }

    sortNumbers(numbers);
    return 0;
}

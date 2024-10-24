#include <stdio.h>
#include <stdlib.h>
#include<iostream>
#include <bitset>
#include <fstream>
#include <string>
#include <thread>
#include <chrono>
#include <filesystem>
#include <vector>
#include "../core/global.h"
#include "display_driver.cpp"
using namespace std;
// #define ROW_CHAR_SIZE 80  
// #define COLUMN_CHAR_SIZE 60
#define CHAR_SIZE 8  

const int ROWS = COLUMN_CHAR_SIZE*8;  // Number of rows
const int COLS = ROW_CHAR_SIZE*8;  // Number of columns

// Example m array
unsigned char m[ROWS][COLS];  // Storing char bitmaps (8-bit values)
void plot_screen(const char* filename) {
    FILE* file = fopen(filename, "r");
    if (!file) {
        perror("Failed to open m file");
        return;
    }

    // Allocate m for the display
    // char m[COLUMN_CHAR_SIZE * CHAR_SIZE][ROW_CHAR_SIZE * CHAR_SIZE]; // For an 80x60 display

    // Initialize m to 0 (black)
    for (int r = 0; r < COLUMN_CHAR_SIZE * CHAR_SIZE; r++) {
        for (int c = 0; c < ROW_CHAR_SIZE * CHAR_SIZE; c++) {
            m[r][c] = '0'; // Black
        }
    }

    // Read the m data
    char line[CHAR_SIZE + 2]; // 8 bits+\n + null terminator
    int A = 0; // Starting address in m
    // std::cout<<"OK"<<"\n";
    while (fgets(line, sizeof(line), file) && A <= 191999) {
        if(A<IO_DISPLAY_START){
            A++;
            continue;
        }
        // std::cout<<A<<" "<<line<<"\n";

        // Calculate the actual m position for each bit
        // std::cout<<A<<" "<< IO_DISPLAY_START<<"\n";
        int x=IO_DISPLAY_START;
        int row = (A-x)/ROW_CHAR_SIZE;//(A / ROW_CHAR_SIZE) * CHAR_SIZE + bitIndex; // Each character has 8 rows
        int col = (A-x) % ROW_CHAR_SIZE;
        // std::cout<<(A-x)<<" "<<(A-x)/ROW_CHAR_SIZE<<"\n";
        // std::cout<<A<<" start: "<<x<<" r: "<<row<<" c: "<<col<<"\n";
        // std::cout<<line<<"\n";
            // Set m based on the character's bit
        for(int i=col*8;i<col*8+8;i++){
            m[row][i]=line[7-(i-8*col)];
        }
        A++; // Move to the next character
        
    }
    fclose(file);

    // Print the visual representation
    std::ofstream outFile("../display.txt");
    if (!outFile) {
        std::cerr << "Failed to open display.txt for writing." << std::endl;
        return;
    }

    for (int r = 0; r < COLUMN_CHAR_SIZE * CHAR_SIZE; r++) {
        for (int c = 0; c < ROW_CHAR_SIZE * CHAR_SIZE; c++) {
            if(m[r][c]=='0'){
            outFile << '.' << " "; // Write to the file
                
            }
            else{
                outFile << 'X' << " "; // Write to the file

            }
        }
        outFile << "\n"; // New line after each row
    }

    outFile.close(); // Close the output file
    
}

void convertAndAppend(const std::string& inputFile, const std::string& outputFile, std::streampos& lastPosition) {
    std::ifstream infile(inputFile);
    std::ofstream outfile(outputFile, std::ios::app); // Open in append mode

    if (!infile.is_open() || !outfile.is_open()) {
        std::cerr << "Error opening file!" << std::endl;
        return;
    }

    // Move to the last known position in the input file
    infile.seekg(lastPosition);

    char ch;
    int x=lastPosition;
    std::vector<std::string> lines; // Buffer to hold output lines

    // Initialize lines with existing contents from the output file
    std::ifstream readFile(outputFile);
    std::string line;
    while (std::getline(readFile, line)) {
        lines.push_back(line); // Store each line in the vector
    }
    readFile.close();
    while (infile.get(ch)) { // Read one character at a time
        std::cout << "Current position: " << infile.tellg() << " Reading: " << ch << "\n";

        if (ch == '\b') { // Handle backspace
            // If the output file is not empty, backspace
            if (outfile.tellp() > 0) {
                outfile.seekp(-1, std::ios::cur); // Move back one position
                outfile << "0"; // Replace the last character (adjust as needed)
            }
        } else {
            std::bitset<8> binaryChar(ch);
            outfile << binaryChar.to_string() << '\n';
            lines.push_back(binaryChar.to_string());
        }
        if (lines.size() >=1) {
            const std::string& firstLine = lines[0];

            char input = (char)strtol(firstLine.c_str(), NULL, 2); // Convert binary string to char
            if (input == 0) continue; // Skip if it's a null input
            printf("Simulated keyboard input: %c\n", input);
            char t[8];
            strncpy(t, firstLine.c_str(), 8); // Copy first 8 bits into char array
            dmwrite(t,IO_KEYBOARD_START);
            char output = mread_char(IO_KEYBOARD_START);
            printf("Read from keyboard driver: %c\n", output);
            write_char(keyboard_get_input());
            plot_screen("../memory.txt");
            lines.erase(lines.begin()); // Remove the first line
            outfile.close(); // Close the output file before rewriting
            std::ofstream writeFile(outputFile, std::ios::trunc); // Open in truncate mode
            for (const auto& line : lines) {
                writeFile << line << '\n';
            }
            writeFile.close(); // Close after writing
            outfile.open(outputFile, std::ios::app); // Reopen in append mode
        }
        if(infile.tellg()==-1){
            lastPosition=x;
        }
        else{
            x=infile.tellg();
        }

    }
    lastPosition = x; // Move to the end of the file after reading new content

    infile.close();
    outfile.close();
}

void convertAndAppend2(const std::string& inputFile, const std::string& outputFile, std::streampos& lastPosition){
    std::ifstream infile(inputFile);
    std::ofstream outfile(outputFile, std::ios::app); // Open in append mode

    if (!infile.is_open() || !outfile.is_open()) {
        std::cerr << "Error opening file!" << std::endl;
        return;
    }

    // Move to the last known position in the input file
    infile.seekg(lastPosition-1);
    std::cout<<"in: "<<lastPosition<<" "<<infile.tellg();
    char ch;
    int x=lastPosition;
    std::vector<std::string> lines; // Buffer to hold output lines

    // Initialize lines with existing contents from the output file
    std::ifstream readFile(outputFile);
    std::string line;
    while (std::getline(readFile, line)) {
        lines.push_back(line); // Store each line in the vector
    }
    readFile.close();
    while (infile.tellg()<lastPosition && infile.tellg()!=-1) { // Read one character at a time
        std::cout<<"in while: "<<lastPosition<<" "<<infile.tellg();

        char ch ='\b';
        std::cout << "Current position: " << infile.tellg() << " Reading: " << ch << "\n";

            std::bitset<8> binaryChar(ch);
            outfile << binaryChar.to_string() << '\n';
            lines.push_back(binaryChar.to_string());
        if (lines.size() >=1) {
            const std::string& firstLine = lines[0];

            char input = (char)strtol(firstLine.c_str(), NULL, 2); // Convert binary string to char
            if (input == 0) continue; // Skip if it's a null input
            printf("Simulated keyboard input: %c\n", input);
            char t[8];
            strncpy(t, firstLine.c_str(), 8); // Copy first 8 bits into char array
            dmwrite(t,IO_KEYBOARD_START);
            char output = mread_char(IO_KEYBOARD_START);
            printf("Read from keyboard driver: %c\n", output);
            write_char(keyboard_get_input());
            plot_screen("../memory.txt");
            lines.erase(lines.begin()); // Remove the first line
            outfile.close(); // Close the output file before rewriting
            std::ofstream writeFile(outputFile, std::ios::trunc); // Open in truncate mode
            for (const auto& line : lines) {
                writeFile << line << '\n';
            }
            writeFile.close(); // Close after writing
            outfile.open(outputFile, std::ios::app); // Reopen in append mode
        }
        lastPosition -= 1; // Move to the end of the file after reading new content

    }

    infile.close();
    outfile.close();
}


void monitorFile(const std::string& inputFile, const std::string& outputFile) {
    std::streampos lastPosition = 0; // Track the last position in input.txt
    std::streampos pPosition = 0; // Track the last position in input.txt


    while (true) {
        std::this_thread::sleep_for(std::chrono::seconds(2)); // Poll every 2 seconds

        // Check if the input file exists
        if (std::filesystem::exists(inputFile)) {
            std::ifstream infile(inputFile, std::ios::ate); // Open in "ate" mode to get the current position
            std::streampos currentSize = infile.tellg(); // Get current size
            std::cout <<currentSize <<" "<<lastPosition<< std::endl;

            if (currentSize > lastPosition) {
                convertAndAppend(inputFile, outputFile, lastPosition); // Append new data to output file
                std::cout << "Updated keyboard_input.txt with new content from " << lastPosition << std::endl;
                
            }
            else if (currentSize < lastPosition)
            {
                convertAndAppend2(inputFile, outputFile, lastPosition); // Append new data to output file
                std::cout << "Updated2 keyboard_input.txt with new content from " << lastPosition << std::endl;
            }
            
            infile.close(); // Close the file
        } 
        else {
            std::cerr << "Input file does not exist!" << std::endl;
        }
    }
}


int main() {
    std::string inputFile = "../input.txt";
    std::string outputFile = "../keyboard_input.txt";
    keyboard_init();
    std::cout << "Monitoring " << inputFile << " for changes..." << std::endl;
    monitorFile(inputFile, outputFile);
    
    // plot_screen("../memory.txt");
    return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include<iostream>
#include <bitset>
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
    std::cout<<"OK"<<"\n";
    while (fgets(line, sizeof(line), file) && A <= 191999) {
        if(A<IO_DISPLAY_START){
            A++;
            continue;
        }
        std::cout<<A<<" "<<line<<"\n";

        // Calculate the actual m position for each bit
        // std::cout<<A<<" "<< IO_DISPLAY_START<<"\n";
        int x=IO_DISPLAY_START;
        int row = (A-x)/ROW_CHAR_SIZE;//(A / ROW_CHAR_SIZE) * CHAR_SIZE + bitIndex; // Each character has 8 rows
        int col = (A-x) % ROW_CHAR_SIZE;
        // std::cout<<(A-x)<<" "<<(A-x)/ROW_CHAR_SIZE<<"\n";
        std::cout<<A<<" start: "<<x<<" r: "<<row<<" c: "<<col<<"\n";
        std::cout<<line<<"\n";
            // Set m based on the character's bit
        for(int i=col*8;i<col*8+8;i++){
            m[row][i]=line[7-(i-8*col)];
        }
        A++; // Move to the next character
        
    }
    fclose(file);

    // Print the visual representation
    for (int r = 0; r < COLUMN_CHAR_SIZE * CHAR_SIZE; r++) {
        for (int c = 0; c < ROW_CHAR_SIZE * CHAR_SIZE; c++) {
            printf("%c ", m[r][c]);
        }
        printf("\n");
    }
    
}

int main() {
    plot_screen("../memory.txt");
    return 0;
}

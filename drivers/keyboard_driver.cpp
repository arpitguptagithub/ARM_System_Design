#ifndef KEYBOARD_DRIVER_H
#define KEYBOARD_DRIVER_H

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include<iostream>
#include "../core/global.h"
#include "../core/memory.cpp"

#define INT_END_POINT 0x2E
#define TEST_INPUT_FILE "keyboard_input.txt" // Define the test input file

/**
 * \brief Initializes keyboard.
 */
void keyboard_init() {
    minit();
    int start = IO_KEYBOARD_START;
    int end = IO_KEYBOARD_START + IO_KEYBOARD_SIZE;
    for (int i = start; i < end; i++) {
        mwrite('\0', i);
    }
}

int keyboard_clear_input() {
    mclose();
    minit();
    mwrite(0, IO_KEYBOARD_START);
    return 0;
}

char keyboard_get_input() {
    char input = 0;
    // keyboard_clear_input();

    while (true) {
        // mclose();
        minit();
        char f = mread_char(IO_KEYBOARD_START);
        if (f != 0) {
            input = f;
            mwrite(0, IO_KEYBOARD_START);
            break;
        }
    }

    return input;
}

int keyboard_get_int() {
    int ans = 0;

    while (true) {
        mclose();
        minit();

        char f = mread_char(IO_KEYBOARD_START);
        mwrite(0, IO_KEYBOARD_START);

        if (f == INT_END_POINT) {
            printf("Keyboard int end\n");
            break;
        } else if (f != 0) {
            printf("Keyboard input: %c\n", f);
            if (f >= '0' && f <= '9') {
                ans = ans * 10 + (f - '0');
            } else if (f == '\b') {
                ans /= 10;
            } else {
                break;
            }
        }
    }

    minit();
    return ans;
}

void convert_keyinput_to_string(char input, char* out) {
    switch (input) {
        case CTRL_CODE_ENTER: {
            out[0] = 'E';
            out[1] = 'N';
            out[2] = 'T';
            out[3] = 'R';
            break;
        }
        case CTRL_CODE_ALT: {
            out[0] = 'A';
            out[1] = 'L';
            out[2] = 'T';
            out[3] = '\0';
            break;
        }
        case CTRL_CODE_SHIFT: {
            out[0] = 'S';
            out[1] = 'H';
            out[2] = 'F';
            out[3] = 'T';
            break;
        }
        default: {
            out[0] = input;
            out[1] = '\0';
            break;
        }
    }
}

char manipulate_input(char c) {
    return c;
}

bool isEscape(char input) {
    return input == 0x1B;
}

/**
 * \brief Function to test the keyboard input simulation.
 */
void keyboard_test() {
    FILE *file = fopen(TEST_INPUT_FILE, "r");
    if (file == NULL) {
        printf("Failed to open input file: %s\n", TEST_INPUT_FILE);
        return;
    }

    char line[10]; // Buffer to hold each line (binary string)
    while (fgets(line, sizeof(line), file)) {
        // Convert binary string to character
        //std::cout<<line;
        char input = (char)strtol(line, NULL, 2); // Convert binary string to char
        char binput= line[0];
        //std::cout<<input<<"\n";
        if (input == 0) continue; // Skip if it's a null input
        printf("keyboard input: %c\n", binput);

        printf("Simulated keyboard input: %c\n", input);
        char t[8];
        for(int i=0;i<8;i++){
            t[i]=line[i];
        }
        // printf("Addr: %c\n",IO_KEYBOARD_START);
        // //std::cout <<"Addr: "<<IO_KEYBOARD_START;
        // mwrite(input, IO_KEYBOARD_START); // Simulate writing to the keyboard input
        dmwrite(t,IO_KEYBOARD_START);
        // Simulate reading the input back
        char output = mread_char(IO_KEYBOARD_START);
        printf("Read from keyboard driver: %c\n", output);
    }

    fclose(file);
}

// int main() {
//     minit(); // Initialize memory file
//     keyboard_init(); // Initialize keyboard
//     keyboard_test(); // Run the test
//     mclose(); // Close memory file
//     return 0;
// }

#endif // KEYBOARD_DRIVER_H

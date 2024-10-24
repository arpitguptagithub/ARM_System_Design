
// #include <stdint.h>
// #include <stdbool.h>
// #include <stdio.h>
// #include <stdlib.h>
// #include <string.h>
#include <assert.h>
// #include <iostream>
#include "global.h"
#include "memory.h"

FILE* fp;

// char => to bits 
void __load_char_as_bits(char c, char* out) {
    int g = c;
    for (int i = 0; i < 8;i++) {
        out[i] = (g & 1) + '0';
        g >>= 1;
    }
}

// read a single character from file
// note: the file is a text file, so we need to convert the char to bits in out
void mread(int addr, char* out) {

    assert(addr >= 0 && addr < MEMORY_SIZE);
    fseek(fp, addr * 9, SEEK_SET);
    fread(out, sizeof(char), 9, fp);

    // assert(out[8] == '\n');
}

char mread_char(int addr) {
    char out[9];
    mread(addr, out);

    char g;
    for (int i = 0;i < 8;i++) {
        g <<= 1;
        g |= out[i] - '0';
    }

    return g;
} 

void mwrite(char c, int addr) {
    //std::cout<<"in mw \n";

    assert(addr >= 0 && addr < MEMORY_SIZE);  // Check if addr is valid
    // //std::cout<<"in mw a \n"<<addr<<"\n";
    fseek(fp, addr * 9, SEEK_SET);  // Move file pointer to the correct location
    // //std::cout<<"in mw fs \n";
    char line[9];    // Holds the original bits
    char tline[9];   // Holds the reversed bits
    line[8] = '\n';  // Ensure the last character is a newline
    tline[8] = '\n'; // The reversed array will also have newline at the end

    __load_char_as_bits(c, line);  // Load character bits into line

    // Reverse the content of line (excluding the last character '\n')
    for (int i = 0; i < 8; i++) {
        tline[i] = line[7 - i];  // Reverse the bits
    }

    // Print the reversed line for debugging
    //std::cout << "in MW (Reversed): " << addr << " " << tline;

    fwrite(tline, sizeof(char), 9, fp);  // Write reversed content to file
    fflush(fp);  // Ensure changes are written immediately
}

void dmwrite(const char c[], int addr){
    assert(addr >= 0 && addr < MEMORY_SIZE);  // Check if addr is valid
    fseek(fp, addr * 9, SEEK_SET);
    char tline[9];   // Holds the reversed bits
      // Move file pointer to the correct location
    tline[8] = '\n'; // The reversed array will also have newline at the end

    // __load_char_as_bits(c, line);  // Load character bits into line

    // Reverse the content of line (excluding the last character '\n')
    for (int i = 0; i < 8; i++) {
        tline[i] = c[i];  // Reverse the bits
    }

    // Print the reversed line for debugging
    //std::cout << "in DMW: " << addr << " " << tline;

    fwrite(tline, sizeof(char), 9, fp);  // Write reversed content to file
    fflush(fp);  // Ensure chang
}


/**
 * @brief initialize the memory. just create a memory file filled with zeroes
 *
*/
void minit() {
    fp = fopen(filename, "r+");
    if (fp == NULL) {
        fp = fopen(filename, "w+");

        for (int i = 0;i < MEMORY_SIZE;i++) {
            char line[9];
            line[8] = '\n';
            __load_char_as_bits(0, line);

            for(int i=0;i<9;i++){
                //std::cout<<line[i]<<"\n";
            }
            fwrite(line, sizeof(char), 9, fp);
        }
    }
}


void mclose() {
    fclose(fp);
}
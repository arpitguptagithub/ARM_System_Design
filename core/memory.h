/**
 * \brief Memory module consists of functions for memory management.
 * Functiolaity includes memory initialization, copying, setting, allocation and freeing.
*/

#ifndef MEMORY_H
#define MEMORY_H

#include <stdio.h>

#include "global.h"

const char* filename = "../memory.txt";
// don't use this directly, use the macros below
char memory[MEMORY_SIZE];

/**
 * @brief write into file at specific col, row
 *  read from file at specific row, col
*/

// char => to bits 
void __load_char_as_bits(char c, char* out);

// read a single character from file
// note: the file is a text file, so we need to convert the char to bits in out
void mread(int addr, char* out);
char mread_char(int addr);
void mwrite(char c, int addr);
void minit();
void mclose();
#endif // MEMORY_H
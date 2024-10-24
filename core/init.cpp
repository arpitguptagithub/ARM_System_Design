/**
 * Initialize the kernel.
*/

#ifndef INIT_H
#define INIT_H

#include <stdint.h>
#include <stdbool.h>

#include "global.h"
#include "memory.cpp"
#include "register.cpp"

void init_memory()
{
    for (int i = 0; i < MEMORY_SIZE; i++)
    {
        mwrite(0, i);
    }
}


#endif
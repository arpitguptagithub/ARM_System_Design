#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include<iostream>
#include "OS_memory.h"
#define INT_END_POINT 46 //(.) char ascii value
int a=0;
int b=0;
int l=0;
char buffer[100];

void keyboard_init() {
    OS_minit();
    int start = IO_KEYBOARD_START;
    int end = IO_KEYBOARD_START + IO_KEYBOARD_SIZE;
    for (int i = start; i < end; i++) {
        OS_mwrite(0, i);
    }
}

int keyboard_clear_input() {
    OS_minit();
    int start = IO_KEYBOARD_START;
    int end = IO_KEYBOARD_START + IO_KEYBOARD_SIZE;
    for (int i = start; i < end; i++) {
        OS_mwrite(0, i);
    }
    return 0;
}

int keyboard_get_input() {
    int input = 0;
    while (true) {
        OS_minit();
        int f = OS_mread(IO_KEYBOARD_START);

        if (f != 0) {
            input = f;
            OS_mwrite(0, IO_KEYBOARD_START);
            break;
        }
    }
    return input;
}

// int keyboard_get_int() {
//     int ans = 0;

//     while (true) {
//         OS_minit();

//         char f = OS_mread(IO_KEYBOARD_START);
//         OS_mwrite(0, IO_KEYBOARD_START);

//         if (f == INT_END_POINT) {
//             // printf("Keyboard int end\n");
//             break;
//         } else if (f != 0) {
//             // printf("Keyboard input: %c\n", f);
//             if (f >= 48 && f <= 57) { //ascii('0')=48 , ascii('9')=57
//                 ans = ans * 10 + (f - 48);
//             } else if (f == 8) {//ascii(backspace)=8
//                 ans /= 10;
//             } else {
//                 break;
//             }
//         }
//     }

//     OS_minit();
//     return ans;
// }

bool isEscape(char input) {
    return input == 0x1B;
}

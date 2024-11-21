// Import required libraries
include "utils.h";
include "font_new.h";

// Constants and configurations
const ROW_CHAR_SIZE = 40;
const COLUMN_CHAR_SIZE = 30;
const SCREEN_LOCK = 0;
const IO_DISPLAY_START = 0;
const SIZE = 2400;

// Global variables
var max_com_len = 10;   // Maximum command length
var LINE = 0;           // Current line (ROW)
var COLUMN = 0;         // Current column
var focus_mode = 0;
var focus_mode_col = 0;
var display = new Array(SIZE).fill(0);

// Function to get ASCII value of a character
function getAsciiValue(c) {
    if (c >= 0 && c <= 127) {
        return c;
    } else {
        return -1; // Invalid character
    }
}

// Clear the screen
function clear_screen() {
    if (SCREEN_LOCK == 0) {
        for (let i = IO_DISPLAY_START + SIZE - 1; i >= IO_DISPLAY_START; i--) {
            display[i] = 0; // Reset display memory
        }
        LINE = 0;
        COLUMN = 0;
    }
}

// Write a character to the current position
function write_char(c) {
    let ascii = getAsciiValue(c);
    if (ascii >= 0) {
        let position = LINE * ROW_CHAR_SIZE + COLUMN;
        if (position < SIZE) {
            display[position] = ascii;
            COLUMN++;
            if (COLUMN >= ROW_CHAR_SIZE) {
                COLUMN = 0;
                LINE++;
                if (LINE >= COLUMN_CHAR_SIZE) {
                    LINE = 0;
                }
            }
            return 0; // Success
        }
    }
    return 1; // Failure
}

// Write a character at a specific position
function write_char_at(c, line, col) {
    let ascii = getAsciiValue(c);
    if (ascii >= 0 && line >= 0 && col >= 0 && line < COLUMN_CHAR_SIZE && col < ROW_CHAR_SIZE) {
        let position = line * ROW_CHAR_SIZE + col;
        display[position] = ascii;
        return 0; // Success
    }
    return 1; // Failure
}

// Save the current screen (dummy implementation for now)
function save_screen() {
    // Implement screen saving logic here
}

// Main program execution (example)
function main() {
    clear_screen();
    write_char('A');
    write_char_at('B', 10, 5);
    save_screen();
}

main();

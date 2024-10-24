// #include <stdio.h>
#include <string.h>
// #include <stdlib.h>
#include <stdbool.h>
/**
 * Memory size is 200kB
 *
 * 1024 X 800 bits
 *
 * 80 (CHARS) X 60
 *
 * 80 characters row wise
 * 60 characters column wise
 *
 * IO_DISPLAY_START = 0
 * display_start = 0
 * IO_DISPLAY_SIZE = 38400 lines (size of display io in bits map divided by 8)
 * display_end = 38400
 * keyboard_start = 38401
 *
 * 80 X 60 X 8 bits = 38400 bits
 *
 * Memory size: 200 kB
 *
 *  display => 38kB
 *  fontmap => 2kB
 *  temp    => 10kB
 *
 * Fontmap:
 *  128 -> 1kilo byte
 *  256 -> 2kilo bytes
 *
 *  presently we have support for 128 ascii codes, but we have reserved other 128 for future purpose.
 *
 */

// #include "../core/memory.cpp"
#include "../core/global.h"
#include "keyboard_driver.cpp"
#include "font_map.h"
#include "font_map_2.h"
#include<iostream>


#define ROW_CHAR_SIZE 80
 // #define ROW_CHAR_SIZE 128
#define COLUMN_CHAR_SIZE 60
// #define COLUMN_CHAR_SIZE 64
#define SCREEN_LOCK 0x00
#define MUL_CONS 9

const int max_com_len = 10; // max command length

int LINE = 0;   // current line (ROW)
int COLUMN = 0; // current column

int focus_mode = 0;
int focus_mode_col = 0;

// prototypes
int write_char(char c);
int write_char_at(char c, int line, int col);
void save_screen();
int write_int(int a);

/**
 * @brief write string array in to the display location currently at.
 * @returns returns 0 on success, otherwise failure. Failure occurs when the fontmap doesn't exist
 * @note supports word wrapping
 */
int write_string(char* msg, int len)
{
    if (SCREEN_LOCK == 0)
    {
        int g = 0;
        for (int i = 0; i < len; i++)
        {
            g = write_char(msg[i]);

            if (g != 0)
            {
                return g;
            }
        }
        return 0;
    }
}

int write_string_at(char* msg, int len, int line, int col)
{
    int g = 0;
    for (int i = 0; i < len; i++)
    {
        g = write_char_at(msg[i], line, col);
        if (g != 0)
        {
            return g;
        }

        col++;
        if (col == ROW_CHAR_SIZE)
        {
            col = 0;
            line += 8;
        }

        if (line == 8 * COLUMN_CHAR_SIZE)
        {
            line = 0;
            col = 0;

            return 1;
        }
    }
    return 0;
}

int write_int(int a) {
    if (SCREEN_LOCK == 0) {
        char temp[10];
        int count = 0;
        while (a > 0) {
            temp[count++] = (a % 10) + '0';
            a /= 10;
        }

        for (int i = count - 1;i >= 0;i--) {
            write_char(temp[i]);
        }

        return 0;
    }

    return 1;
}

int set_cursor_pos(int line, int col)
{
    if (line < 0 || line >= 8 * COLUMN_CHAR_SIZE)
        return 1;
    if (col < 0 || col >= ROW_CHAR_SIZE)
        return 1;

    LINE = line;
    COLUMN = col;

    return 0;
}

void get_cursor_pos(int* vals)
{
    vals[0] = LINE;
    vals[1] = COLUMN;
}

int write_string_at_col(char* msg, int len, int line, int col)
{
    if (SCREEN_LOCK == 0)
    {
        if (line >= 8 * COLUMN_CHAR_SIZE)
            return 1;
        if (col >= ROW_CHAR_SIZE || col < 0)
            return 1;

        int g = 0;
        LINE=line;
        COLUMN=col;
        for (int i = 0; i < len; i++)
        {   //std::cout<<msg[i]<<"\n";
            g = write_char_at(msg[i], LINE, COLUMN);
            if (g != 0)
            {
                return g;
            }

            // col += 1;

            // if (line == 8 * COLUMN_CHAR_SIZE)
            // {
            //     line = 0;
            //     col = 0;

            //     return 1;
            // }

            // if (col == ROW_CHAR_SIZE)
            // {
            //     col = 0;
            //     line += 8;
            // }
        }
    }

    return 1;
}

int write_zero_line_at(int line)
{
    if (SCREEN_LOCK == 0)
    {
        if (line < 0 || line >= 8 * COLUMN_CHAR_SIZE)
            return 1;

        int A = IO_DISPLAY_START + ROW_CHAR_SIZE * line;
        for (int i = 0; i < ROW_CHAR_SIZE * 8; i++)
        {
            mwrite(0, A + i);
        }

        return 0;
    }

    return 1;
}

int write_zero_line()
{
    if (SCREEN_LOCK == 0)
    {
        int A = IO_DISPLAY_START + ROW_CHAR_SIZE * LINE;
        for (int i = 0; i < ROW_CHAR_SIZE * 8; i++)
        {
            mwrite(0, A + i);
        }

        return 0;
    }

    return 1;
}

/**
 * @brief write_char writes a character included in fontmap at the last location
 * @note takes care of word wrapping
 * @returns 1 if not able to write else 0
 */
int write_char(char c)
{
    // use write and read from mem.c
    if (SCREEN_LOCK == 0)
    {

        if (c == '\n')
        {
            COLUMN = 0;
            LINE += 8;
            if (LINE == 8 * COLUMN_CHAR_SIZE)
            {
                LINE = 0;
                COLUMN = 0;

                return 1;
            }

            return 0;
        }
        else if (c == '_') {
            COLUMN++;

            if (COLUMN == ROW_CHAR_SIZE)
            { // if the row is full
                COLUMN = 0;
                LINE += 8;
                if (LINE >= 8 * COLUMN_CHAR_SIZE)
                {
                    LINE = 0;
                    COLUMN = 0;
                    return 1;
                }
            }
        }
        else if (c == '\r')
        {
            COLUMN = 0;
            return 0;
        }
        else if (c == '\f')
        {
            LINE += 8;
            if (LINE >= 8 * COLUMN_CHAR_SIZE)
            {
                LINE = 0;
                COLUMN = 0;
                return 1;
            }

            return 0;
        }
        else if (c == '\t')
        {
            COLUMN += 4;
            if (COLUMN >= ROW_CHAR_SIZE)
            {
                COLUMN = 0;
                LINE += 8;
                if (LINE >= 8 * COLUMN_CHAR_SIZE)
                {
                    LINE = 0;
                    COLUMN = 0;
                    return 1;
                }
            }

            return 0;
        }
        else if (c == CTRL_CODE_BACKSPACE)
        {
            if (COLUMN == 0)
            {
                if (LINE == 0)
                {
                    return 0;
                }
                else
                {
                    COLUMN = ROW_CHAR_SIZE - 1;
                    LINE -= 8;
                }
            }
            else
            {
                COLUMN--;
            }

            int A = IO_DISPLAY_START + ROW_CHAR_SIZE * LINE + COLUMN;
            for (int i = 0; i < 8; i++)
            {
                mwrite(0, A + ROW_CHAR_SIZE * i);
            }

            return 0;
        }
        else
        {
            const char* font[8];
            //std::cout<<font8x8_basic[c];
            for(int i=0;i<8;i++){
                font[i]=font8x8_basic[c][i];
            }

            int A = IO_DISPLAY_START + ROW_CHAR_SIZE * LINE + COLUMN; // location of the first character in the line
            for (int i = 0; i < 8; i++)
            {
                dmwrite(font[i], A + ROW_CHAR_SIZE * i);
            }

            COLUMN++;
            if (COLUMN == ROW_CHAR_SIZE)
            { // if the row is full
                COLUMN = 0;
                LINE += 8;
                return 0;
            }

            if (LINE == 8 * COLUMN_CHAR_SIZE)
            { // if the screen is full
                LINE = 0;
                COLUMN = 0;

                return 1;
            }

            return 0;
        }
    }

    return 1;
}

int write_char_at(char c, int line, int col)
{
    if (SCREEN_LOCK == 0)
    {

        if (line < 0 || line >= 8 * COLUMN_CHAR_SIZE)
            return 1;
        if (col < 0 || col >= ROW_CHAR_SIZE)
            return 1;

        // char font[8];
        // for (int i = 0; i < 8; i++)
        // {
        //     font[i] = font_map[c][i];
        // }
        // const char* font[8];
        // //std::cout<<font8x8_basic[c];
        // for(int i=0;i<8;i++){
        //     font[i]=font8x8_basic[c][i];
        // }

        // int A = IO_DISPLAY_START + ROW_CHAR_SIZE * line + col; // location of the first character in the line
        // for (int i = 0; i < 8; i++)
        // {
        //     dmwrite(font[i], A + ROW_CHAR_SIZE * i);
        // }

        LINE=line;
        COLUMN=col;
        if (c == '\n')
        {   std::cout<<"here"<<'\n';
            COLUMN = 0;
            LINE += 8;
            if (LINE == 8 * COLUMN_CHAR_SIZE)
            {
                LINE = 0;
                COLUMN = 0;

                return 1;
            }

            return 0;
        }
        else if (c == '_') {
            COLUMN++;

            if (COLUMN == ROW_CHAR_SIZE)
            { // if the row is full
                COLUMN = 0;
                LINE += 8;
                if (LINE >= 8 * COLUMN_CHAR_SIZE)
                {
                    LINE = 0;
                    COLUMN = 0;
                    return 1;
                }
            }
        }
        else if (c == '\r')
        {
            COLUMN = 0;
            return 0;
        }
        else if (c == '\f')
        {
            LINE += 8;
            if (LINE >= 8 * COLUMN_CHAR_SIZE)
            {
                LINE = 0;
                COLUMN = 0;
                return 1;
            }

            return 0;
        }
        else if (c == '\t')
        {
            COLUMN += 4;
            if (COLUMN >= ROW_CHAR_SIZE)
            {
                COLUMN = 0;
                LINE += 8;
                if (LINE >= 8 * COLUMN_CHAR_SIZE)
                {
                    LINE = 0;
                    COLUMN = 0;
                    return 1;
                }
            }

            return 0;
        }
        else if (c == CTRL_CODE_BACKSPACE)
        {
            if (COLUMN == 0)
            {
                if (LINE == 0)
                {
                    return 0;
                }
                else
                {
                    COLUMN = ROW_CHAR_SIZE - 1;
                    LINE -= 8;
                }
            }
            else
            {
                COLUMN--;
            }

            int A = IO_DISPLAY_START + ROW_CHAR_SIZE * LINE + COLUMN;
            for (int i = 0; i < 8; i++)
            {
                mwrite(0, A + ROW_CHAR_SIZE * i);
            }

            return 0;
        }
        else
        {
            const char* font[8];
            //std::cout<<font8x8_basic[c];
            for(int i=0;i<8;i++){
                font[i]=font8x8_basic[c][i];
            }

            int A = IO_DISPLAY_START + ROW_CHAR_SIZE * LINE + COLUMN; // location of the first character in the line
            for (int i = 0; i < 8; i++)
            {
                dmwrite(font[i], A + ROW_CHAR_SIZE * i);
            }

            COLUMN++;
            if (COLUMN == ROW_CHAR_SIZE)
            { // if the row is full
                COLUMN = 0;
                LINE += 8;
                return 0;
            }

            if (LINE == 8 * COLUMN_CHAR_SIZE)
            { // if the screen is full
                LINE = 0;
                COLUMN = 0;

                return 1;
            }

            return 0;
        }

        return 0;
    }

    return 1;
}

void write_face(const char* font[128][8])
{
    if (SCREEN_LOCK == 0)
    {
        //std::cout<<"in w_f\n";
        //std::cout<<font[0][0];
        
        LINE += 8;
        COLUMN = 0;

        int A = IO_DISPLAY_START + LINE * ROW_CHAR_SIZE + COLUMN;
        //std::cout<<A<<"\n";

        
        for (int i = 0; i < 128; i++)
        {
            //std::cout<<"in 128 for\n";
            for (int j = 0; j < 8; j++)
            {  
                dmwrite(font[i][j], A + i * ROW_CHAR_SIZE + j);
            }
        }

        LINE += 128;
        COLUMN = 0;

        if (LINE >= 8 * COLUMN_CHAR_SIZE)
        {
            LINE = 0;
            COLUMN = 0;
        }
    }
}

/**
 * \brief Shifts the entire display map by one 1 unit upwards
 */
int display_up()
{
    if (SCREEN_LOCK == 0)
    {
        int A = IO_DISPLAY_START;
        for (int j = 0;j < 8;j++) {
            for (int addr = 0; addr < IO_DISPLAY_SIZE - ROW_CHAR_SIZE; addr++) {
                char temp = mread_char(A + addr + ROW_CHAR_SIZE);
                // reverse temp 
                char temp2 = 0;

                for (int i = 0; i < 8; i++) {
                    if ((temp >> i) & 1) {
                        temp2 |= (1 << (7 - i));
                    }
                }

                mwrite(temp2, A + addr);
            }
        }

        // clear the last line (A)
        for (int i = A+IO_DISPLAY_SIZE - ROW_CHAR_SIZE; i < A+IO_DISPLAY_SIZE; i++)
        {
            mwrite(0, A + i);
        }

        // update the current line
        LINE -= 8;
        if (LINE < 0)
        {
            LINE = 0;
        }

        return 0;
    }

    return 1;
}

/**
 * \brief Shifts the entire display map by one 1 unit downwards
 *
 */
int display_down()
{
    if (SCREEN_LOCK == 0)
    {
        int A = IO_DISPLAY_START;

        for (int j = 0;j < 8;j++) {
            for (int addr = IO_DISPLAY_SIZE - ROW_CHAR_SIZE; addr >= 0; addr--) {
                char temp = mread_char(A + addr);
                // reverse temp his is the memory or buffer that stores pixel data for the display. Each byte in this buffer typically controls 8 
                char temp2 = 0;

                for (int i = 0; i < 8; i++) {
                    if ((temp >> i) & 1) {
                        temp2 |= (1 << (7 - i));
                    }
                }

                mwrite(temp2, A + addr + ROW_CHAR_SIZE);
            }
        }
        // clear the first line (A)
        for (int i = 0; i < ROW_CHAR_SIZE * 8; i++)
        {
            mwrite(0, A + i);
        }

        // update the current line
        LINE += 8;
        if (LINE >= 8 * COLUMN_CHAR_SIZE)
        {
            LINE = 8 * COLUMN_CHAR_SIZE - 1;
        }

        return 0;
    }

    return 1;
}

// reset the entire display
void clear_screen()
{
    if (SCREEN_LOCK == 0)
    {
        int A = IO_DISPLAY_START + IO_DISPLAY_SIZE - 1;
        for (int i = A; i >= IO_DISPLAY_START; i--)
        {
            mwrite(0, i);
        }

        LINE = 0;
        COLUMN = 0;
    }
}

/**
 * commands supported:
 * :xx => not supported becoz we need directory structures
 *
 *
 * 1. q --> exit focus mode
 * 2. w --> save the file
 * 3. wq --> save and exit
 * 4. x --> save and exit
 * 5. i --> insert mode
 * 6. v --> visual mode
 * 7. r --> read mode
 */

 // @brief: display info panel during focus mode (as seen in vim)
 // enable vim like functionality
 // store all the present content and show vim like functionality
int focus_info_panel()
{
    if (SCREEN_LOCK == 0)
    {
        save_screen();
        clear_screen();
        focus_mode = 1;
        focus_mode_col = 0;

        int command_mode = 0;

        int visual_mode = 1;
        int edit_mode = 0;

        while (true)
        {
            char input = keyboard_get_input();
            input = manipulate_input(input);

            if (command_mode == 0)
            {
                if (isEscape(input))
                {
                    command_mode = 1;
                }

                if (visual_mode == 1)
                {
                    if (input == 'i')
                    {
                        visual_mode = 0;
                        edit_mode = 1;
                    }
                }
                else if (edit_mode == 1)
                {
                    // non command mode and write to the display edit screen
                    char content_to_write[4];
                    convert_keyinput_to_string(input, content_to_write);
                    for (int i = 0; i < 4; i++)
                    {
                        if (content_to_write[i] != '\0')
                        {
                            write_char(content_to_write[i]);
                        }
                    }
                }
            }
            else
            {
                // qf: exit focus mode
                // qc: exit command mode and return to visual mode
                // w: save the file
                // wq: save and exit focus mode
            }
        }
    }

    return 1;
}

// save only the visible content of the display while switching to focus mode
void save_screen()
{
    int A = IO_DISPLAY_START;
    int D = TEMP_START;

    for (int i = 0; i < IO_DISPLAY_SIZE; i++)
    {
        char temp = mread_char(A + i);
        mwrite(temp,D + i);////////
    }
}

// retrieve the saved screen from the memory after exiting focus mode
void retrieve_screen()
{
    int A = IO_DISPLAY_START;
    int D = TEMP_START;

    for (int i = 0; i < IO_DISPLAY_SIZE; i++)
    {
        char temp = mread_char(D + i);
        mwrite(temp,A + i );////////////////
    }
}

int set_fontmap(char* filename, int len)
{
    FILE* file = fopen(filename, "r");
    if (file == NULL)
    {
        return 1;
    }

    // TODO: check if the file is valid and set the fontmap accordingly
    return 0;
}

void save_memory(char* filename, int len)
{
    FILE* file = fopen(filename, "w");
    for (int i = 0; i < MEMORY_SIZE; i++)
    {
        char temp[9];

        // Initialize the temp array to 0.
        for (int j = 0; j < 8; j++)
        {
            temp[j] = 0;
        }

        for (int j = 0; j < 8; j++)
        {
            if ((memory[i] >> j) & 1)
            {
                temp[7 - j] = '1';
            }
            else
            {
                temp[7 - j] = '0';
            }
        }

        fwrite(temp, sizeof(char), strlen(temp), file);
        char newline[] ="\n";
        fwrite(newline, sizeof(char), strlen(newline), file);
    }

    fclose(file);
}

int main()
{   minit();
    // init_memory();
    // char* mem_file = "some.txt";
    // save_memory(mem_file, sizeof(mem_file));
    // return 0;
    // //std::cout<<font_map[0][0]<<"\n"<<(int)font_map[0][0];

    // write_face(font_map);

    char f[]="AH||ola \nA jkbjkb";
    // LINE=8;
    // COLUMN=5;
    write_string_at_col("A",1,8,0);
    write_string_at_col("a",1,8,0);
    write_string_at_col("b",1,16,0);
    write_string_at_col("c",1,24,0);

    display_up();
    // LINE=0;
    // COLUMN=1;
    // for(int i=0;i<16;i++){

    //     write_char_at(f[i],LINE,COLUMN);
    // }
    // write_char(keyboard_get_input());


}

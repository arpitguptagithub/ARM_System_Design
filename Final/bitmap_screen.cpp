#include "utils.h"
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
 *  display => 19kB
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
// #include "OS_memory.h"
// #include "Keyboard_ascii_input.cpp"
#include "font_new.h"
// #include<iostream>
// #include <fstream>//
// #include <bitset>//
// #include <vector>//

#define ROW_CHAR_SIZE 64
#define COLUMN_CHAR_SIZE 37
#define SCREEN_LOCK 0
#define IO_DISPLAY_START 0
#define SIZE 4800
int max_com_len = 10; // max command length

int LINE = 0;   // current line (ROW)
int COLUMN = 0; // current column

int focus_mode = 0;
int focus_mode_col = 0;

// prototypes
int write_char(int c);
int write_char_at(char c, int line, int col);
void save_screen();
int write_int(int a);
int display[SIZE]={0};
int getAsciiValue(char c) {
    if (c == 0) return 0;
    else if (c == 1) return 1;
    else if (c == 2) return 2;
    else if (c == 3) return 3;
    else if (c == 4) return 4;
    else if (c == 5) return 5;
    else if (c == 6) return 6;
    else if (c == 7) return 7;
    else if (c == 8) return 8;
    else if (c == 9) return 9;
    else if (c == 10) return 10;
    else if (c == 11 ) return 11;
    else if (c == 12) return 12;
    else if (c == 13) return 13;
    else if (c == 14) return 14;
    else if (c == 15) return 15;
    else if (c == 16) return 16;
    else if (c == 17) return 17;
    else if (c == 18) return 18;
    else if (c == 19) return 19;
    else if (c == 20) return 20;
    else if (c == 21) return 21;
    else if (c == 22) return 22;
    else if (c == 23) return 23;
    else if (c == 24) return 24;
    else if (c == 25) return 25;
    else if (c == 26) return 26;
    else if (c == 27) return 27;
    else if (c == 28) return 28;
    else if (c == 29) return 29;
    else if (c == 30) return 30;
    else if (c == 31) return 31;
    else if (c == ' ') return 32;
    else if (c == '!') return 33;
    else if (c == '"') return 34;
    else if (c == '#') return 35;
    else if (c == '$') return 36;
    else if (c == '%') return 37;
    else if (c == '&') return 38;
    else if (c == '\'') return 39;
    else if (c == '(') return 40;
    else if (c == ')') return 41;
    else if (c == '*') return 42;
    else if (c == '+') return 43;
    else if (c == ',') return 44;
    else if (c == '-') return 45;
    else if (c == '.') return 46;
    else if (c == '/') return 47;
    else if (c == '0') return 48;
    else if (c == '1') return 49;
    else if (c == '2') return 50;
    else if (c == '3') return 51;
    else if (c == '4') return 52;
    else if (c == '5') return 53;
    else if (c == '6') return 54;
    else if (c == '7') return 55;
    else if (c == '8') return 56;
    else if (c == '9') return 57;
    else if (c == ':') return 58;
    else if (c == ';') return 59;
    else if (c == '<') return 60;
    else if (c == '=') return 61;
    else if (c == '>') return 62;
    else if (c == '?') return 63;
    else if (c == '@') return 64;
    else if (c == 'A') return 65;
    else if (c == 'B') return 66;
    else if (c == 'C') return 67;
    else if (c == 'D') return 68;
    else if (c == 'E') return 69;
    else if (c == 'F') return 70;
    else if (c == 'G') return 71;
    else if (c == 'H') return 72;
    else if (c == 'I') return 73;
    else if (c == 'J') return 74;
    else if (c == 'K') return 75;
    else if (c == 'L') return 76;
    else if (c == 'M') return 77;
    else if (c == 'N') return 78;
    else if (c == 'O') return 79;
    else if (c == 'P') return 80;
    else if (c == 'Q') return 81;
    else if (c == 'R') return 82;
    else if (c == 'S') return 83;
    else if (c == 'T') return 84;
    else if (c == 'U') return 85;
    else if (c == 'V') return 86;
    else if (c == 'W') return 87;
    else if (c == 'X') return 88;
    else if (c == 'Y') return 89;
    else if (c == 'Z') return 90;
    else if (c == '[') return 91;
    else if (c == '\\') return 92;
    else if (c == ']') return 93;
    else if (c == '^') return 94;
    else if (c == '_') return 95;
    else if (c == '`') return 96;
    else if (c == 'a') return 97;
    else if (c == 'b') return 98;
    else if (c == 'c') return 99;
    else if (c == 'd') return 100;
    else if (c == 'e') return 101;
    else if (c == 'f') return 102;
    else if (c == 'g') return 103;
    else if (c == 'h') return 104;
    else if (c == 'i') return 105;
    else if (c == 'j') return 106;
    else if (c == 'k') return 107;
    else if (c == 'l') return 108;
    else if (c == 'm') return 109;
    else if (c == 'n') return 110;
    else if (c == 'o') return 111;
    else if (c == 'p') return 112;
    else if (c == 'q') return 113;
    else if (c == 'r') return 114;
    else if (c == 's') return 115;
    else if (c == 't') return 116;
    else if (c == 'u') return 117;
    else if (c == 'v') return 118;
    else if (c == 'w') return 119;
    else if (c == 'x') return 120;
    else if (c == 'y') return 121;
    else if (c == 'z') return 122;
    else if (c == '{') return 123;
    else if (c == '|') return 124;
    else if (c == '}') return 125;
    else if (c == '~') return 126;
    else if (c == 127) return 127;
    else return -1; // Invalid character
}

/**
 * @brief write string array in to the display location currently at.
 * @returns returns 0 on success, otherwise failure. Failure occurs when the fontmap doesn't exist
 * @note supports word wrapping
 */
// int write_string(char* msg, int len)
// {
//     if (SCREEN_LOCK == 0)
//     {
//         int g = 0;
//         for (int i = 0; i < len; i++)
//         {
//             g = write_char(msg[i]);

//             if (g != 0)
//             {
//                 return g;
//             }
//         }
//         return 0;
//     }
// }

// int write_string_at(char* msg, int len, int line, int col)
// {
//     int g = 0;
//     for (int i = 0; i < len; i++)
//     {
//         g = write_char_at(msg[i], line, col);
//         if (g != 0)
//         {
//             return g;
//         }

//         col++;
//         if (col == ROW_CHAR_SIZE)
//         {
//             col = 0;
//             line += 8;
//         }

//         if (line == 8 * COLUMN_CHAR_SIZE)
//         {
//             line = 0;
//             col = 0;

//             return 1;
//         }
//     }
//     return 0;
// }

// int write_int(int a) {
//     if (SCREEN_LOCK == 0) {
//         char temp[10];
//         int count = 0;
//         while (a > 0) {
//             temp[count++] = (a % 10) + '0';
//             a /= 10;
//         }

//         for (int i = count - 1;i >= 0;i--) {
//             write_char(temp[i]);
//         }

//         return 0;
//     }

//     return 1;
// }

// int set_cursor_pos(int line, int col)
// {
//     if (line < 0 || line >= 8 * COLUMN_CHAR_SIZE)
//         return 1;
//     if (col < 0 || col >= ROW_CHAR_SIZE)
//         return 1;

//     LINE = line;
//     COLUMN = col;

//     return 0;
// }

// void get_cursor_pos(int* vals)
// {
//     vals[0] = LINE;
//     vals[1] = COLUMN;
// }



// int write_zero_line_at(int line)
// {
//     if (SCREEN_LOCK == 0)
//     {
//         if (line < 0 || line >= 8 * COLUMN_CHAR_SIZE)
//             return 1;

//         int A = IO_DISPLAY_START + ROW_CHAR_SIZE * line;
//         for (int i = 0; i < ROW_CHAR_SIZE * 8; i++)
//         {
//             memory.write_mem(0, A + i);
//         }

//         return 0;
//     }

//     return 1;
// }

// int write_zero_line()
// {
//     if (SCREEN_LOCK == 0)
//     {
//         int A = IO_DISPLAY_START + ROW_CHAR_SIZE * LINE;
//         for (int i = 0; i < ROW_CHAR_SIZE * 8; i++)
//         {
//             memory.write_mem(0, A + i);
//         }

//         return 0;
//     }

//     return 1;
// }
void clear_screen()
{
    if (SCREEN_LOCK == 0)
    {
        int A = IO_DISPLAY_START+SIZE-1;
        for (int i = A; i >= IO_DISPLAY_START; i--)
        {
            memory.write_mem(i,0);//display[i]=0;
        }

        LINE = 0;
        COLUMN = 0;
    }
}

/**
 * @brief write_char writes a character included in fontmap at the last location
 * @note takes care of word wrapping
 * @returns 1 if not able to write else 0
 */
int write_char(int c)
{
    // use write and read from mem.c
    if (SCREEN_LOCK == 0)
    {

        if (c == 10)// '\n'
        {
            COLUMN = 0;
            LINE += 8;
            if (LINE == 8 * COLUMN_CHAR_SIZE)
            {
                clear_screen();
                LINE = 0;
                COLUMN = 0;

                return 1;
            }

            return 0;
        }
        else if (c == 95) {// '_'
            COLUMN++;

            if (COLUMN == ROW_CHAR_SIZE)
            { // if the row is full
                COLUMN = 0;
                LINE += 8;
                if (LINE >= 8 * COLUMN_CHAR_SIZE)
                {
                    clear_screen();
                    LINE = 0;
                    COLUMN = 0;
                    return 1;
                }
            }
        }
        else if (c == 13)// '\r'
        {
            COLUMN = 0;
            return 0;
        }
        else if (c == 12)// '\f'
        {
            LINE += 8;
            if (LINE >= 8 * COLUMN_CHAR_SIZE)
            {
                clear_screen();
                LINE = 0;
                COLUMN = 0;
                return 1;
            }

            return 0;
        }
        else if (c == 9)// '\t'
        {
            COLUMN += 4;
            if (COLUMN >= ROW_CHAR_SIZE)
            {
                COLUMN = 0;
                LINE += 8;
                if (LINE >= 8 * COLUMN_CHAR_SIZE)
                {
                    clear_screen();
                    LINE = 0;
                    COLUMN = 0;
                    return 1;
                }
            }

            return 0;
        }
        else if (c == 8 )// '\b'
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

            int A = IO_DISPLAY_START + (ROW_CHAR_SIZE * LINE)/4 + COLUMN/4;

            for (int i = 0; i < 8; i++)
            {
                int read = memory.read_mem(A+(ROW_CHAR_SIZE/4)*i);//display[A+(ROW_CHAR_SIZE/4)*i];
                int write = read/256;
                int j=COLUMN%4;
                for(int q=3; q>j;q--){
                    write=write/256;
                }
                memory.write_mem(A+(ROW_CHAR_SIZE/4)*i,write);//display[ A+(ROW_CHAR_SIZE/4)*i]=write;
            }

            return 0;
        }
        else
        {
            int font[8];
            //std::cout<<font_map[c];
            for(int i=0;i<8;i++){
                font[i]=font_map[c][i];
            }

            int A = IO_DISPLAY_START + (ROW_CHAR_SIZE * LINE)/4 + COLUMN/4; // location of the first character in the line
            for (int i = 0; i < 8; i++)
            {
                int read = memory.read_mem(A+(ROW_CHAR_SIZE/4)*i);//display[ A+(ROW_CHAR_SIZE/4)*i];
                int write = font[i];
                int j=COLUMN%4;
                for(int q=3; q>j;q--){
                    write=write*256;
                }
                memory.write_mem(A+(ROW_CHAR_SIZE/4)*i,write+read);  //display[ A+(ROW_CHAR_SIZE/4)*i]=write+read;  
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

int write_char_at(int c, int line, int col){
    if (SCREEN_LOCK == 0)
    {

        if (line < 0 || line >= 8 * COLUMN_CHAR_SIZE){
            return 1;
        }
        if (col < 0 || col >= ROW_CHAR_SIZE){

            return 1;
        }
        LINE=line;
        COLUMN=col;
        write_char(c);
    }
}

int print_string(char msg[])
{
    int len=0;
    while(msg[len]!='\0'){
        len++;
    }
    int e[len];
    for(int i=0;i<len;i++){
        e[i]=getAsciiValue(msg[i]);
    }
    write_string_at_col(e,len, LINE, COLUMN);
}

int write_string_at_col(int msg[], int len, int line=LINE, int col=COLUMN)
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
        }
    }

    return 1;
}


void read_line(char msg[]){
    
}

// /**
//  * commands supported:
//  * :xx => not supported becoz we need directory structures
//  *
//  *
//  * 1. q --> exit focus mode
//  * 2. w --> save the file
//  * 3. wq --> save and exit
//  * 4. x --> save and exit
//  * 5. i --> insert mode
//  * 6. v --> visual mode
//  * 7. r --> read mode
//  */

//  // @brief: display info panel during focus mode (as seen in vim)
//  // enable vim like functionality
//  // store all the present content and show vim like functionality
// int focus_info_panel()
// {
//     if (SCREEN_LOCK == 0)
//     {
//         save_screen();
//         clear_screen();
//         focus_mode = 1;
//         focus_mode_col = 0;

//         int command_mode = 0;

//         int visual_mode = 1;
//         int edit_mode = 0;

//         while (true)
//         {
//             char input = keyboard_get_input();
//             input = manipulate_input(input);

//             if (command_mode == 0)
//             {
//                 if (isEscape(input))
//                 {
//                     command_mode = 1;
//                 }

//                 if (visual_mode == 1)
//                 {
//                     if (input == 'i')
//                     {
//                         visual_mode = 0;
//                         edit_mode = 1;
//                     }
//                 }
//                 else if (edit_mode == 1)
//                 {
//                     // non command mode and write to the display edit screen
//                     char content_to_write[4];
//                     convert_keyinput_to_string(input, content_to_write);
//                     for (int i = 0; i < 4; i++)
//                     {
//                         if (content_to_write[i] != '\0')
//                         {
//                             write_char(content_to_write[i]);
//                         }
//                     }
//                 }
//             }
//             else
//             {
//                 // qf: exit focus mode
//                 // qc: exit command mode and return to visual mode
//                 // w: save the file
//                 // wq: save and exit focus mode
//             }
//         }
//     }

//     return 1;
// }

// // save only the visible content of the display while switching to focus mode
// void save_screen()
// {
//     int A = IO_DISPLAY_START;
//     int D = TEMP_START;

//     for (int i = 0; i < IO_DISPLAY_SIZE; i++)
//     {
//         char temp = memory.read_mem(A + i);
//         memory.write_mem(temp,D + i);////////
//     }
// }

// // retrieve the saved screen from the memory after exiting focus mode
// void retrieve_screen()
// {
//     int A = IO_DISPLAY_START;
//     int D = TEMP_START;

//     for (int i = 0; i < IO_DISPLAY_SIZE; i++)
//     {
//         char temp = memory.read_mem(D + i);
//         memory.write_mem(temp,A + i );////////////////
//     }
// }



// // void save_memory(char* filename, int len)
// // {
// //     FILE* file = fopen(filename, "w");
// //     for (int i = 0; i < MEMORY_SIZE; i++)
// //     {
// //         char temp[9];

// //         // Initialize the temp array to 0.
// //         for (int j = 0; j < 8; j++)
// //         {
// //             temp[j] = 0;
// //         }

// //         for (int j = 0; j < 8; j++)
// //         {
// //             if ((memory[i] >> j) & 1)
// //             {
// //                 temp[7 - j] = '1';
// //             }
// //             else
// //             {
// //                 temp[7 - j] = '0';
// //             }
// //         }

// //         fwrite(temp, sizeof(char), strlen(temp), file);
// //         char newline[] ="\n";
// //         fwrite(newline, sizeof(char), strlen(newline), file);
// //     }

// //     fclose(file);
// // }

// // int main()
// // {   minit();
// //     // init_memory();
// //     // char* mem_file = "some.txt";
// //     // save_memory(mem_file, sizeof(mem_file));
// //     // return 0;
// //     // //std::cout<<font_map[0][0]<<"\n"<<(int)font_map[0][0];

// //     // write_face(font_map);

// //     char f[]="AH||ola \nA jkbjkb";
// //     // LINE=8;
// //     // COLUMN=5;
// //     LINE=0;
// //     COLUMN=1;
// //     for(int i=0;i<16;i++){

// //         write_char_at(f[i],LINE,COLUMN);
// //     }
// //     // write_char(keyboard_get_input());


// // }


// int main() {

//     // Populate display with some example values (for testing)

//     // Open the file
//     write_char(int('a'));
//     write_char(int('l'));
//     write_char(int('l'));
//     write_char(int(' '));
//     write_char(int('I'));
//     write_char(int('S'));
//     write_char(int(' '));
//     write_char(int('W'));
//     write_char(int('e'));
//     write_char(int('l'));
//     write_char(int('l'));
//     write_char(int(' '));
//     write_char(int('1'));
//     write_char(int('\n'));





//     std::ofstream outFile("screen.txt");
//     if (!outFile.is_open()) {
//         std::cerr << "Error: Unable to open file!" << std::endl;
//         return 1;
//     }

//     // Write the array to the file in binary format
//     for (int i = 0; i < SIZE; ++i) {
//         outFile << std::bitset<32>(display[i]) << std::endl;
//     }

//     outFile.close();
//     std::cout << "Screen content written to screen.txt" << std::endl;

//     return 0;
// }

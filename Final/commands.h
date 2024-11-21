#include "string.cpp"
#include "bitmap_screen.cpp"
#include "keyboard_ascii_input.cpp"


void ls(){
    print_string("fibonacci\n");
    print_string("prime\n");
    print_string("sort\n");
    print_string("help\n");
    print_string("sum\n");
    print_string("add\n");
    print_string("helloworld\n");
    print_string("factorial\n");
}

void cat(){
    input();
    if(buffer_size == 0){
        print_string("No file specified\n");
        return;
    }
    if(strcmp(buffer, "fibonacci") == 0){
        print_string("fibonacci\n");
        return;
    }
    if(strcmp(buffer, "prime") == 0){
        print_string("prime\n");
        return;
    }
    if(strcmp(buffer, "sort") == 0){
        print_string("sort\n");
        return;
    }
    if(strcmp(buffer, "help") == 0){
        print_string("help\n");
        return;
    }
    if(strcmp(buffer, "sum") == 0){
        print_string("sum\n");
        return;
    }
    if(strcmp(buffer, "add") == 0){
        print_string("add\n");
        return;
    }
    if(strcmp(buffer, "helloworld") == 0){
        print_string("helloworld\n");
        return;
    }
    if(strcmp(buffer, "factorial") == 0){
        print_string("factorial\n");
        return;
    }
    print_string("No such file\n");
}

void echo(){
    input();
    output();
}

void clear_screen(){
    clear_screen();
}



void help(){
    print_string("ls: list files\n");
    print_string("cat: open file\n");
    print_string("echo: print input\n");
    print_string("clear: clear screen\n");
    print_string("fibonacci: print fibonacci series\n");
    print_string("prime: check if number is prime\n");
    print_string("sort: sort numbers\n");
    print_string("help: print help\n");
    print_string("sum: sum numbers\n");
    print_string("add: add numbers\n");
    print_string("helloworld: print helloworld\n");
    print_string("factorial: calculate factorial\n");
}
#include "keyboard.cpp"
#include "commands.cpp"
#include "memory.cpp"
#include "string.cpp"

char ls[100] = "ls";
char cat[100] = "cat";
char echo[100] = "echo";
char clear[100] = "clear";
char fibonacci[100] = "fibonacci";
char prime[100] = "prime";
char sort[100] = "sort";
char help[100] = "help";
char sum[100] = "sum";
char add[100] = "add";
char helloworld[100] = "helloworld";
char factorial[100] = "factorial";


char buffer[100];
int buffer_index;
int buffer_size;
int number;

void init(){
    keyboard_init();
    clear_screen();
    buffer_index = 0;
    buffer_size = 0;
    number =0;
    write_char('>');
}

void clear_buf(){
    for(int i=0; i<buffer_size; i++){
        buffer[i] = '\0';
    }
    buffer_size = 0;
}
void input(){
    int c;
    //ignore spaces
    while(true){
        c = keyboard_get_input();
        if(c != 32){
            break;
            write-char(c);
        }
    }
    while(true){
        keyboard_get_input();
        if(c == 13){
            buffer[buffer_index] = '\0';
            buffer_size = buffer_index;
            buffer_index = 0;
            write_char(c);
            break;
        }else{
            buffer[buffer_index] = c;
            buffer_index++;
            write_char(c);
        }
    }
    
}

void output(){
    print_string(buffer);
}

bool strcmp(char* str1, char* str2){
    int i = 0;
    while(str1[i] != '\0' && str2[i] != '\0'){
        if(str1[i] != str2[i]){
            return false;
        }
        i++;
    }
    if(str1[i] == '\0' && str2[i] == '\0'){
        return true;
    }
    return false;
}

int main(){
    init();
    while(true){
        input();
        if(buffer[0]>=48 && buffer[0]<=57){
            number = 0;
            for(int i=0; i<buffer_size; i++){
                num = num*10 + (buffer[i] - 48);
            }
            write_int(num);
        }
        if(strcmp(buffer, ls) == 0){
            ls();
        }else if(strcmp(buffer, cat) == 0){
            cat();
        }else if(strcmp(buffer, echo) == 0){
            echo();
        }else if(strcmp(buffer, clear) == 0){
            clear_screen();
        }else if(strcmp(buffer, fibonacci) == 0){
            fibonacci.main();
        }else if(strcmp(buffer, prime) == 0){
            prime.main();
        }else if(strcmp(buffer, sort) == 0){
            sort.main();
        }else if(strcmp(buffer, help) == 0){
            help();
        }else if(strcmp(buffer, sum) == 0){
            sum.main();
        }else if(strcmp(buffer, add) == 0){
            add.main();
        }else if(strcmp(buffer, helloworld) == 0){
            helloworld();
        }else if(strcmp(buffer, factorial) == 0){
            factorial.main();
        }
        else{
            print_string("Command not found", 0);
        }
        write_char('>');
    }
    return 0;
}


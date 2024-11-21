int getasciiValue(char c) {
    return c;
}

char getCharValue(int i) {
    return i;
}

int getDigitValue(char c) {
    return c - 48;
}

char getCharValue(int i) {
    return i + 48;
}

char newLine() {
    return 128;
}

char backSpace() {
    return 129;
}

char doubleQuote() {
    return 34;
}

void printString(char* chars, int len) {
    for (int i = 0; i < len; i++) {
        write_char(chars[i]);
    }
}

void printInt(int number) {
    String str = String.new(10);
    str.setInt(number);
    printString(str.chars, str.length());
    str.dispose();
}

void printChar(char c) {
    write_char(c);
}

void printChar(int i) {
    write_char(i);
}

void printChar(char c, int n) {
    for (int i = 0; i < n; i++) {
        write_char(c);
    }
}

void printChar(int i, int n) {
    for (int j = 0; j < n; j++) {
        write_char(i);
    }
}

void printChar(char c, int n, char end) {
    for (int i = 0; i < n; i++) {
        write_char(c);
    }
    write_char(end);
}

void printChar(int i, int n, char end) {
    for (int j = 0; j < n; j++) {
        write_char(i);
    }
    write_char(end);
}


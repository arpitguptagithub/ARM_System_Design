#include "memory.cpp"
#include "bitmap_screen.cpp"

class String {
    field int len;
    field int maxLen; // Each object has its own set of variables.
    field Array chars;

    // Constructs a new empty String with a maximum length of maxLength.
    constructor String new(int maxLength) {
        if (maxLength == 0) {
            maxLength = 1;
        }
        len = 0;
        maxLen = maxLength;
        chars = Array.new(maxLength);
        return this;
    }

    // De-allocates the string and frees its space.
    method void dispose() {
        chars.dispose();
        return;
    }

    // Returns the current length of this String.
    method int length() {
        return len;
    }

    // Returns the character at location j.
    method char charAt(int j) {
        return chars[j];
    }

    // Sets the j'th character of this string to be c.
    method void setCharAt(int j, char c) {
        chars[j] = c;
        return;
    }

    // Appends the character c to the end of this String.
    // Returns this string as the return value.
    method String appendChar(char c) {
        if (len < maxLen) {
            chars[len] = c;
            len = len + 1;
        }
        return this;
    }

    // Erases the last character from this String.
    method void eraseLastChar() {
        if (len > 0) {
            len = len - 1;
        }
        return;
    }

    // Returns the integer value of this String until the first non-numeric character.
    method int intValue() {
        int intVal = 0;
        int index = 0;
        boolean neg = false;

        if (len > 0 && chars[0] == 45) { // '-' ASCII is 45
            neg = true;
            index = 1;
        }

        while (index < len && String.isDigit(chars[index])) {
            intVal = (intVal * 10) + String.charToDigit(chars[index]);
            index = index + 1;
        }

        if (neg) {
            return -intVal;
        }
        return intVal;
    }

    // Checks if a character is a digit.
    function boolean isDigit(char c) {
        return c >= 48 && c <= 57; // '0'-'9' ASCII is 48-57
    }

    // Converts a character to its numeric value. Assumes input is a digit.
    function int charToDigit(char c) {
        return c - 48; // '0' ASCII is 48
    }

    // Converts a digit (0-9) to its character representation.
    function char digitToChar(int d) {
        return d + 48;
    }

    // Sets this String to hold a representation of the given number.
    method void setInt(int number) {
        len = 0; // Clear string first
        if (number < 0) {
            number = -number;
            appendChar(45); // Append '-'
        }
        setIntHelper(number);
        return;
    }

    method void setIntHelper(int number) {
        if (number < 10) {
            appendChar(String.digitToChar(number));
        } else {
            int nextNum = number / 10;
            setIntHelper(nextNum); // Recursion
            appendChar(String.digitToChar(number - (nextNum * 10)));
        }
        return;
    }

    // Returns the new line character.
    function char newLine() {
        return 128;
    }

    // Returns the backspace character.
    function char backSpace() {
        return 129;
    }

    // Returns the double quote character.
    function char doubleQuote() {
        return 34;
    }

    function void print_String(char* chars, int len) {
        for (int i = 0; i < len; i++) {
            
        }
    }

    function void print_int(int number) {
        String str = String.new(10);
        str.setInt(number);
        printString(str.chars, str.length());
        str.dispose();
    }
}

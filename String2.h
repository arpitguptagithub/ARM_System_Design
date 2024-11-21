class String {
    field int len;
    field int maxLen; // Each object has its own set of variables.
    field Array chars;

    // Constructs a new empty String with a maximum length of maxLength.
    constructor String new(int maxLength) {
        IF (maxLength == 0) {
            maxLength = 1;
        }
        len = 0;
        maxLen = maxLength;
        chars = Array.new(maxLength);
        RETURN this;
    }

    // De-allocates the string and frees its space.
    void dispose() {
        chars.dispose();
        RETURN;
    }

    // Returns the current length of this String.
    int length() {
        RETURN len;
    }

    // Returns the character at location j.
    char charAt(int j) {
        RETURN chars[j];
    }

    // Sets the j'th character of this string to be c.
    void setCharAt(int j, char c) {
        chars[j] = c;
        RETURN;
    }

    // Appends the character c to the end of this String.
    // Returns this string as the return value.
    String appendChar(char c) {
        IF (len < maxLen) {
            chars[len] = c;
            len = len + 1;
        }
        RETURN this;
    }

    // Erases the last character from this String.
    void eraseLastChar() {
        IF (len > 0) {
            len = len - 1;
        }
        RETURN;
    }

    // Returns the integer value of this String until the first non-numeric character.
    int intValue() {
        int intVal = 0;
        int index = 0;
        boolean neg = false;

        IF (len > 0 && chars[0] == 45) { // '-' ASCII is 45
            neg = true;
            index = 1;
        }

        WHILE (index < len && String.isDigit(chars[index])) {
            intVal = (intVal * 10) + String.charToDigit(chars[index]);
            index = index + 1;
        }

        IF (neg) {
            RETURN -intVal;
        }
        RETURN intVal;
    }

    // Checks if a character is a digit.
    boolean isDigit(char c) {
        RETURN c >= 48 && c <= 57; // '0'-'9' ASCII is 48-57
    }

    // Converts a character to its numeric value. Assumes input is a digit.
    int charToDigit(char c) {
        RETURN c - 48; // '0' ASCII is 48
    }

    // Converts a digit (0-9) to its character representation.
    char digitToChar(int d) {
        RETURN d + 48;
    }

    // Sets this String to hold a representation of the given number.
    void setInt(int number) {
        len = 0; // Clear string first
        IF (number < 0) {
            number = -number;
            appendChar(45); // Append '-'
        }
        setIntHelper(number);
        RETURN;
    }

    void setIntHelper(int number) {
        IF (number < 10) {
            appendChar(String.digitToChar(number));
        } ELSE {
            int nextNum = number / 10;
            setIntHelper(nextNum); // Recursion
            appendChar(String.digitToChar(number - (nextNum * 10)));
        }
        RETURN;
    }

    // Returns the new line character.
    char newLine() {
        RETURN 128;
    }

    // Returns the backspace character.
    char backSpace() {
        RETURN 129;
    }

    // Returns the double quote character.
    char doubleQuote() {
        RETURN 34;
    }
}

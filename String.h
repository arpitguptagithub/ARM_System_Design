// Function to calculate string length
function stringLength(string str) {
    int length = 0;
    
    WHILE (str[length] != '\0') {
        length = length + 1;
    }

    RETURN length;
}

// Function to concatenate two strings
function stringConcat(string str1, string str2) {
    int len1 = stringLength(str1);
    int len2 = stringLength(str2);

    // Create a new string to store the result
    string result = allocate char[len1 + len2 + 1];

    // Copy str1 into result
    FOR (int i = 0; i < len1; i++) {
        result[i] = str1[i];
    }

    // Copy str2 into result
    FOR (int j = 0; j < len2; j++) {
        result[len1 + j] = str2[j];
    }

    // Null-terminate the result
    result[len1 + len2] = '\0';

    RETURN result;
}

// Function to compare two strings lexicographically
function stringCompare(string str1, string str2) {
    int i = 0;
    
    WHILE (str1[i] != '\0' AND str2[i] != '\0') {
        IF (str1[i] != str2[i]) {
            RETURN str1[i] - str2[i];  // Return difference in ASCII values
        }
        i = i + 1;
    }

    // If one string is a prefix of the other, compare lengths
    RETURN stringLength(str1) - stringLength(str2);
}



// Function to get a substring from the given string
function substring(string str, int start, int length) {
    string subStr = allocate char[length + 1];
    
    FOR (int i = 0; i < length; i++) {
        subStr[i] = str[start + i];
    }

    // Null-terminate the substring
    subStr[length] = '\0';

    RETURN subStr;
}

// Function to copy a string
function stringCopy(string dest, string src) {
    int i = 0;
    
    WHILE (src[i] != '\0') {
        dest[i] = src[i];
        i = i + 1;
    }

    // Null-terminate the destination string
    dest[i] = '\0';
}

// Function to reverse a string
function stringReverse(string str) {
    int len = stringLength(str);
    int start = 0;
    int end = len - 1;

    WHILE (start < end) {
        // Swap the characters
        char temp = str[start];
        str[start] = str[end];
        str[end] = temp;

        start = start + 1;
        end = end - 1;
    }
}

// Function to find a character in a string
function findCharInString(string str, char ch) {
    int i = 0;

    WHILE (str[i] != '\0') {
        IF (str[i] == ch) {
            RETURN i;
        }
        i = i + 1;
    }

    // Return -1 if character is not found
    RETURN -1;
}





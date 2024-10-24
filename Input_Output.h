// Output Function for integers
function printInt(int value) {
    // Assuming there's a way to interact with system-level output, such as stdout
    systemPrint(value);  // Hypothetical system-level print
}

// Output Function for floating-point numbers
function printFloat(float value) {
    systemPrint(value);  // Prints float
}

// Output Function for doubles
function printDouble(double value) {
    systemPrint(value);  // Prints double
}

// Output Function for strings
function printString(string value) {
    systemPrint(value);  // Prints string
}

// Output Function for booleans
function printBool(BOOL value) {
    IF (value == TRUE) {
        systemPrint("TRUE");
    } ELSE {
        systemPrint("FALSE");
    }
}


// Input Function for integers
function inputInt() {
    int value = systemReadInt();  // Hypothetical system-level input for integers
    RETURN value;
}

// Input Function for floating-point numbers
function inputFloat() {
    float value = systemReadFloat();  // Reads a float from the console
    RETURN value;
}

// Input Function for doubles
function inputDouble() {
    double value = systemReadDouble();  // Reads a double from the console
    RETURN value;
}

// Input Function for strings
function inputString() {
    string value = systemReadString();  // Reads a string from the console
    RETURN value;
}

// Input Function for booleans (assuming input is 'TRUE' or 'FALSE')
function inputBool() {
    string input = systemReadString();  // Reads string input

    IF (input == "TRUE") {
        RETURN TRUE;
    } ELSE {
        RETURN FALSE;
    }
}



class File {
    FILE* filePtr;

    // Open file function
    method openFile(string fileName, string mode) {
        filePtr = systemFileOpen(fileName, mode);  // Hypothetical system call to open file
    }

    // Write to file function
    method writeFile(string data) {
        IF (filePtr != NULL) {
            systemFileWrite(filePtr, data);  // Hypothetical system call to write to file
        }
    }

    // Read from file function
    method readFile() {
        string content;
        IF (filePtr != NULL) {
            content = systemFileRead(filePtr);  // Hypothetical system call to read file
        }
        RETURN content;
    }

    // Close file function
    method closeFile() {
        IF (filePtr != NULL) {
            systemFileClose(filePtr);  // Close the file pointer
        }
    }
}






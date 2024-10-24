// Tejeswar Array Library

// array.length(arr): Returns the size of the array
function Int length(Int[] arr) {
    Int count = 0;
    // Loop through the array until we reach the end
    WHILE (arr[count] != NULL) {  
        count = count + 1;
    }
    RETURN count;
}

// array.sort(arr): Sorts the array in ascending order using Bubble Sort
function void sort(Int[] arr) {
    Int n = length(arr);
    Int i, j;
    Int temp;
    
    FOR (i = 0; i < n - 1; i = i + 1) {
        FOR (j = 0; j < n - i - 1; j = j + 1) {
            IF (arr[j] > arr[j + 1]) {
                // Swap arr[j] and arr[j + 1]
                temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

// array.push(arr, value): Adds a value to the end of the array
function void push(Int[] arr, Int value) {
    Int n = length(arr);
    arr[n] = value;  // Place the value at the next available position
    arr[n + 1] = NULL;  // Mark the new end of the array
}

// array.pop(arr): Removes the last element from the array
function Int pop(Int[] arr) {
    Int n = length(arr);
    
    IF (n == 0) {
        RETURN NULL;  // Array is empty, return NULL
    }
    
    Int lastElement = arr[n - 1];
    arr[n - 1] = NULL;  // Remove the last element
    RETURN lastElement;  // Return the removed element
}

// Tejeswar Math Library

// math.abs(x): Returns the absolute value of a number
function Int abs(Int x) {
    IF (x < 0) {
        RETURN -x;
    }
    RETURN x;
}

// math.sqrt(x): Returns the square root of a number using Newton's method
function Double sqrt(Double x) {
    IF (x < 0) {
        RETURN -1;  // Return error for negative numbers
    }
    
    Double epsilon = 0.000001;
    Double guess = x / 2.0;
    Double result = guess;
    
    WHILE (abs(result * result - x) >= epsilon) {
        result = (result + x / result) / 2.0;
    }
    
    RETURN result;
}

// math.pow(x, y): Returns x raised to the power y
function Double pow(Double x, Int y) {
    Double result = 1;
    Int i;
    
    IF (y == 0) {
        RETURN 1;
    }
    
    FOR (i = 0; i < abs(y); i = i + 1) {
        result = result * x;
    }
    
    IF (y < 0) {
        RETURN 1 / result;  // Handle negative exponents
    }
    
    RETURN result;
}

// math.random(): Generates a random number using Linear Congruential Generator (LCG)
Int seed = 12345;  // Default seed, can be changed
Int m = 2147483647;  // Modulus
Int a = 1664525;  // Multiplier
Int c = 1013904223;  // Increment

function Double random() {
    seed = (a * seed + c) % m;
    RETURN seed / (Double)m;  // Normalize to range [0, 1)
}

// You can also add a function to set the seed for reproducibility
function void setSeed(Int newSeed) {
    seed = newSeed;
}

// math.abs(x): Returns the absolute value of a number
int abs(int x) {
    IF (x < 0) {
        RETURN -x;
    }
    RETURN x;
}

// math.sqrt(x): Returns the square root of a number using Newton's method
float sqrt(float x) {
    IF (x < 0) {
        RETURN -1;  // Return error for negative numbers
    }
    
    float epsilon = 0.000001;
    float guess = x / 2.0;
    float result = guess;
    
    WHILE (abs(result * result - x) >= epsilon) {
        result = (result + x / result) / 2.0;
    }
    
    RETURN result;
}

// math.pow(x, y): Returns x raised to the power y
float pow(float x, int y) {
    float result = 1;
    int i;
    
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
int seed = 12345;  // Default seed, can be changed
int m = 2147483647;  // Modulus
int a = 1664525;  // Multiplier
int c = 1013904223;  // Increment

float random() {
    seed = (a * seed + c) % m;
    RETURN seed / (float)m;  // Normalize to range [0, 1)
}

// You can also add a function to set the seed for reproducibility
void setSeed(int newSeed) {
    seed = newSeed;
}

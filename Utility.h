// Utility Library

// math.abs(x): Returns the absolute value of a number
int abs(int x) {
    IF (x < 0) {
        RETURN -x;
    }
    RETURN x;
}

// math.max(x, y): Returns the maximum of two numbers
int max(int x, int y) {
    IF (x > y) {
        RETURN x;
    }
    RETURN y;
}

// math.min(x, y): Returns the minimum of two numbers
int min(int x, int y) {
    IF (x < y) {
        RETURN x;
    }
    RETURN y;
}

// math.isEven(x): Checks if a number is even
int isEven(int x) {
    IF (x % 2 == 0) {
        RETURN 1; // Return 1 if even
    }
    RETURN 0; // Return 0 if odd
}

// math.isOdd(x): Checks if a number is odd
int isOdd(int x) {
    IF (x % 2 != 0) {
        RETURN 1; // Return 1 if odd
    }
    RETURN 0; // Return 0 if even
}

// math.factorial(n): Returns the factorial of n
int factorial(int n) {
    int result = 1;
    FOR (int i = 1; i <= n; i = i + 1) {
        result = result * i;
    }
    RETURN result;
}

// math.gcd(x, y): Returns the greatest common divisor of x and y
int gcd(int x, int y) {
    WHILE (y != 0) {
        int temp = x % y;
        x = y;
        y = temp;
    }
    RETURN x;
}

// math.lcm(x, y): Returns the least common multiple of x and y
int lcm(int x, int y) {
    int gcdVal = math.gcd(x, y);
    RETURN (x * y) / gcdVal;
}

// math.isPrime(n): Checks if a number is prime
int isPrime(int n) {
    IF (n <= 1) {
        RETURN 0;  // Not prime
    }
    FOR (int i = 2; i * i <= n; i = i + 1) {
        IF (n % i == 0) {
            RETURN 0;  // Not prime
        }
    }
    RETURN 1;  // Prime
}

// math.sqrt(x): Returns the square root of a number using Newton's method
int sqrt(int x) {
    IF (x < 0) {
        RETURN -1;  // Return error for negative numbers
    }

    int epsilon = 1;
    int guess = x / 2;
    int result = guess;

    WHILE (abs(result * result - x) >= epsilon) {
        result = (result + x / result) / 2;
    }

    RETURN result;
}

// math.pow(x, y): Returns x raised to the power y
int pow(int x, int y) {
    int result = 1;
    FOR (int i = 0; i < abs(y); i = i + 1) {
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

int random() {
    seed = (a * seed + c) % m;
    RETURN seed % m;  // Returning an integer value in the range [0, m-1]
}

// Sets the seed for the random number generator
void setSeed(int newSeed) {
    seed = newSeed;
    RETURN;
}

Computer System Design Checkpoint 2 Programming Language
	Sunkugari Tejeswara Reddy,
Umakant.

Language specification: 
     - Language specification to be completed
	1. Core Data Types
Our language supports basic and complex data types, similar to C/C++:
Basic Types:
Int: For whole numbers (int x = 42;).
Float: For single-precision decimal values (float pi = 3.14;).
Double: For double-precision decimal values (double precisionVal = 3.14159;).
Bool: For boolean logic (bool isTrue = true;).
Pointers:
Pointers allow direct memory manipulation (int* ptr = addressOf(variable);).
Dynamic Memory Allocation:
Memory can be dynamically allocated using the allocate keyword and deallocated using free.
2. Syntax and Control Structures
Class and Object-Oriented Features:
Classes are defined using the class keyword. Access modifiers include public, private, and protected.
Methods inside classes are declared with the method keyword, while global functions are defined using function.

class Car {
    public int speed;
    method drive() { /* logic here */ }
}


Control Flow:
Similar to C/C++, but the keywords for loops and conditionals are capitalized to enhance readability:
FOR, WHILE, DO-WHILE, IF, ELSE, SWITCH.
This makes the control flow visually distinct.
FOR (int i = 0; i < 10; i++) {
    IF (i % 2 == 0) {
        print(i + " is even");
    } ELSE {
        print(i + " is odd");
    }
}

Memory Management:
In addition to manual memory management using pointers, an optional garbage collection mechanism is introduced to reduce common errors.
3. Error Handling
Compile-time Errors:
Syntax errors like missing semicolons or type mismatches.
Runtime Errors:
Null pointer dereferencing and out-of-bounds memory access.




     - Compare your language with C/C++
	Similarities:
The syntax for data types (int, float), conditionals (IF, ELSE), and loops (FOR, WHILE) remains largely similar to C/C++, keeping it familiar to developers.
Pointers and direct memory access (addressOf, dereferencing *) are retained, allowing powerful low-level memory manipulation.
Differences:
Control Structure Keywords: Capitalized (FOR, WHILE) for readability, whereas C/C++ uses lowercase (for, while).
Function Definition: Our language separates methods from global functions using explicit method and function keywords, while C/C++ uses generic return types (void, int) for both.
Memory Management: Optional garbage collection complements manual memory allocation, whereas C++ entirely relies on developers to manage memory through new and delete.




     - Give reasoning on Why have you added the features

	Explicit Pointers and Memory Management:
Reasoning: Many errors in C++ stem from poor memory handling (e.g., memory leaks, dangling pointers). Introducing allocate/free simplifies this while keeping the manual aspect for advanced users. An optional garbage collector reduces the burden of memory management.
Capitalized Control Structures:
Reasoning: Capitalizing keywords (FOR, WHILE, etc.) enhances code readability, especially for beginners, making control structures visually distinct from other code elements. This helps developers quickly recognize loops and conditionals.
Separation of Methods and Functions:
Reasoning: Differentiating class methods from global functions improves code clarity, especially in object-oriented programming. It eliminates the confusion between member and non-member functions, making the code easier to maintain and understand.
Garbage Collection:
Reasoning: Introducing garbage collection provides a safeguard for memory management without requiring developers to be explicitly concerned about freeing memory in every case, especially for larger applications.

     - What are the new features or innovations in your language? 

Hybrid Memory Management:
Manual + Garbage Collection: Your language offers both manual memory management with explicit control using allocate/free, as well as automatic garbage collection. This hybrid model gives flexibility and error protection, catering to different developer needs.
Simplified Pointer Syntax:
Pointer Operations: Pointers in your language are easier to manage with the addressOf() function, which explicitly retrieves the memory address of a variable. This makes pointer management more understandable than C++'s & operator, reducing confusion for beginners.
Capitalized Control Structures:
Readable Syntax: Loops and control structures are capitalized (FOR, WHILE, IF), making the code more readable and accessible for those new to programming. This makes it easier to follow the flow of logic.
Function and Method Separation:
Improved Code Organization: By clearly distinguishing between global functions (function) and class methods (method), your language improves the clarity of object-oriented programming. This avoids ambiguity in code readability.
Structured Error Handling:
Explicit Error Messages: The error-handling system is more robust than in C++. It provides specific and user-friendly error messages for each phase of compilation or execution, making debugging more straightforward.

Code 1: Hello World Program
—

function main() {
    print("Hello, World!");
}


—





Code 2: Conditional Statements
—

function checkAge(int age) {
    IF (age >= 18) {
        print("You are eligible to vote.");
    } ELSE {
        print("You are not eligible to vote.");
    }
}



—




Code 3: Loops (FOR Loop)
—

function printEvenNumbers(int limit) {
    FOR (int i = 0; i <= limit; i++) {
        IF (i % 2 == 0) {
            print(i + " is even");
        }
    }
}





—

Code 4: While Loop
—

function countDown(int n) {
    WHILE (n > 0) {
        print(n);
        n--;
    }
    print("Lift off!");
}



—

Code 5: Classes and Objects
—

class Car {
    public int speed;
    public string model;

    method accelerate(int increment) {
        speed += increment;
    }
    
    method showSpeed() {
        print("Current speed: " + speed);
    }
}

function main() {
    object myCar = new Car();
    myCar.speed = 0;
    myCar.model = "Tesla";
    myCar.accelerate(50);
    myCar.showSpeed();
}



—

Code 6: Pointers and Memory Allocation
—

function allocateMemory() {
    int* arr = allocate int[5];
    FOR (int i = 0; i < 5; i++) {
        arr[i] = i * 2;
    }

    // Print the array
    FOR (int i = 0; i < 5; i++) {
        print(arr[i]);
    }

    // Free allocated memory
    free(arr);
}





—

Code 7: Structs
—

struct Point {
    int x;
    int y;
}

function main() {
    Point p;
    p.x = 10;
    p.y = 20;

    print("Point coordinates: (" + p.x + ", " + p.y + ")");
}





—

Code 8: Function with Return Value
—

function add(int a, int b): int {
    return a + b;
}

function main() {
    int result = add(5, 7);
    print("Result: " + result);
}




—

Code 9: Switch Case
—

function dayOfWeek(int day) {
    SWITCH(day) {
        case 1:
            print("Monday");
            BREAK;
        case 2:
            print("Tuesday");
            BREAK;
        case 3:
            print("Wednesday");
            BREAK;
        DEFAULT:
            print("Invalid day");
            BREAK;
    }
}



—

Code 10: Arrays
—

function sumArray(int[] arr, int size): int {
    int sum = 0;
    FOR (int i = 0; i < size; i++) {
        sum += arr[i];
    }
    return sum;
}

function main() {
    int[] numbers = {1, 2, 3, 4, 5};
    int total = sumArray(numbers, 5);
    print("Total sum: " + total);
}



—


Demonstration: Complex Code

Complex Program 1: Inverse of an n x m Matrix

function inverseMatrix(float[][] matrix, int n): float[][] {
    // Check if matrix is square
    IF (n != matrix[0].length) {
        print("Matrix must be square!");
        return null;
    }

    float det = determinant(matrix, n);
    IF (det == 0) {
        print("Matrix is singular, inverse does not exist.");
        return null;
    }

    float[][] adj = adjoint(matrix, n);
    float[][] inv = allocate float[n][n];

    // Calculate the inverse using adjoint and determinant
    FOR (int i = 0; i < n; i++) {
        FOR (int j = 0; j < n; j++) {
            inv[i][j] = adj[i][j] / det;
        }
    }

    return inv;
}

function determinant(float[][] matrix, int n): float {
    // Implement determinant calculation logic here
}

function adjoint(float[][] matrix, int n): float[][] {
    // Implement adjoint matrix logic here
}


Complex Program 2: Height-Balanced Search Tree (HBST) with All Operations

class HBSTNode {
    public int key;
    public HBSTNode left;
    public HBSTNode right;
    public int height;

    method HBSTNode(int k) {
        key = k;
        left = right = null;
        height = 1;  // New node is initially added at height 1
    }
}

class HeightBalancedSearchTree {
    // Helper function to get the height of the node
    method height(HBSTNode node): int {
        IF (node == null) {
            return 0;
        }
        return node.height;
    }

    // Helper function to get the balance factor of the node
    method getBalance(HBSTNode node): int {
        IF (node == null) {
            return 0;
        }
        return height(node.left) - height(node.right);
    }

    // Right rotation function
    method rightRotate(HBSTNode y): HBSTNode {
        HBSTNode x = y.left;
        HBSTNode T2 = x.right;

        // Perform rotation
        x.right = y;
        y.left = T2;

        // Update heights
        y.height = max(height(y.left), height(y.right)) + 1;
        x.height = max(height(x.left), height(x.right)) + 1;

        // Return new root
        return x;
    }

    // Left rotation function
    method leftRotate(HBSTNode x): HBSTNode {
        HBSTNode y = x.right;
        HBSTNode T2 = y.left;

        // Perform rotation
        y.left = x;
        x.right = T2;

        // Update heights
        x.height = max(height(x.left), height(x.right)) + 1;
        y.height = max(height(y.left), height(y.right)) + 1;

        // Return new root
        return y;
    }

    // Insert a node into the tree
    method insert(HBSTNode node, int key): HBSTNode {
        IF (node == null) {
            return new HBSTNode(key);
        }

        IF (key < node.key) {
            node.left = insert(node.left, key);
        } ELSE IF (key > node.key) {
            node.right = insert(node.right, key);
        } ELSE {
            return node;  // Duplicate keys are not allowed in the BST
        }

        // Update the height of the ancestor node
        node.height = 1 + max(height(node.left), height(node.right));

        // Get the balance factor to check if this node became unbalanced
        int balance = getBalance(node);

        // If the node becomes unbalanced, there are 4 cases

        // Left Left Case
        IF (balance > 1 && key < node.left.key) {
            return rightRotate(node);
        }

        // Right Right Case
        IF (balance < -1 && key > node.right.key) {
            return leftRotate(node);
        }

        // Left Right Case
        IF (balance > 1 && key > node.left.key) {
            node.left = leftRotate(node.left);
            return rightRotate(node);
        }

        // Right Left Case
        IF (balance < -1 && key < node.right.key) {
            node.right = rightRotate(node.right);
            return leftRotate(node);
        }

        // Return the unchanged node pointer
        return node;
    }

    // Find the node with the minimum key value (used in deletion)
    method minValueNode(HBSTNode node): HBSTNode {
        HBSTNode current = node;

        // Loop to find the leftmost leaf
        WHILE (current.left != null) {
            current = current.left;
        }

        return current;
    }

    // Delete a node from the tree
    method delete(HBSTNode root, int key): HBSTNode {
        // Perform standard BST deletion
        IF (root == null) {
            return root;
        }

        IF (key < root.key) {
            root.left = delete(root.left, key);
        } ELSE IF (key > root.key) {
            root.right = delete(root.right, key);
        } ELSE {
            // Node with only one child or no child
            IF ((root.left == null) || (root.right == null)) {
                HBSTNode temp = (root.left != null) ? root.left : root.right;

                // No child case
                IF (temp == null) {
                    temp = root;
                    root = null;
                } ELSE {  // One child case
                    *root = *temp;  // Copy the contents of the non-empty child
                }
                free(temp);
            } ELSE {
                // Node with two children
                HBSTNode temp = minValueNode(root.right);
                root.key = temp.key;  // Copy the inorder successor's key
                root.right = delete(root.right, temp.key);  // Delete the inorder successor
            }
        }

        // If the tree had only one node, return
        IF (root == null) {
            return root;
        }

        // Update the height of the current node
        root.height = max(height(root.left), height(root.right)) + 1;

        // Get the balance factor
        int balance = getBalance(root);

        // If the node becomes unbalanced, there are 4 cases

        // Left Left Case
        IF (balance > 1 && getBalance(root.left) >= 0) {
            return rightRotate(root);
        }

        // Left Right Case
        IF (balance > 1 && getBalance(root.left) < 0) {
            root.left = leftRotate(root.left);
            return rightRotate(root);
        }

        // Right Right Case
        IF (balance < -1 && getBalance(root.right) <= 0) {
            return leftRotate(root);
        }

        // Right Left Case
        IF (balance < -1 && getBalance(root.right) > 0) {
            root.right = rightRotate(root.right);
            return leftRotate(root);
        }

        return root;
    }

    // Search for a key in the tree
    method search(HBSTNode root, int key): HBSTNode {
        IF (root == null || root.key == key) {
            return root;
        }

        IF (key < root.key) {
            return search(root.left, key);
        }

        return search(root.right, key);
    }

    // Inorder traversal to print the tree
    method inorder(HBSTNode root) {
        IF (root != null) {
            inorder(root.left);
            print(root.key + " ");
            inorder(root.right);
        }
    }
}

function main() {
    HeightBalancedSearchTree hbst = new HeightBalancedSearchTree();
    HBSTNode root = null;

    // Insert elements into the HBST
    root = hbst.insert(root, 10);
    root = hbst.insert(root, 20);
    root = hbst.insert(root, 30);
    root = hbst.insert(root, 40);
    root = hbst.insert(root, 50);
    root = hbst.insert(root, 25);

    print("Inorder traversal of the HBST:");
    hbst.inorder(root);
    print("\n");

    // Search for an element
    HBSTNode searchResult = hbst.search(root, 30);
    IF (searchResult != null) {
        print("Element 30 found in the tree.");
    } ELSE {
        print("Element 30 not found in the tree.");
    }

    // Delete an element from the HBST
    root = hbst.delete(root, 20);
    print("Inorder traversal after deleting 20:");
    hbst.inorder(root);
    print("\n");
}





class Keyboard {
    field int a;
    field int b;
    field int l;
    field Array buffer;

    // Constants
    static int INT_END_POINT = 46; // ASCII value of '.'

    constructor Keyboard new() {
        let a = 0;
        let b = 0;
        let l = 0;
        let buffer = Array.new(100); // Equivalent to char buffer[100]
        return this;
    }

    // Initializes the keyboard memory.
    method void keyboard_init() {
        do OS_memory.minit();
        var int start, end, i;
        let start = OS_memory.IO_KEYBOARD_START;
        let end = OS_memory.IO_KEYBOARD_START + OS_memory.IO_KEYBOARD_SIZE;

        for (let i = start; i < end; i = i + 1) {
            do OS_memory.mwrite(0, i);
        }
        return;
    }

    // Clears the keyboard input buffer.
    method int keyboard_clear_input() {
        do OS_memory.minit();
        var int start, end, i;
        let start = OS_memory.IO_KEYBOARD_START;
        let end = OS_memory.IO_KEYBOARD_START + OS_memory.IO_KEYBOARD_SIZE;

        for (let i = start; i < end; i = i + 1) {
            do OS_memory.mwrite(0, i);
        }
        return 0;
    }

    // Waits for and retrieves input from the keyboard.
    method int keyboard_get_input() {
        var int input, f;
        let input = 0;

        while (true) {
            do OS_memory.minit();
            let f = OS_memory.mread(OS_memory.IO_KEYBOARD_START);

            if (f != 0) {
                let input = f;
                do OS_memory.mwrite(0, OS_memory.IO_KEYBOARD_START);
                break;
            }
        }
        return input;
    }

    // Checks if the input character is an escape key.
    method boolean isEscape(char input) {
        return input == 0x1B; // Escape key ASCII value
    }
}

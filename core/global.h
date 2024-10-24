/**
 * Global variables, like IO display size, etc.
 * 
 * | OS | stack | heap | display io map | keyboard io map | font map | temp |
 * 
 * Total: 200KB
 * 
 * OS : 100KB
 * stack: 10KB 
 * heap: 40KB
 * Display io map: 38KB
 * keyboard io map: 1B
 * fontmap: 2KB
 * temp: 10KB
*/

#define MEMORY_SIZE 1024 * 200
#define OS_SIZE 1024 * 100
#define OS_START 0
#define OS_END OS_START + OS_SIZE
#define STACK_SIZE 1024 * 10
#define STACK_START OS_END
#define STACK_END STACK_START + STACK_SIZE
#define HEAP_SIZE 1024 * 40
#define HEAP_START STACK_END
#define HEAP_END HEAP_START + HEAP_SIZE
#define IO_DISPLAY_SIZE 1024 * 38
#define IO_DISPLAY_START HEAP_END
#define IO_DISPLAY_END IO_DISPLAY_START + IO_DISPLAY_SIZE
#define IO_KEYBOARD_SIZE 1

#define IO_KEYBOARD_START IO_DISPLAY_END
// seekto=229376 in memory.txt

#define IO_KEYBOARD_END IO_KEYBOARD_START + IO_KEYBOARD_SIZE
#define FONTMAP_SIZE 1024 * 2
#define FONTMAP_START IO_KEYBOARD_END
#define FONTMAP_END FONTMAP_START + FONTMAP_SIZE
#define TEMP_SIZE 1024 * 10
#define TEMP_START FONTMAP_END
#define TEMP_END TEMP_START + TEMP_SIZE

// Keyboard constants
#define KEYBOARD_WAIT_TIME 5

//Control codes

#define CTRL_CODE_BACKSPACE 0x08
#define CTRL_CODE_ENTER 0x0A

#define CTRL_CODE_CTRL 0x11
#define CTRL_CODE_ALT 0x12
#define CTRL_CODE_SHIFT 0x10
#define CTRL_CODE_CAPSLOCK 0x14
#define CTRL_CODE_BACKSPACE 0x08
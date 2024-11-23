# ARM_System_Design
Please make Your own branch of the task and then push in the branch. 


# Keyboard to Display Connection Module

## Overview
This module establishes a connection between a PS/2 keyboard and an HDMI display. The goal is to capture keystrokes from the keyboard, process them, and display the results on the connected display screen. The design integrates keyboard input handling, ASCII conversion, memory management, and HDMI display driving.

---

## Features
- **Keyboard Input**:
  - Handles PS/2 keyboard signals using the `ps2_rx` module.
  - Converts scan codes to ASCII using the `scanToAscii` module.
  - Captures key presses and processes them for display.

- **Display Output**:
  - Drives an HDMI-compatible display using the `DisplayDriver` module.
  - Displays keyboard input visually on the screen.

- **Memory Management**:
  - Uses a memory module to store and retrieve data for display.
  - Syncs keyboard input data with the display memory for visualization.

- **Clock Control**:
  - Generates a secondary clock signal for internal module synchronization.

---

## Input/Output Ports

### Inputs
| Signal   | Width | Description                                |
|----------|-------|--------------------------------------------|
| `sysclk` | 1     | System clock for synchronization.          |
| `reset`  | 1     | Reset signal for initializing the module.  |
| `ps2c`   | 1     | PS/2 clock signal from the keyboard.       |
| `ps2d`   | 1     | PS/2 data signal from the keyboard.        |

### Outputs
| Signal         | Width | Description                                       |
|----------------|-------|---------------------------------------------------|
| `led`          | 4     | Debug LEDs showing keyboard input status.         |
| `TMDSp`        | 3     | HDMI TMDS positive signals for video data.        |
| `TMDSn`        | 3     | HDMI TMDS negative signals for video data.        |
| `TMDSp_clock`  | 1     | HDMI TMDS positive signal for the clock.          |
| `TMDSn_clock`  | 1     | HDMI TMDS negative signal for the clock.          |

---

## Module Descriptions

### Keyboard Input Handling
- **`ps2_rx` Module**:
  - Captures scan codes from the PS/2 keyboard.
  - Signals when a valid scan code is received.

- **State Machine**:
  - Tracks the keyboard's state (lowercase or break state).
  - Triggers ASCII conversion when a scan code is ready.

- **`scanToAscii` Module**:
  - Converts PS/2 scan codes into standard ASCII values.

### Display Output
- **`DisplayDriver` Module**:
  - Drives HDMI-compatible displays using TMDS signals.
  - Outputs the visual representation of keyboard inputs.

- **Display Memory**:
  - Stores and retrieves data for synchronized display updates.

---

## How It Works
1. **Keyboard Input**:
   - PS/2 keyboard sends scan codes via `ps2c` and `ps2d` signals.
   - `ps2_rx` decodes these scan codes and triggers an ASCII conversion.

2. **State Transition**:
   - A state machine monitors the scan codes for key press/release events.
   - Processes ASCII codes and forwards them for storage.

3. **Display Update**:
   - Keyboard input is stored in memory.
   - `DisplayDriver` retrieves memory data and updates the display.

4. **Clock Synchronization**:
   - A clock divider generates a slower clock (`clk`) for internal module operations.

---

## Simulation and Debugging
- **Simulation**:
  - Use a testbench to validate the interaction between the keyboard and the display modules.
  - Monitor the output `led` signals for debugging keyboard input.

- **Debugging Tips**:
  - Check `scan_done_tick` to ensure keyboard input is detected.
  - Verify `key_reg` holds the correct ASCII values after key presses.
  - Use `led` for visual feedback during development.

---
![circuit](https://github.com/user-attachments/assets/3afddbe6-c663-4c42-a1b1-ab63e3ed5803)
## circuit diagram

## Dependencies
- `ps2_rx`: Module to decode PS/2 keyboard signals.
- `scanToAscii`: Converts scan codes to ASCII.
- `DisplayDriver`: Drives the HDMI display.
- `Memory`: Handles memory storage and retrieval.

---

## Future Enhancements
- Support for additional key mappings or modifiers (e.g., Shift, Alt).
- Dynamic screen updates with smoother animations.
- Integration with more sophisticated memory modules for advanced features.


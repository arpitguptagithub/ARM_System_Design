#DEFINE Keyboard_address 250000
#DEFINE Display_start 250001
#DEFINE DisplaySize 19200
#DEFINE Heap_start 4
#DEFINE Stack_start 250000


class Memory {
private:
    static const int HEAP_SIZE = 16384;
    static const int FREE_LIST_SIZE = 2; 

    static int memory[HEAP_SIZE];
    static int freeList[FREE_LIST_SIZE]; 
    static int heapBottom; 
    static int heapBase; 
    static const int LENGTH; 
    static const int NEXT; 
    static const int ALLOC_LENGTH; 

public:
    
    static void init() {
        heapBase = HEAP_SIZE;     
        heapBottom = 2048;
        memset(memory, 0, sizeof(memory));

        freeList[LENGTH] = heapBase - heapBottom; 
        freeList[NEXT] = -1; 
    }

    static int peek(int address) {
        return memory[address];
    }

    static void poke(int address, int value) {
        memory[address] = value;
    }

    static int* bestFit(int size) {
        int* curBlock = freeList;
        int* bestBlock = nullptr;
        int bestSize = heapBase - heapBottom;

        while (curBlock != nullptr) {
            int curSize = curBlock[LENGTH] - 1;

            if (curSize >= size && curSize < bestSize) {
                bestBlock = curBlock;
                bestSize = curSize;
            }

            curBlock = (curBlock[NEXT] == -1) ? nullptr : &memory[curBlock[NEXT]];
        }

        return bestBlock;
    }

    static int alloc(int size) {
        int* foundBlock = bestFit(size);
        if (foundBlock == nullptr) return -1; 

        int result = foundBlock - memory - 1;

        if (foundBlock[LENGTH] > size + 3) {
            int* nextBlock = foundBlock - size - 1;
            nextBlock[NEXT] = foundBlock[NEXT];
            nextBlock[LENGTH] = foundBlock[LENGTH] - size - 1;
            foundBlock[ALLOC_LENGTH] = size + 1;
            freeList[NEXT] = nextBlock - memory;
        } else {
            foundBlock[ALLOC_LENGTH] = foundBlock[LENGTH];
            freeList[NEXT] = foundBlock[NEXT];
        }

        return result;
    }

    static void deAlloc(int object) {
        int size = memory[object - 1];
        object++; 
        int* preBlock = findPreFree(object);

        if (preBlock == nullptr) {
            memory[object - 1] = size;
            memory[object] = freeList[NEXT];
            freeList[NEXT] = object;
        } else {
            if (preBlock - preBlock[LENGTH] == object) {
                preBlock[LENGTH] += size;
            } else {
                memory[object - 1] = size;
                memory[object] = preBlock[NEXT];
                preBlock[NEXT] = object;
            }
        }

        if (object - memory[object - 1] == memory[object]) {
            int* nextBlock = &memory[memory[object]];
            memory[object - 1] += nextBlock[LENGTH];
            memory[object] = nextBlock[NEXT];
        }
    }

    static int* findPreFree(int object) {
        if (freeList[NEXT] < object) {
            return nullptr;
        }

        int* preBlock = freeList;
        while (preBlock[NEXT] != -1 &&
               preBlock[NEXT] < object) {
            preBlock = &memory[preBlock[NEXT]];
        }

        return preBlock;
    }
    
    void write_mem(int address, int value) {
        os_write_mem(address, value);
    }

    int read_mem(int address) {
        return os_read_mem(address);
    }

    int* read_mem(int address, int size) {
        int* result = new int[size];
        for (int i = 0; i < size; i++) {
            result[i] = memory[address + i];
        }
        return result;
    }
};




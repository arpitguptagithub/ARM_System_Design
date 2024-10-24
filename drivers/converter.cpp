#include "font_map.h"
#include <fstream>
#include <iostream>
#include <iomanip>
#include <sstream>
#include <bitset>  // Include this header for std::bitset

int main() {
    std::ofstream outFile("font_map_2.h");

    if (!outFile.is_open()) {
        std::cerr << "Error opening output file!" << std::endl;
        return 1;
    }

    outFile << "const char* font8x8_basic[128][8] = {" << std::endl;

    for (int c = 0; c < 128; ++c) {
        outFile << "    /* U+" << std::uppercase << std::hex << std::setw(4) << std::setfill('0') << c 
                << " (" << (c == 0 ? "null" : "") << ") */" << std::endl;
        
        outFile << "    {";

        for (int i = 0; i < 8; ++i) {
            // Convert each byte to a binary string
            std::string binaryString = std::bitset<8>(font_map[c][i]).to_string();
            outFile << "\"" << binaryString << "\"";
            if (i < 7) outFile << ",";
        }

        outFile << "}," << std::endl;
    }

    outFile << "};" << std::endl;
    outFile.close();

    std::cout << "Conversion complete! Output written to font_map_2.h." << std::endl;

    return 0;
}

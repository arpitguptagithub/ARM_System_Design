# reads input file, calls a fn to translate it and prints it to a file

import sys
from ARMv7aVM import ARMv7aVMTranslator

def main():
    if len(sys.argv) != 2:
        print("Usage: python Engine.py <input_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = input_file.rsplit('.', 1)[0] + '.asm'

    translator = ARMv7aVMTranslator()

    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        vm_code = infile.read()
        asm_code = translator.translate(vm_code)
        outfile.write(asm_code)

    print(f"Translation complete. Output written to {output_file}")

if __name__ == "__main__":
    main()

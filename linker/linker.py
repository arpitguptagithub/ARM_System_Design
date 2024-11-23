class Symbol:
    def __init__(self, name, address, is_defined=False):
        self.name = name
        self.address = address
        self.is_defined = is_defined

    def __repr__(self):
        return f"Symbol(name={self.name}, address={self.address}, is_defined={self.is_defined})"

def load_object_file(filename):
    symbols = []
    references = []
    content = []
    with open(filename, 'r') as file:
        for line in file:
            parts = line.strip().split()
            if len(parts) == 2:
                if parts[0] == 'R':
                    references.append(parts[1])
                    content.append(f"R {parts[1]}")
                else:
                    symbols.append(Symbol(parts[0], parts[1], is_defined=True))
                    content.append(f"{parts[0]} {parts[1]}")
    return symbols, references, content

def build_global_symbol_table(object_files):
    global_symbol_table = {}
    references_list = []
    content_list = []

    # First pass: Add defined symbols to the symbol table
    for obj_file in object_files:
        symbols, references, content = load_object_file(obj_file)
        for symbol in symbols:
            if symbol.name in global_symbol_table:
                raise Exception(f"Symbol conflict: {symbol.name} defined multiple times")
            global_symbol_table[symbol.name] = symbol
        references_list.extend(references)
        content_list.extend(content)

    # Second pass: Add references to the symbol table if they are not already defined
    for ref in references_list:
        if ref not in global_symbol_table:
            global_symbol_table[ref] = Symbol(ref, "UNDEFINED", is_defined=False)

    return global_symbol_table, content_list

def resolve_references(content_list, global_symbol_table):
    resolved_content = []
    for line in content_list:
        parts = line.strip().split()
        if len(parts) == 2 and parts[0] == 'R':
            ref = parts[1]
            if ref not in global_symbol_table or not global_symbol_table[ref].is_defined:
                raise Exception(f"Undefined symbol: {ref}")
            resolved_content.append(f"R {global_symbol_table[ref].address}")
        else:
            resolved_content.append(line)
    return resolved_content

def generate_output_file(resolved_content, output_filename):
    with open(output_filename, 'w') as file:
        for line in resolved_content:
            file.write(line + "\n")
    print(f"Output written to {output_filename}")

def main():
    object_files = ['file1.obj', 'file2.obj']
    
    # Build global symbol table and collect content
    global_symbol_table, content_list = build_global_symbol_table(object_files)
    
    print("Global Symbol Table:")
    for name, symbol in global_symbol_table.items():
        print(symbol)
    
    # Resolve references in the content
    resolved_content = resolve_references(content_list, global_symbol_table)
    
    # Generate the output linked file
    generate_output_file(resolved_content, "linked_output.obj")

if __name__ == "__main__":
    main()

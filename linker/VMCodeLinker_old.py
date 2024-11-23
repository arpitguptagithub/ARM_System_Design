
# import os
import re
class VMCodeLinker:
  def __init__(self,files):
    self.glob_init_code = "label glob_init\n"
    self.var_table = {}
    self.func_table = {}
    self.vm_code = ""
    self.glob_init_bodies = []
    self.input_vmcodes = [open(file,"r").read() + "\n" for file in (files if isinstance(files, list) else [files])]
    self.target_name = "".join(vmcode.split(".")[0]+"_" for vmcode in files)[:-1]+".vm"
    self.close = lambda : open(self.target_name,"w").write(self.vm_code)

  def get_glob_init_body(self,vmcode,next_label):
    try:
      body = re.search(r"glob_init:\s*([\s\S]*)\s*end_init:\s*",vmcode).group(1)
      return body.replace("return_init","goto "+next_label)
    except:
      return f"goto {next_label}\n" # Return empty body if glob_init not found
  
  def generate_glob_init_code(self):
    for i, vmcode in enumerate(self.input_vmcodes):
      self.glob_init_code += self.get_glob_init_body(vmcode,f"return_glob_init_{i}")
      self.glob_init_code += f"label return_glob_init_{i}\n  "
    self.glob_init_code = self.glob_init_code.replace("end_init:","")
    self.glob_init_code = self.glob_init_code.replace("label glob_init","")
    # self.glob_init_code = "glob_init:\n" + self.glob_init_code + "\n b start_run\n"
    target_fun="main"
    arg_size = self.func_table[target_fun]['size'] if target_fun in self.func_table else 0
    
    main_call_code=[
      f"",
      f"call main {arg_size}",
      f"label end",
      "b end"
    ]
    main_call_code_str="\n".join(main_call_code)
    # print(main_call_code_str)
    self.glob_init_code = "label glob_init\n" + self.glob_init_code + main_call_code_str + "\n"
    # self.glob_init_code = "label glob_init\n" + self.glob_init_code + "\n\n"

  def generate_symbol_table(self):
    # parse vmcodes to get symboltables
    for vmcode in self.input_vmcodes:
      local_symboltable = re.search(r"Symboltable:\s*([\s\S]*)\s*VM:\s*",vmcode).group(1)
      # split local_symboltable into variables and functions
      variables = re.search(r"Variable:\s*([\s\S]*?)(?=\s*Function:|$)",local_symboltable)
      functions = re.search(r"Function:\s*([\s\S]*?)(?=\s*$)",local_symboltable)
      
      # parse variables
      if variables:
        for line in variables.group(1).strip().split('\n'):
          line = line.strip()
          if line and not line.startswith('//'):
            name, size, defined = line.split()
            if name in self.var_table:
              if self.var_table[name]["size"] != int(size):
                raise Exception(f"Variable {name} has different sizes in different files")
              if self.var_table[name]["defined"] == 1 and int(defined) == 1: 
                raise Exception(f"Variable {name} is already defined in {vmcode}")
              self.var_table[name]["defined"] = max(self.var_table[name]["defined"],int(defined))
            else:
              self.var_table[name] = {"size": int(size), "defined": int(defined)}

      # parse functions  
      if functions:
        for line in functions.group(1).strip().split('\n'):
          line = line.strip()
          if line and not line.startswith('//'):
            name, size, defined = line.split()
            function_exists = bool(re.search(rf'function\s+{name}\s', vmcode))
            if int(defined) == 1 and not function_exists:
              raise Exception(f"Function {name} is marked as defined but not found in {vmcode}")
            if int(defined) == 0 and function_exists:
              raise Exception(f"Function {name} is marked as not defined but found in {vmcode}")  
            if name in self.func_table:
              if self.func_table[name]["size"] != int(size):
                raise Exception(f"Function {name} has different input sizes in different files")
              if self.func_table[name]["defined"] == 1 and int(defined) == 1: 
                raise Exception(f"Function {name} is already defined in {vmcode}")
              self.func_table[name]["defined"] = max(self.func_table[name]["defined"],int(defined))
            else:
              self.func_table[name] = {"size": int(size), "defined": int(defined)}

  def generate_symbol_table_str(self):
    symbol_table_str = "Symboltable:\n"
    self.generate_symbol_table()
    
    # Generate symbol table section
    symbol_table_str = "Symboltable:\n"
    symbol_table_str += "  Variable:\n"
    for name, info in self.var_table.items():
        symbol_table_str += f"    {name} {info['size']} {info['defined']}\n"
    symbol_table_str += "  Function:\n" 
    for name, info in self.func_table.items():
        symbol_table_str += f"    {name} {info['size']} {info['defined']}\n"
            
    # Combine symbol table and VM code
    return symbol_table_str

  def get_codes(self,vmcode):
    a = re.search(r"VM:\s*([\s\S]*)\s*$",vmcode).group(1)
    return re.sub(r"glob_init:\s*([\s\S]*)\s*end_init:\s*", "", a)
  
  def link(self):
    self.generate_glob_init_code()  
    # self.vm_code =  self.generate_symbol_table_str() + "\n" + self.glob_init_code + "\nFinal_codes:\n"
    self.vm_code =  self.generate_symbol_table_str() + "\n" + self.glob_init_code + "\n\n"
    for code in self.input_vmcodes:
      self.vm_code += self.get_codes(code)
    
def main():
  vm_linker = VMCodeLinker(["vmcode1.vm","vmcode2.vm"])
  vm_linker.link()
  vm_linker.close()

if __name__ == "__main__":
    main()

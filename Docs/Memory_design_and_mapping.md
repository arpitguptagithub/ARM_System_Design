# Memory Design and Mapping

we are planning to store address of all stacks in each register and use them as a pointer to the stack.
and for compute only first 4 registers are used.


## Memory Layout and execution mechanism

### segments
- VMStack(the data stack / operand stack):
- VMLocal(local variables: changes with function calls):
- VMArgument(function arguments: changes with function calls):
- VMtemp (temporary storage fixed size)
- static (static pointer access and basepointers of stacks)
- 
push segment index:  push the value of segment[index] onto the stack  `stack.push(segment[index])`  
pop segment index:   pop the top stack value and store it in segment[índex] : `segment[index] = stack.pop()`
wmem segment index:  store the top stack value in memory[segment[index]] : `memory[segment[index]] = stack.pop()`
rmem segment index:  push the value of memory[segment[index]] onto the stack : `stack.push(memory[segment[index]])`

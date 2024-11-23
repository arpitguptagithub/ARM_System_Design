# Specification of VM Code

## Arithmetic Commands
only integer arithmetic is supported from processor
- `add<type>`
- `sub<type>`
- `and<type>`
- `mul<type>`
- `div<type>`
- `or`
- `not`
- `eq`
- `gt`
- `lt`

## Memory Access Commands (Stack to Segments)
- `push <segment> <offset>`
- `pop <segment> <offset>`
- `wmem <segment> <offset>`
- `rmem <segment> <offset>`

## Branching Commands (Program Flow)
- `label <symbol>:`
- `goto <symbol>`
- `if-goto <symbol>`#pop the top of the stack and compare it with 0, if it is 0, jump to the label, otherwise continue

## Function Commands
- `function <function_name> <number_of_locals>` (declaration)
- `call <function_name> <number_of_arguments>` (call)
- `return` (return from function)

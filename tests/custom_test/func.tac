111100
Symboltable:
Variable:

Function:
factorial 1 1
main 0 1

VM:
label glob_init

return_init
end_init

factorial: INT
-  arg INT n
@t0 = 1 INT
@t1 = n <= @t0 INT
@t2 = ~ @t1 INT
if @t2 GOTO #L2
@t2 = 1 INT
return @t2 INT
GOTO #L1
#L2:
#L1:
@t1 = 1 INT
@t3 = n - @t1 INT
param @t3 INT
@t4 = @call factorial 1
@t5 = n * @t4 INT
return @t5 INT
end: 

main: INT
@t4 = 10 INT
param @t4 INT
@t5 = @call factorial 1
- INT x
x = @t5 INT
@t5 = 0 INT
return @t5 
end: 


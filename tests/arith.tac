Symboltable:
Variable:

Function:
main 0 1

VM:
label glob_init

return_init
end_init

main: INT
@t0 = 10 INT
- INT x
x = @t0 INT
@t1 = 10 INT
- INT y
y = @t1 INT
- INT z
@t2 = 10 INT
@t3 = 20 INT
@t5 = ~ x INT
@t4 = @t3 INT
if @t5 GOTO #L2
@t4 = @t2 INT
#L2:
z = @t4 INT
z = z + x INT
z = z + 1 INT
@t5 = z INT
x = @t5 INT
@t4 = z INT
z = z - 1 INT
y = @t4 INT
@t6 = 0 INT
return @t6 
end: 


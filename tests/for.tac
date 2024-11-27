00101510450
Symboltable:
Variable:

Function:
main 0 1

VM:
label glob_init

return_init
end_init

main: INT
@t0 = 0 INT
- INT i
i = @t0 INT
@t1 = 0 INT
i = @t1 INT
#L1:
@t2 = 10 INT
@t3 = i < @t2 INT
@t4 = ~ @t3 INT
if @t4 GOTO #L3 else GOTO #L2
#L4:
@t4 = 1 INT
@t3 = i + @t4 INT
i = @t3 INT
GOTO #L1
#L2:
@t3 = 5 INT
- INT a
a = @t3 INT
@t5 = 10 INT
- INT b
b = @t5 INT
@t6 = a + b INT
- INT z
z = @t6 INT
@t6 = 4 INT
@t7 = i == @t6 INT
@t8 = ~ @t7 INT
if @t8 GOTO #L8
GOTO #L4
GOTO #L7
#L8:
#L7:
@t8 = 5 INT
@t7 = i == @t8 INT
@t9 = ~ @t7 INT
if @t9 GOTO #L10
GOTO #L3
GOTO #L9
#L10:
#L9:
GOTO #L4
#L3:
@t9 = 0 INT
return @t9 
end: 


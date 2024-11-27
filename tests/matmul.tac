Symboltable:
Variable:

Function:
main 0 1

VM:
label glob_init

return_init
end_init

main: INT
- INT a[4]
a[0] = 1 INT
a[1] = 2 INT
a[2] = 1 INT
a[3] = 2 INT
- INT b[4]
b[0] = 2 INT
b[1] = 1 INT
b[2] = 2 INT
b[3] = 1 INT
- INT c[4]
@t0 = 0 INT
- INT i
i = @t0 INT
@t1 = 0 INT
- INT j
j = @t1 INT
@t2 = 0 INT
- INT k
k = @t2 INT
@t3 = 0 INT
i = @t3 INT
#L1:
@t4 = 2 INT
@t5 = i < @t4 INT
@t6 = ~ @t5 INT
if @t6 GOTO #L3 else GOTO #L2
#L4:
@t6 = 1 INT
@t5 = i + @t6 INT
i = @t5 INT
GOTO #L1
#L2:
@t5 = 0 INT
j = @t5 INT
#L6:
@t7 = 2 INT
@t8 = j < @t7 INT
@t9 = ~ @t8 INT
if @t9 GOTO #L8 else GOTO #L7
#L9:
@t9 = 1 INT
@t8 = j + @t9 INT
j = @t8 INT
GOTO #L6
#L7:
@t8 = 0 INT
- INT sum
sum = @t8 INT
@t10 = 0 INT
k = @t10 INT
#L11:
@t11 = 2 INT
@t12 = k < @t11 INT
@t13 = ~ @t12 INT
if @t13 GOTO #L13 else GOTO #L12
#L14:
@t13 = 1 INT
@t12 = k + @t13 INT
k = @t12 INT
GOTO #L11
#L12:
@t12 = k INT
@t14 = i * 2 INT
@t14 = @t14 + @t12 INT
@t15 = a[@t14] INT
@t16 = i INT
@t12 = k * 2 INT
@t12 = @t12 + @t16 INT
@t17 = b[@t12] INT
@t18 = @t15 * @t17 INT
@t16 = sum + @t18 INT
sum = @t16 INT
GOTO #L14
#L13:
@t15 = j INT
@t17 = i * 2 INT
@t17 = @t17 + @t15 INT
@t18 = c[@t17] INT
@t18 = sum INT
GOTO #L9
#L8:
GOTO #L4
#L3:
@t16 = 0 INT
return @t16 
end: 


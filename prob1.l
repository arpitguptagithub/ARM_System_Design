D			[0-9]       // Decimal digit (0-9)
L			[a-zA-Z_]   // Letters (uppercase, lowercase) or underscore
H			[a-fA-F0-9] // Hexadecimal digit (0-9, a-f, A-F)
E			[Ee][+-]?{D}+  // Exponent part in scientific notation (E or e, optional sign, followed by digits)
FS			(f|F|l|L)  // Floating point or long specifiers
IS			(u|U|l|L)* // Integer or size specifiers

%{
#include <stdio.h>
#include "y.tab.h"

// Function to count characters in the input
void count();
%}

%%
"/*"			{ comment(); }  // Start of a multi-line comment
"auto"			{ count(); return(AUTO); }  // 'auto' keyword in C/C++
"break"			{ count(); return(BREAK); } // 'break' keyword to exit loops or switch cases
"case"			{ count(); return(CASE); }  // 'case' keyword for switch statements
"char"			{ count(); return(CHAR); }  // 'char' keyword for character data type
"class"			{ count(); return(CLASS); } // 'class' keyword for defining a class in C++
"const"			{ count(); return(CONST); } // 'const' keyword for constant variables
"continue"		{ count(); return(CONTINUE); } // 'continue' keyword to skip current iteration of a loop
"default"		{ count(); return(DEFAULT); } // 'default' keyword for switch statement
"delete"		{ count(); return(DELETE); } // 'delete' keyword for deallocating memory in C++
"do"			{ count(); return(DO); } // 'do' keyword for do-while loops
"double"		{ count(); return(DOUBLE); } // 'double' keyword for double precision floating point numbers
"else"			{ count(); return(ELSE); } // 'else' keyword for alternative condition in if statements
"enum"			{ count(); return(ENUM); } // 'enum' keyword for defining enumerations
"extern"		{ count(); return(EXTERN); } // 'extern' keyword for declaring external variables
"float"			{ count(); return(FLOAT); } // 'float' keyword for floating point data type
"for"			{ count(); return(FOR); } // 'for' keyword for loops
"friend"		{ count(); return(FRIEND); } // 'friend' keyword for C++ classes
"goto"			{ count(); return(GOTO); } // 'goto' keyword for unconditional jumps
"if"			{ count(); return(IF); } // 'if' keyword for conditional branching
"int"			{ count(); return(INT); } // 'int' keyword for integer data type
"long"			{ count(); return(LONG); } // 'long' keyword for long integer types
"main"			{ count(); return(MAIN); } // 'main' function identifier
"namespace"		{ count(); return(NAMESPACE); } // 'namespace' keyword for C++ namespaces
"new"			{ count(); return(NEW); } // 'new' keyword for dynamic memory allocation in C++
"operator"		{ count(); return(OPERATOR); } // 'operator' keyword for operator overloading in C++
"private"		{ count(); return(PRIVATE); } // 'private' keyword for C++ class access specifier
"protected"		{ count(); return(PROTECTED); } // 'protected' keyword for C++ class access specifier
"public"		{ count(); return(PUBLIC); } // 'public' keyword for C++ class access specifier
"register"		{ count(); return(REGISTER); } // 'register' keyword for register variables
"return"		{ count(); return(RETURN); } // 'return' keyword to exit from a function
"short"			{ count(); return(SHORT); } // 'short' keyword for short integer type
"signed"		{ count(); return(SIGNED); } // 'signed' keyword for signed integer type
"sizeof"		{ count(); return(SIZEOF); } // 'sizeof' keyword for determining the size of a data type
"static"		{ count(); return(STATIC); } // 'static' keyword for static variables or functions
"struct"		{ count(); return(STRUCT); } // 'struct' keyword for defining a structure
"switch"		{ count(); return(SWITCH); } // 'switch' keyword for multi-way branching
"template"		{ count(); return(TEMPLATE); } // 'template' keyword for defining templates in C++
"this"			{ count(); return(THIS); } // 'this' pointer in C++
"throw"			{ count(); return(THROW); } // 'throw' keyword for exceptions
"try"			{ count(); return(TRY); } // 'try' keyword for exception handling
"typedef"		{ count(); return(TYPEDEF); } // 'typedef' keyword for type definition
"union"			{ count(); return(UNION); } // 'union' keyword for unions
"unsigned"		{ count(); return(UNSIGNED); } // 'unsigned' keyword for unsigned integers
"using"			{ count(); return(USING); } // 'using' keyword for importing namespaces or type aliases
"virtual"		{ count(); return(VIRTUAL); } // 'virtual' keyword for virtual functions in C++
"void"			{ count(); return(VOID); } // 'void' keyword for empty data type or function return type
"volatile"		{ count(); return(VOLATILE); } // 'volatile' keyword for volatile variables
"while"			{ count(); return(WHILE); } // 'while' keyword for loops

{L}({L}|{D})*		{ count(); return(check_type()); } // Identifier (starting with a letter, followed by letters or digits)

0[xX]{H}+{IS}?		{ count(); return(CONSTANT); } // Hexadecimal constant
0{D}+{IS}?		{ count(); return(CONSTANT); } // Octal or decimal constant
{D}+{IS}?		{ count(); return(CONSTANT); } // Decimal constant
L?'(\\.|[^\\'])+'	{ count(); return(CONSTANT); } // Character constant

{D}+{E}{FS}?		{ count(); return(CONSTANT); } // Floating-point constant with exponent
{D}*"."{D}+({E})?{FS}?	{ count(); return(CONSTANT); } // Floating-point constant with decimal point
{D}+"."{D}*({E})?{FS}?	{ count(); return(CONSTANT); } // Floating-point constant with leading digit

L?\"(\\.|[^\\"])*\"	{ count(); return(STRING_LITERAL); } // String literal

"..."			{ count(); return(ELLIPSIS); } // Ellipsis '...'
">>="			{ count(); return(RIGHT_ASSIGN); } // Right shift assignment '>>='
"<<="			{ count(); return(LEFT_ASSIGN); } // Left shift assignment '<<='
"+="			{ count(); return(ADD_ASSIGN); } // Addition assignment '+='
"-="			{ count(); return(SUB_ASSIGN); } // Subtraction assignment '-='
"*="			{ count(); return(MUL_ASSIGN); } // Multiplication assignment '*='
"/="			{ count(); return(DIV_ASSIGN); } // Division assignment '/='
"%="			{ count(); return(MOD_ASSIGN); } // Modulus assignment '%='
"&="			{ count(); return(AND_ASSIGN); } // Bitwise AND assignment '&='
"^="			{ count(); return(XOR_ASSIGN); } // Bitwise XOR assignment '^='
"|="			{ count(); return(OR_ASSIGN); } // Bitwise OR assignment '|='
">>"			{ count(); return(RIGHT_OP); } // Right shift operator '>>'
"<<"			{ count(); return(LEFT_OP); } // Left shift operator '<<'
"++"			{ count(); return(INC_OP); } // Increment operator '++'
"--"			{ count(); return(DEC_OP); } // Decrement operator '--'
"->"			{ count(); return(PTR_OP); } // Pointer operator '->'
"&&"			{ count(); return(AND_OP); } // Logical AND operator '&&'
"||"			{ count(); return(OR_OP); } // Logical OR operator '||'
"<="			{ count(); return(LE_OP); } // Less than or equal to '<='
">="			{ count(); return(GE_OP); } // Greater than or equal to '>='
"=="			{ count(); return(EQ_OP); } // Equality operator '=='
"!="			{ count(); return(NE_OP); } // Inequality operator '!='
";"			{ count(); return(';'); } // Semicolon ';'
("{"|"<%")		{ count(); return('{'); } // Opening brace '{' or alternative opening brace '<%'
("}"|"%>")		{ count(); return('}'); } // Closing brace '}' or alternative closing brace '%>'
","			{ count(); return(','); } // Comma ','
":"			{ count(); return(':'); } // Colon ':'
"="			{ count(); return('='); } // Assignment operator '='
"("			{ count(); return('('); } // Opening parenthesis '('
")"			{ count(); return(')'); } // Closing parenthesis ')'
"["			{ count(); return('['); } // Opening square bracket '['
"]"			{ count(); return(']'); } // Closing square bracket ']'
"."			{ count(); return('.'); } // Dot operator '.'
"&"			{ count(); return('&'); } // Bitwise AND '&'
"!"			{ count(); return('!'); } // Logical NOT '!'
"~"			{ count(); return('~'); } // Bitwise NOT '~'
"-"			{ count(); return('-'); } // Subtraction or unary minus '-'
"+"			{ count(); return('+'); } // Addition or unary plus '+'
"*"			{ count(); return('*'); } // Multiplication '*'
"/"			{ count(); return('/'); } // Division '/'
"%"			{ count(); return('%'); } // Modulus operator '%'
"<"			{ count(); return('<'); } // Less than operator '<'
">"			{ count(); return('>'); } // Greater than operator '>'
"^"			{ count(); return('^'); } // Bitwise XOR '^'
"|"			{ count(); return('|'); } // Bitwise OR '|'
"?"			{ count(); return('?'); } // Ternary conditional operator '?'

[ \t\v\n\f]		{ count(); } 
.			{ /* ignore bad characters */ }

%%

// Function to skip over whitespace characters (space, tab, vertical tab, newline, form feed).
// These are passed to the count() function for column tracking purposes.
[ \t\v\n\f]		{ count(); }

// Catch-all rule for unrecognized or bad characters that are ignored.
// It prevents them from causing errors in lexical analysis.
.			{ /* ignore bad characters */ }

%%

// Function to handle comments in the input. 
// It will print characters until it encounters a '*' followed by '/' which marks the end of the comment.
comment()
{
	char c, c1;

loop:
	// Loop to read characters one by one until a '*' is found.
	while ((c = input()) != '*' && c != 0)
		// Print the character to output.
		putchar(c);

	// After encountering '*', check if the next character is '/' (the end of a comment).
	if ((c1 = input()) != '/' && c != 0)
	{
		// If it's not '/', put the character back in the input stream and go back to the loop.
		unput(c1);
		goto loop;
	}

	// If we reach the end of the comment, output the '/'.
	if (c != 0)
		putchar(c1);
}

// Variable to keep track of the current column in the input (used for formatting/tab alignment).
int column = 0;

// Function to count the number of characters processed and update the column position accordingly.
void count()
{
	int i;

	// Loop through the characters in the matched text (yytext).
	for (i = 0; yytext[i] != '\0'; i++)
	{
		// If a newline is found, reset the column count (since it's a new line).
		if (yytext[i] == '\n')
			column = 0;
		// If a tab is found, increase the column based on tab spacing (usually 8 spaces).
		else if (yytext[i] == '\t')
			column += 8 - (column % 8);
		// For all other characters, simply increment the column count.
		else
			column++;
	}
}

// Function to check the type of identifier (like if it's a type name or a regular identifier).
int check_type()
{
	/*
	 * Pseudo code that explains what this function should do:
	 *
	 *	if (yytext == type_name)  // Check if the matched text is a type name.
	 *		return(TYPE_NAME);    // If so, return the type name token.
	 *
	 *	return(IDENTIFIER);        // Otherwise, return the identifier token.
	 */

	/*
	 * In the actual implementation, it only returns IDENTIFIER.
	 * This is just a placeholder for the actual logic.
	 */
	return(IDENTIFIER);
}

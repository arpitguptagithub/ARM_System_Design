%{ 
#include<stdio.h>  // Including the standard input/output header file
#include <string.h>  // Including string manipulation functions
#include <stdlib.h>  // Including standard library functions like memory allocation
int yylex();  // Declaring the lexical analyzer function
int yyerror(char *);  // Declaring the error handling function
int eflag=0;  // Defining an error flag and initializing it to 0
extern FILE * yyin;  // Declaring an external file pointer for input

// Comment: The following line defines possible syntax for increment and decrement operations on IDs.
//  INC "("ID ")" | "("ID ")" INC | DEC "("ID ")" | "("ID ")" DEC | 


char *gen_var();  // Function to generate a variable
char *gen_label();  // Function to generate a label
char *gen_out_fun();  // Function to generate an output function
char *itoa(int num);  // Function to convert an integer to a string
void initialize();  // Function to initialize some setup
%}

%token IDENTIFIER CONSTANT STRING_LITERAL SIZEOF  // Defining tokens for identifiers, constants, string literals, and sizeof
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP  // Defining tokens for pointer, increment, decrement, and comparison operations
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN  // Defining tokens for bitwise and assignment operations
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN  // Additional assignment tokens
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME  // XOR, OR, and type name tokens

%token TYPEDEF EXTERN STATIC AUTO REGISTER  // Storage class specifiers
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID  // Data type specifiers
%token STRUCT UNION ENUM ELLIPSIS  // Structure and enum related tokens

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN  // Control structure tokens

%token CLASS PRIVATE PUBLIC PROTECTED VIRTUAL  // Object-oriented keywords
%token NEW DELETE THIS OPERATOR TEMPLATE FRIEND  // Additional OOP and memory management tokens
%token NAMESPACE USING THROW TRY CATCH  // Exception handling and namespace management tokens
%token MAIN  // Main function token

%start begin  // Defining the starting point of the grammar
%%

expression_list  // Defining expression list rule
    : assignment_expression  // Single assignment expression in the list
    | expression_list ',' assignment_expression  // Multiple expressions separated by commas
    ;

class_specifier  // Grammar rules for class declarations
    : CLASS IDENTIFIER '{' class_body '}'  // Class with identifier and body
    | CLASS IDENTIFIER ':' base_specifier_list '{' class_body '}'  // Class with base specifiers (inheritance)
    | CLASS IDENTIFIER  // Class with just identifier
    | CLASS '{' class_body '}'  // Class with just body
    ;

base_specifier_list  // Defining base class list in case of inheritance
    : base_specifier  // Single base specifier
    | base_specifier_list ',' base_specifier  // Multiple base specifiers
    ;

base_specifier  // Rules for defining base classes
    : IDENTIFIER  // Base class as an identifier
    | VIRTUAL IDENTIFIER  // Virtual base class
    | access_specifier IDENTIFIER  // Base class with access specifier
    | VIRTUAL access_specifier IDENTIFIER  // Virtual base class with access specifier
    ;

class_body  // Class body definition
    : class_member_declaration  // A single class member
    | class_body class_member_declaration  // Multiple class members
    ;

class_member_declaration  // Rules for member declarations within the class
    : access_specifier ':'  // Specifying access control for members
    | member_declaration  // Declaring class members
    ;

access_specifier  // Access control keywords
    : PRIVATE  // Private access
    | PROTECTED  // Protected access
    | PUBLIC  // Public access
    ;

member_declaration  // Class member declarations
    : declaration  // Variable or data member declaration
    | member_function_definition  // Function member definition
    | constructor_definition  // Constructor definition
    | destructor_definition  // Destructor definition
    ;

member_function_definition  // Function definition for class members
    : declaration_specifiers declarator compound_statement  // Function signature with body
    ;

constructor_definition  // Constructor syntax
    : IDENTIFIER '(' parameter_list ')' constructor_initializer compound_statement  // Constructor with parameters
    | IDENTIFIER '(' ')' constructor_initializer compound_statement  // Constructor without parameters
    ;

constructor_initializer  // Initializer list for constructor
    : ':' member_initializer_list  // Initializing member variables
    |  // Empty initializer option
    ;

member_initializer_list  // List of member initializers
    : member_initializer  // Single initializer
    | member_initializer_list ',' member_initializer  // Multiple initializers
    ;

member_initializer  // Rules for member initialization in constructor
    : IDENTIFIER '(' expression_list ')'  // Member initialization with parameters
    | IDENTIFIER '(' ')'  // Member initialization without parameters
    ;

destructor_definition  // Destructor definition
    : '~' IDENTIFIER '(' ')' compound_statement  // Destructor body
    ;

declaration_specifiers  // Extending declaration specifiers to include class
    : storage_class_specifier  // Specifying storage class
    | storage_class_specifier declaration_specifiers  // Multiple storage specifiers
    | type_specifier  // Specifying data type
    | type_specifier declaration_specifiers  // Multiple type specifiers
    | type_qualifier  // Specifying type qualifiers (e.g., const, volatile)
    | type_qualifier declaration_specifiers  // Multiple type qualifiers
    | class_specifier  // Class specifier in declaration
    | class_specifier declaration_specifiers  // Multiple class specifiers
    ;

type_specifier  // Extending type specifier to include class names
    : VOID  // Void data type
    | CHAR  // Char data type
    | SHORT  // Short integer
    | INT  // Integer
    | LONG  // Long integer
    | FLOAT  // Floating point
    | DOUBLE  // Double precision floating point
    | SIGNED  // Signed integer
    | UNSIGNED  // Unsigned integer
    | struct_or_union_specifier  // Structure or union
    | enum_specifier  // Enumeration
    | TYPE_NAME  // Type name
    ;

class_name  // Defining class name as an identifier
    : IDENTIFIER  // Class name as identifier
    ;

new_expression  // Grammar for new expression (object creation)
    : NEW type_name  // New object of a type
    | NEW type_name '(' expression_list ')'  // New object with constructor parameters
    | NEW type_name '[' expression ']'  // New array object
    ;

delete_expression  // Grammar for delete expression (object deletion)
    : DELETE expression  // Delete object
    | DELETE '[' ']' expression  // Delete array object
    ;

primary_expression  // Extending primary expressions to include this and new/delete expressions
    : IDENTIFIER  // Identifier expression
    | CONSTANT  // Constant value expression
    | STRING_LITERAL  // String literal
    | '(' expression ')'  // Expression in parentheses
    | THIS  // 'this' pointer
    ;

namespace_definition  // Grammar for namespace definition
    : NAMESPACE IDENTIFIER '{' translation_unit '}'  // Named namespace with body
    | NAMESPACE '{' translation_unit '}'  // Anonymous namespace
    ;

using_directive  // Grammar for using directives (importing namespace)
    : USING NAMESPACE IDENTIFIER ';'  // Using namespace directive
    ;

external_declaration  // External declarations extended to include namespace and using directives
    : function_definition  // Function definition
    | declaration  // Variable declaration
    | namespace_definition  // Namespace definition
    | using_directive  // Using directive
    ;

try_block  // Grammar for try block (exception handling)
    : TRY compound_statement catch_block_list  // Try block with catch handlers
    ;

catch_block_list  // List of catch blocks
    : catch_block  // Single catch block
    | catch_block_list catch_block  // Multiple catch blocks
    ;

catch_block  // Grammar for a catch block
    : CATCH '(' parameter_declaration ')' compound_statement  // Catch block with parameter
    ;

postfix_expression  // Postfix expressions extended with member access and increment/decrement
    : primary_expression  // Primary expression
    | postfix_expression '[' expression ']'  // Array access
    | postfix_expression '(' ')'  // Function call without arguments
    | postfix_expression '(' argument_expression_list ')'  // Function call with arguments
    | postfix_expression '.' IDENTIFIER  // Member access using dot operator
    | postfix_expression PTR_OP IDENTIFIER  // Member access using pointer operator
    | postfix_expression INC_OP  // Post-increment operation
    | postfix_expression DEC_OP  // Post-decrement operation
    | '(' type_name ')' '{' initializer_list '}'  // Cast with initializer list
    | '(' type_name ')' '{' initializer_list ',' '}'  // Cast with initializer list and trailing comma
    ;

argument_expression_list  // Argument list in function calls
    : assignment_expression  // Single assignment expression as an argument
    | argument_expression_list ',' assignment_expression  // Multiple arguments separated by commas
    ;

unary_expression  // Unary expressions including increment/decrement and sizeof
    : postfix_expression  // Postfix expression
    | INC_OP unary_expression  // Pre-increment operation
    | DEC_OP unary_expression  // Pre-decrement operation
    | unary_operator cast_expression  // Unary operator with cast
    | SIZEOF unary_expression  // Sizeof operation on unary expression
    | SIZEOF '(' type_name ')'  // Sizeof operation on a type
    | new_expression  // New expression
    | delete_expression  // Delete expression
    ;

unary_operator  // Defining unary operators
    : '&' | '*' | '+' | '-' | '~' | '!'  // Address, dereference, sign, bitwise and logical operators
    ;

cast_expression  // Type casting expressions
    : unary_expression  // Unary expression
    | '(' type_name ')' cast_expression  // Cast to a type
    ;

multiplicative_expression  // Grammar for multiplication, division, and modulo
    : cast_expression  // Cast expression
    | multiplicative_expression '*' cast_expression  // Multiplication
    | multiplicative_expression '/' cast_expression  // Division
    | multiplicative_expression '%' cast_expression  // Modulo
    ;

additive_expression  // Grammar for addition and subtraction
    : multiplicative_expression  // Multiplicative expression
    | additive_expression '+' multiplicative_expression  // Addition
    | additive_expression '-' multiplicative_expression  // Subtraction
    ;

shift_expression  // Grammar for bitwise shifts
    : additive_expression  // Additive expression
    | shift_expression LEFT_OP additive_expression  // Left shift operation
    | shift_expression RIGHT_OP additive_expression  // Right shift operation
    ;

relational_expression  // Grammar for relational operations
    : shift_expression  // Shift expression
    | relational_expression '<' shift_expression  // Less than
    | relational_expression '>' shift_expression  // Greater than
    | relational_expression LE_OP shift_expression  // Less than or equal to
    | relational_expression GE_OP shift_expression  // Greater than or equal to
    ;

equality_expression  // Grammar for equality and inequality comparisons
    : relational_expression  // Relational expression
    | equality_expression EQ_OP relational_expression  // Equal to
    | equality_expression NE_OP relational_expression  // Not equal to
    ;

and_expression  // Grammar for bitwise AND operation
    : equality_expression  // Equality expression
    | and_expression '&' equality_expression  // Bitwise AND operation
    ;

exclusive_or_expression  // Grammar for bitwise XOR operation
    : and_expression  // AND expression
    | exclusive_or_expression '^' and_expression  // XOR operation
    ;

inclusive_or_expression  // Grammar for bitwise OR operation
    : exclusive_or_expression  // XOR expression
    | inclusive_or_expression '|' exclusive_or_expression  // OR operation
    ;

logical_and_expression  // Grammar for logical AND operation
    : inclusive_or_expression  // OR expression
    | logical_and_expression AND_OP inclusive_or_expression  // Logical AND operation
    ;

logical_or_expression  // Grammar for logical OR operation
    : logical_and_expression  // Logical AND expression
    | logical_or_expression OR_OP logical_and_expression  // Logical OR operation
    ;


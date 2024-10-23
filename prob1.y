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

conditional_expression
    : logical_or_expression  // Logical OR expression
    | logical_or_expression '?' expression ':' conditional_expression  // Ternary conditional operation
    ;

assignment_expression
    : conditional_expression  // Conditional expression
    | unary_expression assignment_operator assignment_expression  // Assignment with unary expression
    ;

assignment_operator  // Operators for assignment
    : '='  // Direct assignment
    | MUL_ASSIGN  // Multiplication assignment (e.g., *=)
    | DIV_ASSIGN  // Division assignment (e.g., /=)
    | MOD_ASSIGN  // Modulus assignment (e.g., %=)
    | ADD_ASSIGN  // Addition assignment (e.g., +=)
    | SUB_ASSIGN  // Subtraction assignment (e.g., -=)
    | LEFT_ASSIGN  // Left shift assignment (e.g., <<=)
    | RIGHT_ASSIGN  // Right shift assignment (e.g., >>=)
    | AND_ASSIGN  // Bitwise AND assignment (e.g., &=)
    | XOR_ASSIGN  // Bitwise XOR assignment (e.g., ^=)
    | OR_ASSIGN  // Bitwise OR assignment (e.g., |=)
    ;

expression
    : assignment_expression  // Assignment expression
    | expression ',' assignment_expression  // Comma-separated expressions
    ;

constant_expression
    : conditional_expression  // Constant expression via conditional expressions
    ;

declaration
    : declaration_specifiers ';'  // Declaration with specifiers
    | declaration_specifiers init_declarator_list ';'  // Declaration with specifiers and initializers
    ;

init_declarator_list
    : init_declarator  // Single declarator
    | init_declarator_list ',' init_declarator  // Comma-separated list of declarators
    ;

init_declarator
    : declarator  // Declarator
    | declarator '=' initializer  // Declarator with initializer
    ;

storage_class_specifier
    : TYPEDEF  // Typedef storage class specifier
    | EXTERN  // Extern storage class specifier
    | STATIC  // Static storage class specifier
    | AUTO  // Auto storage class specifier
    | REGISTER  // Register storage class specifier
    ;

struct_or_union_specifier
    : struct_or_union IDENTIFIER '{' struct_declaration_list '}'  // Struct or union definition
    | struct_or_union '{' struct_declaration_list '}'  // Struct or union without an identifier
    | struct_or_union IDENTIFIER  // Struct or union with an identifier
    ;

struct_or_union
    : STRUCT  // Struct keyword
    | UNION  // Union keyword
    ;

struct_declaration_list
    : struct_declaration  // Single struct declaration
    | struct_declaration_list struct_declaration  // List of struct declarations
    ;

struct_declaration
    : specifier_qualifier_list struct_declarator_list ';'  // Struct declaration with specifiers and declarators
    ;

specifier_qualifier_list
    : type_specifier specifier_qualifier_list  // Type specifier followed by more qualifiers
    | type_specifier  // Type specifier only
    | type_qualifier specifier_qualifier_list  // Type qualifier followed by more qualifiers
    | type_qualifier  // Type qualifier only
    ;

struct_declarator_list
    : struct_declarator  // Single struct declarator
    | struct_declarator_list ',' struct_declarator  // Comma-separated list of struct declarators
    ;

struct_declarator
    : declarator  // Declarator
    | ':' constant_expression  // Bit-field width declaration
    | declarator ':' constant_expression  // Declarator with bit-field width
    ;

enum_specifier
    : ENUM '{' enumerator_list '}'  // Enum definition
    | ENUM IDENTIFIER '{' enumerator_list '}'  // Enum definition with identifier
    | ENUM IDENTIFIER  // Enum with identifier only
    ;

enumerator_list
    : enumerator  // Single enumerator
    | enumerator_list ',' enumerator  // Comma-separated list of enumerators
    ;

enumerator
    : IDENTIFIER  // Enumerator identifier
    | IDENTIFIER '=' constant_expression  // Enumerator with constant value
    ;

type_qualifier
    : CONST  // Const qualifier
    | VOLATILE  // Volatile qualifier
    ;

declarator
    : pointer direct_declarator  // Declarator with a pointer
    | direct_declarator  // Direct declarator
    ;

direct_declarator
    : IDENTIFIER  // Identifier
    | '(' declarator ')'  // Parenthesized declarator
    | direct_declarator '[' constant_expression ']'  // Array declarator with size
    | direct_declarator '[' ']'  // Array declarator without size
    | direct_declarator '(' parameter_type_list ')'  // Function declarator with parameter types
    | direct_declarator '(' identifier_list ')'  // Function declarator with identifiers
    | direct_declarator '(' ')'  // Function declarator without parameters
    ;

pointer
    : '*'  // Single pointer
    | '*' type_qualifier_list  // Pointer with qualifiers
    | '*' pointer  // Multiple pointers
    | '*' type_qualifier_list pointer  // Multiple pointers with qualifiers
    ;

type_qualifier_list
    : type_qualifier  // Single type qualifier
    | type_qualifier_list type_qualifier  // List of type qualifiers
    ;

parameter_type_list
    : parameter_list  // List of parameters
    | parameter_list ',' ELLIPSIS  // Parameters followed by ellipsis (variadic function)
    ;

parameter_list
    : parameter_declaration  // Single parameter
    | parameter_list ',' parameter_declaration  // Comma-separated list of parameters
    ;

parameter_declaration
    : declaration_specifiers declarator  // Declaration with declarator
    | declaration_specifiers  // Declaration without declarator
    ;

identifier_list
    : IDENTIFIER  // Single identifier
    | identifier_list ',' IDENTIFIER  // Comma-separated list of identifiers
    ;

type_name
    : specifier_qualifier_list  // Type name
    | specifier_qualifier_list abstract_declarator  // Type name with an abstract declarator
    ;

abstract_declarator
    : pointer  // Abstract declarator with pointer
    | direct_abstract_declarator  // Abstract declarator
    | pointer direct_abstract_declarator  // Pointer and direct abstract declarator
    ;

direct_abstract_declarator
    : '(' abstract_declarator ')'  // Parenthesized abstract declarator
    | '[' ']'  // Array declarator without size
    | '[' constant_expression ']'  // Array declarator with size
    | direct_abstract_declarator '[' ']'  // Array declarator without size (nested)
    | direct_abstract_declarator '[' constant_expression ']'  // Array declarator with size (nested)
    | '(' ')'  // Function declarator without parameters
    | '(' parameter_type_list ')'  // Function declarator with parameters
    | direct_abstract_declarator '(' ')'  // Nested function declarator without parameters
    | direct_abstract_declarator '(' parameter_type_list ')'  // Nested function declarator with parameters
    ;

initializer
    : assignment_expression  // Simple initializer
    | '{' initializer_list '}'  // Initializer list in braces
    | '{' initializer_list ',' '}'  // Initializer list with a trailing comma
    ;

initializer_list
    : initializer  // Single initializer
    | initializer_list ',' initializer  // Comma-separated list of initializers
    ;

statement
    : labeled_statement  // Labeled statement
    | compound_statement  // Compound statement
    | expression_statement  // Expression statement
    | selection_statement  // Selection statement (if, switch)
    | iteration_statement  // Iteration statement (for, while, do-while)
    | jump_statement  // Jump statement (goto, continue, break, return)
    ;

labeled_statement
    : IDENTIFIER ':' statement  // Labeled statement with identifier
    | CASE constant_expression ':' statement  // Case label in switch
    | DEFAULT ':' statement  // Default label in switch
    ;

compound_statement
    : '{' '}'  // Empty compound statement
    | '{' statement_list '}'  // Compound statement with statements
    | '{' declaration_list '}'  // Compound statement with declarations
    | '{' declaration_list statement_list '}'  // Compound statement with declarations and statements
    ;

declaration_list
    : declaration  // Single declaration
    | declaration_list declaration  // List of declarations
    ;

statement_list
    : statement  // Single statement
    | statement_list statement  // List of statements
    ;

expression_statement
    : ';'  // Empty expression statement
    | expression ';'  // Expression statement
    ;

selection_statement
    : IF '(' expression ')' statement  // If statement
    | IF '(' expression ')' statement ELSE statement  // If-else statement
    | SWITCH '(' expression ')' statement  // Switch statement
    ;

iteration_statement
    : WHILE '(' expression ')' statement  // While loop
    | DO statement WHILE '(' expression ')' ';'  // Do-while loop
    | FOR '(' expression_statement expression_statement ')' statement  // For loop
    | FOR '(' expression_statement expression_statement expression ')' statement  // For loop with initialization, condition, and update
    ;

jump_statement
    : GOTO IDENTIFIER ';'  // Goto statement
    | CONTINUE ';'  // Continue statement
    | BREAK ';'  // Break statement
    | RETURN ';'  // Return statement
    | RETURN expression ';'  // Return statement with expression
    ;

begin
    : translation_unit  // Start symbol for the grammar

translation_unit
    : external_declaration  // Single external declaration
    | translation_unit external_declaration  // List of external declarations
    ;

function_definition
    : declaration_specifiers declarator declaration_list compound_statement  // Function with declarations and statements
    | declaration_specifiers MAIN '(' ')' compound_statement  // Main function definition
    | declaration_specifiers declarator compound_statement  // Function without declaration list
    | declarator declaration_list compound_statement  // Function without specifiers
    | declarator compound_statement  // Simplified function definition
    ;

%%
#include <stdio.h>  // Include standard input-output header

extern char yytext[];  // External variable for parsed text
extern int column;  // Column number tracking

// Error reporting function
int yyerror(char *s){
    printf("Error \n");
    printf("%s \n", s);
    yyparse();  // Reparse the input after error
}

int main(int argc, char* argv[]) {
    if(argc > 1) {
        FILE *fp = fopen(argv[1], "r");  // Open file for reading
        if(fp) {
            yyin = fp;  // Set input file for parsing
        }
    }
    yyparse();  // Start parsing
    return 0;
}



%{
#include<stdio.h>
#include <string.h>
#include <stdlib.h>
 #include <ctype.h>
    #include <vector>
    #include <queue>
    #include <set>
	 #include <iostream>
    #include <string>
    #include <unordered_map>
    #include<map>
    #include <stack>
    #include<algorithm>
    #include<fstream>
	using namespace std;
int yylex();
void yyerror(const char* msg);
int yywrap();
    int yytext();
int eflag=0;
extern FILE * yyin;

//  INC "("ID ")" | "("ID ")" INC | DEC "("ID ")" | "("ID ")" DEC | 

#define add_tac($$, $1, $2, $3) {strcpy($$.type, $1.type);\
        sprintf($$.lexeme, get_temp().c_str());\
        string lt=string($1.type);\
        string rt=string($3.type);\
        if((lt == "CHAR" && rt == "INT") || (rt == "CHAR" && lt == "INT")){\
            strcpy($$.type, "INT");\
        }\
        else if((lt == "FLOAT" && rt == "INT") || (rt == "FLOAT" && lt == "INT")){\
            strcpy($$.type, "FLOAT");\
        }\
        else if((lt == "FLOAT" && rt == "FLOAT") || (lt == "INT" && rt == "INT") || (lt == "CHAR" && rt == "CHAR")){\
            strcpy($$.type, $1.type);\
        }\
        else{\
            sem_errors.push_back("Cannot convert between CHAR and FLOAT in line : " + to_string(countn+1));\
        }}

    bool check_declaration(string variable);
    bool check_scope(string variable);
    bool multiple_declaration(string variable);
    bool is_reserved_word(string id);
    bool function_check(string variable, int flag);
    bool type_check(string type1, string type2);
    bool check_type(string l, string r);

 queue<string> free_temp;
    set<string> const_temps;
    void PrintStack(stack<int> s);

// struct variable_info {
//         string data_type;
//         int scope;
//         int level;   // for arrays
//         int isArray;
//         int line_num; 
//     };

struct var_info {
        string data_type;
        int scope;
        int size;   // for arrays
        int isArray;
        int line_number; 
    };

vector<string> tac;
    map<string, string> temp_map;

string get_temp();

// struct function_info{
//         string ret_type;
//         int num_params;
//         vector<string> param_types;
//         unordered_map<string, struct var_info> symbol_table;
//     };

 struct func_info{
        string return_type;
        int num_params;
        vector<string> param_types;
        unordered_map<string, struct var_info> symbol_table;
    };

// int var_count = 0;
// int lc = 0; // label counter

   int variable_count = 0;
    int label_counter = 0;

    vector<string> sem_errors;

    int temp_index;
    int temp_label;

    stack<int> loop_continue, loop_break;
    stack<pair<string, vector<string>>> func_call_id;
    stack<int> scope_history;
    int scope_counter = 0;

    // for array declaration with initialization
    string curr_array;
    int arr_index=0;

    extern int countn;

    int has_return_stmt;

    unordered_map<string, struct func_info> func_table;
    string curr_func_name;
    vector<string> curr_func_param_type;
    vector<string> reserved = {"int", "float", "char", "string", "void", "if", "elif", "else", "for", "while", "break", "continue", "main", "return", "switch", "case", "input", "output"};

%}

%union{
    struct node { 
        char lexeme[100];
        int line_number;
        char type[100];
        char if_body[5];
        char elif_body[5];
		char else_body[5];
        char loop_body[5];
        char parentNext[5];
        char case_body[5];
        char id[5];
        char temp[5];
        int nParams;
    } node;
}

%token  CONSTANT STRING_LITERAL SIZEOF
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token   MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token <node> PRINT SCAN MAIN XOR NEG NOT AND OR BIT_OR BIT_AND EQ NE LE LT GE GT LEFTSHIFT RIGHTSHIFT ADD SUB MUL DIV MOD IDENTIFIER C_CONST S_CONST B_CONST I_CONST F_CONST CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELLIPSIS

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%token CLASS PRIVATE PUBLIC PROTECTED VIRTUAL
%token NEW DELETE THIS OPERATOR TEMPLATE FRIEND
%token NAMESPACE USING THROW TRY CATCH
%type <node> assignment_expression unary_operator expression primary_expression postfix_expression unary_expression cast_expression const multiplicative_expression additive_expression shift_expression relational_expression equality_expression and_expression exclusive_or_expression inclusive_or_expression logical_and_expression conditional_expression logical_or_expression type_specifier declaration_specifiers
%start begin
%%

expression_list
    : assignment_expression
    | expression_list ',' assignment_expression
    ;

class_specifier
    : CLASS IDENTIFIER '{' class_body '}'
    | CLASS IDENTIFIER ':' base_specifier_list '{' class_body '}'
    | CLASS IDENTIFIER
    | CLASS '{' class_body '}'
    ;

base_specifier_list
    : base_specifier
    | base_specifier_list ',' base_specifier
    ;

base_specifier
    : IDENTIFIER
    | VIRTUAL IDENTIFIER
    | access_specifier IDENTIFIER
    | VIRTUAL access_specifier IDENTIFIER
    ;

class_body
    : class_member_declaration
    | class_body class_member_declaration
    ;

class_member_declaration
    : access_specifier ':'
    | member_declaration
    ;

access_specifier
    : PRIVATE
    | PROTECTED
    | PUBLIC
    ;

member_declaration
    : declaration
    | member_function_definition
    | constructor_definition
    | destructor_definition
    ;

member_function_definition
    : declaration_specifiers declarator compound_statement
    ;

constructor_definition
    : IDENTIFIER '(' parameter_list ')' constructor_initializer compound_statement
    | IDENTIFIER '(' ')' constructor_initializer compound_statement
    ;

constructor_initializer
    : ':' member_initializer_list
    |
    ;

member_initializer_list
    : member_initializer
    | member_initializer_list ',' member_initializer
    ;

member_initializer
    : IDENTIFIER '(' expression_list ')'
    | IDENTIFIER '(' ')'
    ;

destructor_definition
    : '~' IDENTIFIER '(' ')' compound_statement
    ;

/* Extend declaration_specifiers to include class */
declaration_specifiers
    : storage_class_specifier
    | storage_class_specifier declaration_specifiers
    | type_specifier {
                        strcpy($$.type, $1.type);
                    }
    | type_specifier declaration_specifiers
    | type_qualifier
    | type_qualifier declaration_specifiers
    | class_specifier
    | class_specifier declaration_specifiers
    ;

/* Extend type_specifier to include class names */
type_specifier
    : VOID  {
                        sprintf($$.type, "void");
            }
    | CHAR {
                        strcpy($$.type, "CHAR");
            }
    | SHORT
    | INT {
                        strcpy($$.type, "INT");
          }
    | LONG
    | FLOAT {
                        strcpy($$.type, "FLOAT");
            }
    | DOUBLE
    | SIGNED
    | UNSIGNED
    | struct_or_union_specifier
    | enum_specifier
    | TYPE_NAME
    ;

class_name
    : IDENTIFIER
    ;

/* New rules for object creation and deletion */
new_expression
    : NEW type_name
    | NEW type_name '(' expression_list ')'
    | NEW type_name '[' expression ']'
    ;
delete_expression
    : DELETE expression
    | DELETE '[' ']' expression
    ;

/* Extend primary_expression to include this and new/delete expressions */
primary_expression
    : IDENTIFIER
	{
                        check_declaration(string($1.lexeme));
                        // check_scope(string($1.lexeme));
                        strcpy($$.type, func_table[curr_func_name].symbol_table[string($1.lexeme)].data_type.c_str());
                        strcpy($$.lexeme, $1.lexeme);
	}
    | const {
                        strcpy($$.type, $1.type);

                        string t=get_temp();
                        sprintf($$.lexeme, t.c_str());
                        tac.push_back(string($$.lexeme) + " = " + string($1.lexeme) + " " + string($$.type)); 
                        temp_map[string($1.lexeme)] = string($$.lexeme);

                        const_temps.insert(t);
                        // if(temp_map[string($1.lexeme)] == ""){
                        //     string t=get_temp();
                        //     sprintf($$.lexeme, t.c_str());
                        //     tac.push_back(string($$.lexeme) + " = " + string($1.lexeme) + " " + string($$.type)); 
                        //     temp_map[string($1.lexeme)] = string($$.lexeme);

                        //     const_temps.insert(t);
                        // }
                        // else{
                        //     //tac.push_back(temp_map[string($1.lexeme)] + " = " + string($1.lexeme) + " " + string($$.type)); 
                        //     strcpy($$.lexeme, temp_map[string($1.lexeme)].c_str());
                        // }
                    }
    | STRING_LITERAL
    | '(' expression ')' {
                        strcpy($$.type, $2.type);
                        strcpy($$.lexeme, $2.lexeme);
                    }
    | THIS
    ;

/* Add namespace support */
namespace_definition
    : NAMESPACE IDENTIFIER '{' translation_unit '}'
    | NAMESPACE '{' translation_unit '}'
    ;

using_directive
    : USING NAMESPACE IDENTIFIER ';'
    ;

/* Extend external_declaration to include namespace and using directives */
external_declaration
    : function_definition
    | declaration
    | namespace_definition
    | using_directive
    ;

/* Add exception handling */
try_block
    : TRY compound_statement catch_block_list
    ;

catch_block_list
    : catch_block
    | catch_block_list catch_block
    ;

catch_block
    : CATCH '(' parameter_declaration ')' compound_statement
    ;

// postfix_expression '[' expression ']' is replaced by IDENTIFIER '[' expression ']'
postfix_expression
    : primary_expression
	{
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
    | IDENTIFIER '[' expression ']' 
	{
                        if(check_declaration(string($1.lexeme)) && func_table[curr_func_name].symbol_table[string($1.lexeme)].isArray == 0) { 
                            sem_errors.push_back("Variable is not an array"); 
                        }
                        check_scope(string($1.lexeme));
                        strcpy($$.type, func_table[curr_func_name].symbol_table[string($1.lexeme)].data_type.c_str());
                        sprintf($$.lexeme, get_temp().c_str());
                        tac.push_back(string($$.lexeme) + " = " + string($1.lexeme) + " [ " + string($3.lexeme) + " ] " + string($$.type));
                        
                        if(const_temps.find(string($3.lexeme)) == const_temps.end() && $3.lexeme[0] == '@') free_temp.push(string($3.lexeme));
	}
    | postfix_expression '(' ')'
    | postfix_expression '(' argument_expression_list ')'
    | postfix_expression '.' IDENTIFIER
    | postfix_expression PTR_OP IDENTIFIER
    | postfix_expression INC_OP
    | postfix_expression DEC_OP
    | '(' type_name ')' '{' initializer_list '}'
    | '(' type_name ')' '{' initializer_list ',' '}'
    ;

argument_expression_list
    : assignment_expression
    | argument_expression_list ',' assignment_expression
    ;

unary_expression
    : postfix_expression
	{
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
    | INC_OP unary_expression
    | DEC_OP unary_expression
    | unary_operator primary_expression {
                        strcpy($$.type, $2.type);
                        sprintf($$.lexeme, get_temp().c_str());
                        if(string($1.lexeme) == "~" || string($1.lexeme) == "-"){
                            tac.push_back(string($$.lexeme) + " = " + string($1.lexeme) + " " + string($2.lexeme) + " " + string($$.type));
                        }
                        else if(string($1.lexeme) == "+"){
                            tac.push_back(string($$.lexeme) + " = " + string($2.lexeme) + " " + string($$.type));
                        }
                        else{
                            tac.push_back(string($$.lexeme) + " = ~ " + string($2.lexeme) + " " + string($$.type));
                        }

                        if(const_temps.find(string($2.lexeme)) == const_temps.end() && $2.lexeme[0] == '@') free_temp.push(string($2.lexeme));
                    }
    | SIZEOF unary_expression
    | SIZEOF '(' type_name ')'
    | new_expression
    | delete_expression
    ;

unary_operator
    : 
	ADD
	| SUB 
	| NEG 
	| NOT
	/* | '&' 
	| '*'  */
    ;

cast_expression
    : unary_expression
	{
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
    | '(' type_name ')' cast_expression
    ;

multiplicative_expression
	: cast_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
	| multiplicative_expression MUL cast_expression
    {
                        add_tac($$, $1, $2, $3)
                        string t0=get_temp();
                        string t1=get_temp();
                        string t2=get_temp();
                        string a = string($$.lexeme);
                        string b = string($1.lexeme);
                        string c = string($3.lexeme);
                        string dtype = string($$.type);
                        
                        tac.push_back(a + " = 0 " + dtype);
                        tac.push_back(t0 + " = 0 " + dtype);
                        tac.push_back(t2 + " = 1 " + dtype);
                        tac.push_back("#L" + to_string(++label_counter) + ":");
                        tac.push_back(t1 + " = " + t0 + " < " + c +  "  " + dtype);
                        tac.push_back("if " + t1 + " GOTO " + "#L" + to_string(label_counter+1) + " else GOTO " + "#L" + to_string(label_counter+2));
                        tac.push_back("#L" + to_string(++label_counter) + ":");
                        tac.push_back(a + " = " + a + " + " + b +  "  " + dtype);
                        tac.push_back(t0 + " = " + t0 + " + " + t2 +  "  " + dtype);
                        tac.push_back("GOTO #L" + to_string(label_counter-1));
                        tac.push_back("#L" + to_string(++label_counter) + ":");

                        free_temp.push(t0);
                        free_temp.push(t1);
                        free_temp.push(t2);
                        if(const_temps.find(string($1.lexeme)) == const_temps.end() && $1.lexeme[0] == '@') free_temp.push(string($1.lexeme));
                        if(const_temps.find(string($3.lexeme)) == const_temps.end() && $3.lexeme[0] == '@') free_temp.push(string($3.lexeme));

                        label_counter++;
    }
	| multiplicative_expression DIV cast_expression
    {
                        add_tac($$, $1, $2, $3)
                        string t0=get_temp();
                        string t1=get_temp();
                        string t2=get_temp();
                        string a = string($$.lexeme);
                        string b = string($1.lexeme);
                        string c = string($3.lexeme);
                        string dtype = string($$.type);
                        
                        tac.push_back(a + " = 0 " + dtype);
                        tac.push_back(t0 + " = " + b + " " + dtype);
                        tac.push_back(t2 + " = 1 " + dtype);
                        tac.push_back("#L" + to_string(++label_counter) + ":");
                        tac.push_back(t1 + " = " + t0 + " >= " + c +  "  " + dtype);
                        tac.push_back("if " + t1 + " GOTO " + "#L" + to_string(label_counter+1) + " else GOTO " + "#L" + to_string(label_counter+2));
                        tac.push_back("#L" + to_string(++label_counter) + ":");
                        tac.push_back(a + " = " + a + " + " + t2 +  "  " + dtype);
                        tac.push_back(t0 + " = " + t0 + " - " + c +  "  " + dtype);
                        tac.push_back("GOTO #L" + to_string(label_counter-1));
                        tac.push_back("#L" + to_string(++label_counter) + ":");

                        free_temp.push(t0);
                        free_temp.push(t1);
                        free_temp.push(t2);
                        if(const_temps.find(string($1.lexeme)) == const_temps.end() && $1.lexeme[0] == '@') free_temp.push(string($1.lexeme));
                        if(const_temps.find(string($3.lexeme)) == const_temps.end() && $3.lexeme[0] == '@') free_temp.push(string($3.lexeme));

                        label_counter++;
    }
	| multiplicative_expression MOD cast_expression
	{
                        add_tac($$, $1, $2, $3)
                        string t0=get_temp();
                        string t1=get_temp();
                        string t2=get_temp();
                        string a = string($$.lexeme);
                        string b = string($1.lexeme);
                        string c = string($3.lexeme);
                        string dtype = string($$.type);
                        
                        tac.push_back(a + " = 0 " + dtype);
                        tac.push_back(t0 + " = " + b + " " + dtype);
                        tac.push_back(t2 + " = 1 " + dtype);
                        tac.push_back("#L" + to_string(++label_counter) + ":");
                        tac.push_back(t1 + " = " + t0 + " >= " + c +  "  " + dtype);
                        tac.push_back("if " + t1 + " GOTO " + "#L" + to_string(label_counter+1) + " else GOTO " + "#L" + to_string(label_counter+2));
                        tac.push_back("#L" + to_string(++label_counter) + ":");
                        tac.push_back(t0 + " = " + t0 + " - " + c +  "  " + dtype);
                        tac.push_back("GOTO #L" + to_string(label_counter-1));
                        tac.push_back("#L" + to_string(++label_counter) + ":");
                        tac.push_back(a + " = " + t0 +  "  " + dtype);

                        free_temp.push(t0);
                        free_temp.push(t1);
                        free_temp.push(t2);
                        if(const_temps.find(string($1.lexeme)) == const_temps.end() && $1.lexeme[0] == '@') free_temp.push(string($1.lexeme));
                        if(const_temps.find(string($3.lexeme)) == const_temps.end() && $3.lexeme[0] == '@') free_temp.push(string($3.lexeme));

                        label_counter++;
                    }
	
	;

additive_expression
	: multiplicative_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
	| additive_expression ADD multiplicative_expression
    {
                        add_tac($$, $1, $2, $3)
                        tac.push_back(string($$.lexeme) + " = " + string($1.lexeme) + " " + string($2.lexeme) + " " + string($3.lexeme) + " " + string($$.type));
                        if(const_temps.find(string($1.lexeme)) == const_temps.end() && $1.lexeme[0] == '@') free_temp.push(string($1.lexeme));
                        if(const_temps.find(string($3.lexeme)) == const_temps.end() && $3.lexeme[0] == '@') free_temp.push(string($3.lexeme));
    }
	| additive_expression SUB multiplicative_expression
	{
                        add_tac($$, $1, $2, $3)
                        tac.push_back(string($$.lexeme) + " = " + string($1.lexeme) + " " + string($2.lexeme) + " " + string($3.lexeme) + " " + string($$.type));
                        if(const_temps.find(string($1.lexeme)) == const_temps.end() && $1.lexeme[0] == '@') free_temp.push(string($1.lexeme));
                        if(const_temps.find(string($3.lexeme)) == const_temps.end() && $3.lexeme[0] == '@') free_temp.push(string($3.lexeme));
    }
    ;

shift_expression
	: additive_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
	| shift_expression LEFT_OP additive_expression
	| shift_expression RIGHT_OP additive_expression
	;

relational_expression
	: shift_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
	| relational_expression LT shift_expression
    {
                        add_tac($$, $1, $2, $3)
                        tac.push_back(string($$.lexeme) + " = " + string($1.lexeme) + " " + string($2.lexeme) + " " + string($3.lexeme) + " " + string($$.type));
                        if(const_temps.find(string($1.lexeme)) == const_temps.end() && $1.lexeme[0] == '@') free_temp.push(string($1.lexeme));
                        if(const_temps.find(string($3.lexeme)) == const_temps.end() && $3.lexeme[0] == '@') free_temp.push(string($3.lexeme));
    }
	| relational_expression GT shift_expression
    {
                        add_tac($$, $1, $2, $3)
                        tac.push_back(string($$.lexeme) + " = " + string($1.lexeme) + " " + string($2.lexeme) + " " + string($3.lexeme) + " " + string($$.type));
                        if(const_temps.find(string($1.lexeme)) == const_temps.end() && $1.lexeme[0] == '@') free_temp.push(string($1.lexeme));
                        if(const_temps.find(string($3.lexeme)) == const_temps.end() && $3.lexeme[0] == '@') free_temp.push(string($3.lexeme));
    }
	| relational_expression LE shift_expression
    {
                        add_tac($$, $1, $2, $3)
                        tac.push_back(string($$.lexeme) + " = " + string($1.lexeme) + " " + string($2.lexeme) + " " + string($3.lexeme) + " " + string($$.type));
                        if(const_temps.find(string($1.lexeme)) == const_temps.end() && $1.lexeme[0] == '@') free_temp.push(string($1.lexeme));
                        if(const_temps.find(string($3.lexeme)) == const_temps.end() && $3.lexeme[0] == '@') free_temp.push(string($3.lexeme));
                    }
	| relational_expression GE shift_expression
    {
                        add_tac($$, $1, $2, $3)
                        tac.push_back(string($$.lexeme) + " = " + string($1.lexeme) + " " + string($2.lexeme) + " " + string($3.lexeme) + " " + string($$.type));
                        if(const_temps.find(string($1.lexeme)) == const_temps.end() && $1.lexeme[0] == '@') free_temp.push(string($1.lexeme));
                        if(const_temps.find(string($3.lexeme)) == const_temps.end() && $3.lexeme[0] == '@') free_temp.push(string($3.lexeme));
                    }
	;

equality_expression
	: relational_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
	| equality_expression EQ relational_expression
    {
                        add_tac($$, $1, $2, $3)
                        tac.push_back(string($$.lexeme) + " = " + string($1.lexeme) + " " + string($2.lexeme) + " " + string($3.lexeme) + " " + string($$.type));
                        if(const_temps.find(string($1.lexeme)) == const_temps.end() && $1.lexeme[0] == '@') free_temp.push(string($1.lexeme));
                        if(const_temps.find(string($3.lexeme)) == const_temps.end() && $3.lexeme[0] == '@') free_temp.push(string($3.lexeme));
    }
	| equality_expression NE relational_expression
    {
                        add_tac($$, $1, $2, $3)
                        string temp = get_temp();
                        tac.push_back(temp + " = " + string($1.lexeme) + " == " + string($3.lexeme) + " " + string($$.type));
                        tac.push_back(string($$.lexeme) + " = ~ " + temp + " " + string($$.type)); 

                        free_temp.push(temp);
                        if(const_temps.find(string($1.lexeme)) == const_temps.end() && $1.lexeme[0] == '@') free_temp.push(string($1.lexeme));
                        if(const_temps.find(string($3.lexeme)) == const_temps.end() && $3.lexeme[0] == '@') free_temp.push(string($3.lexeme));
                    }
	;

and_expression
	: equality_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
	| and_expression BIT_AND equality_expression
	{
                        add_tac($$, $1, $2, $3)
                        tac.push_back(string($$.lexeme) + " = " + string($1.lexeme) + " " + string($2.lexeme) + " " + string($3.lexeme) + " " + string($$.type));
                        if(const_temps.find(string($1.lexeme)) == const_temps.end() && $1.lexeme[0] == '@') free_temp.push(string($1.lexeme));
                        if(const_temps.find(string($3.lexeme)) == const_temps.end() && $3.lexeme[0] == '@') free_temp.push(string($3.lexeme));
	}
	;

exclusive_or_expression
	: and_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
	| exclusive_or_expression XOR and_expression
	{
                        add_tac($$, $1, $2, $3)
                        string a = string($$.lexeme);
                        string b = string($1.lexeme);
                        string b_= get_temp();
                        string c = string($3.lexeme);
                        string c_= get_temp();

                        tac.push_back(b_ + " = ~ " + b + " " + string($1.type));
                        tac.push_back(c_ + " = ~ " + c + " " + string($3.type));
                        string t1=get_temp();
                        string t2=get_temp();
                        tac.push_back(t1 + " = " + b + " & " + c_ + " " + string($$.type));
                        tac.push_back(t2 + " = " + b_ + " & " + c + " " + string($$.type));
                        tac.push_back(a + " = " + t1 + " | " + t2 + " " + string($$.type));

                        free_temp.push(b_);
                        free_temp.push(c_);
                        if(const_temps.find(string($1.lexeme)) == const_temps.end() && $1.lexeme[0] == '@') free_temp.push(string($1.lexeme));
                        if(const_temps.find(string($3.lexeme)) == const_temps.end() && $3.lexeme[0] == '@') free_temp.push(string($3.lexeme));

                        label_counter++;
	}
	;

inclusive_or_expression
	: exclusive_or_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
	| inclusive_or_expression BIT_OR exclusive_or_expression
	{
                        add_tac($$, $1, $2, $3)
                        tac.push_back(string($$.lexeme) + " = " + string($1.lexeme) + " " + string($2.lexeme) + " " + string($3.lexeme) + " " + string($$.type));
                        if(const_temps.find(string($1.lexeme)) == const_temps.end() && $1.lexeme[0] == '@') free_temp.push(string($1.lexeme));
                        if(const_temps.find(string($3.lexeme)) == const_temps.end() && $3.lexeme[0] == '@') free_temp.push(string($3.lexeme));
	}
	;

logical_and_expression
	: inclusive_or_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
	| logical_and_expression AND inclusive_or_expression
    {
                        add_tac($$, $1, $2, $3)
                        string l0 = "#L" + to_string(++label_counter);
                        string l1 = "#L" + to_string(++label_counter);
                        string l2 = "#L" + to_string(++label_counter);
                        string l3 = "#L" + to_string(++label_counter);
                        string dtype = string($$.type);

                        tac.push_back("if " + string($1.lexeme) + " GOTO " + l3 + " else GOTO " + l1);
                        tac.push_back(l3 + ":");
                        tac.push_back("if " + string($3.lexeme) + " GOTO " + l0 + " else GOTO " + l1);
                        tac.push_back(l0 + ":");
                        tac.push_back(string($$.lexeme) + " = 1 " + dtype);
                        tac.push_back("GOTO " + l2);
                        tac.push_back(l1 + ":");
                        tac.push_back(string($$.lexeme) + " = 0 " + dtype);
                        tac.push_back(l2 + ":");

                        if(const_temps.find(string($1.lexeme)) == const_temps.end() && $1.lexeme[0] == '@') free_temp.push(string($1.lexeme));
                        if(const_temps.find(string($3.lexeme)) == const_temps.end() && $3.lexeme[0] == '@') free_temp.push(string($3.lexeme));

                        label_counter++;
    }
	;

logical_or_expression
	: logical_and_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
	| logical_or_expression OR logical_and_expression {
                        add_tac($$, $1, $2, $3)
                        string l0 = "#L" + to_string(++label_counter);
                        string l1 = "#L" + to_string(++label_counter);
                        string l2 = "#L" + to_string(++label_counter);
                        string l3 = "#L" + to_string(++label_counter);
                        string dtype = string($$.type);

                        tac.push_back("if " + string($1.lexeme) + " GOTO " + l0 + " else GOTO " + l3);
                        tac.push_back(l3 + ":");
                        tac.push_back("if " + string($3.lexeme) + " GOTO " + l0 + " else GOTO " + l1);
                        tac.push_back(l0 + ":");
                        tac.push_back(string($$.lexeme) + " = 1 " + dtype);
                        tac.push_back("GOTO " + l2);
                        tac.push_back(l1 + ":");
                        tac.push_back(string($$.lexeme) + " = 0 " + dtype);
                        tac.push_back(l2 + ":");

                        if(const_temps.find(string($1.lexeme)) == const_temps.end() && $1.lexeme[0] == '@') free_temp.push(string($1.lexeme));
                        if(const_temps.find(string($3.lexeme)) == const_temps.end() && $3.lexeme[0] == '@') free_temp.push(string($3.lexeme));

                        label_counter++;
                    }
	;

conditional_expression
	: logical_or_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
	| logical_or_expression '?' expression ':' conditional_expression
	;

// unary_expression is replaced by IDENTIFIER
// assignement_expression is replaced by conditional_expression
assignment_expression
	: conditional_expression
	| IDENTIFIER assignment_operator conditional_expression
    {
                        check_type(func_table[curr_func_name].symbol_table[string($1.lexeme)].data_type, string($3.type));
                        check_declaration(string($1.lexeme));
                        check_scope(string($1.lexeme));
                        tac.push_back(string($1.lexeme) + " = " + string($3.lexeme) + " " + func_table[curr_func_name].symbol_table[string($1.lexeme)].data_type);

                        if(const_temps.find(string($3.lexeme)) == const_temps.end() && $3.lexeme[0] == '@') free_temp.push(string($3.lexeme));
    }
    | IDENTIFIER '[' conditional_expression ']' '=' conditional_expression {
                        check_type(func_table[curr_func_name].symbol_table[string($1.lexeme)].data_type, string($6.type));
                        if(check_declaration(string($1.lexeme)) && func_table[curr_func_name].symbol_table[string($1.lexeme)].isArray == 0) { 
                            sem_errors.push_back("Line no " + to_string(countn+1) + " : Variable is not an array"); 
                        }
                        check_scope(string($1.lexeme));
                        tac.push_back(string($1.lexeme) + " [ " + string($3.lexeme) + " ] = " + string($6.lexeme) + " " + func_table[curr_func_name].symbol_table[string($1.lexeme)].data_type);

                        if(const_temps.find(string($6.lexeme)) == const_temps.end() && $6.lexeme[0] == '@') free_temp.push(string($6.lexeme));
                    }
	;


assignment_operator
	: '='
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

expression
	: assignment_expression
	| expression ',' assignment_expression
	;

constant_expression
	: conditional_expression
	;

// init_declarator_list is replaced by IDENTIFIER as of now
// new grammar rules are added
// in second rule assignment_expression is replaced by conditional_expression
declaration
	: declaration_specifiers ';'
	| declaration_specifiers IDENTIFIER ';' { 
                        is_reserved_word(string($2.lexeme));
                        // if(multiple_declaration(string($2.lexeme))){
                        //     check_scope(string($2.lexeme));
                        // };
                        tac.push_back("- " + string($1.type) + " " + string($2.lexeme));
                        func_table[curr_func_name].symbol_table[string($2.lexeme)] = { string($1.type), scope_counter, 0, 0, countn+1 };
                    }

	;
    | declaration_specifiers IDENTIFIER '=' conditional_expression ';' {
                        is_reserved_word(string($2.lexeme));
                        //multiple_declaration(string($2.lexeme));
                        check_type(string($1.type), string($4.type));
                        tac.push_back("- " + string($1.type) + " " + string($2.lexeme));
                        tac.push_back(string($2.lexeme) + " = " + string($4.lexeme) + " " + string($1.type));
                        func_table[curr_func_name].symbol_table[string($2.lexeme)] = { string($1.type), scope_counter, 0, 0, countn+1 };

                        if(const_temps.find(string($4.lexeme)) == const_temps.end() && $4.lexeme[0] == '@') free_temp.push(string($4.lexeme));
    }
    |
    declaration_specifiers IDENTIFIER '[' I_CONST ']' ';'
    {
                        is_reserved_word(string($2.lexeme));
                        multiple_declaration(string($2.lexeme));
                        tac.push_back("- " + string($1.type) + " " + string($2.lexeme) + " [ " + string($4.lexeme) + " ] ");
                        func_table[curr_func_name].symbol_table[string($2.lexeme)] = { string($1.type), scope_counter, stoi(string($4.lexeme)), 1, countn+1 };
    }
    declaration_specifiers IDENTIFIER '[' I_CONST ']' '='
    {
                        is_reserved_word(string($2.lexeme));
                        multiple_declaration(string($2.lexeme));
                        tac.push_back("- " + string($1.type) + " " + string($2.lexeme) + " [ " + string($4.lexeme) + " ] ");
                        func_table[curr_func_name].symbol_table[string($2.lexeme)] = { string($1.type), scope_counter, stoi(string($4.lexeme)), 1, countn+1 };
                        curr_array = string($2.lexeme);
    } '{' arr_values '}' ';'
    
arr_values      :   const {
                        check_type(func_table[curr_func_name].symbol_table[curr_array].data_type, string($1.type));
                        tac.push_back(curr_array + " [ " + to_string(arr_index++) + " ] = " + string($1.lexeme) + " " + func_table[curr_func_name].symbol_table[curr_array].data_type);
                        if(arr_index > func_table[curr_func_name].symbol_table[curr_array].size){
                            sem_errors.push_back("Line no: " + to_string(func_table[curr_func_name].symbol_table[curr_array].line_number) + "error: too many initializers for ‘array [" + to_string(func_table[curr_func_name].symbol_table[curr_array].size) + "]’");
                        }
                    } 
                    ',' arr_values
                    | const {
                        check_type(func_table[curr_func_name].symbol_table[curr_array].data_type, string($1.type));
                        tac.push_back(curr_array + " [ " + to_string(arr_index++) + " ] = " + string($1.lexeme) + " " + func_table[curr_func_name].symbol_table[curr_array].data_type);
                        if(arr_index > func_table[curr_func_name].symbol_table[curr_array].size){
                            sem_errors.push_back("Line no: " + to_string(func_table[curr_func_name].symbol_table[curr_array].line_number) + "error: too many initializers for ‘array [" + to_string(func_table[curr_func_name].symbol_table[curr_array].size) + "]’");
                        }
                        arr_index=0;
                    }

const           :   I_CONST {
                        strcpy($$.type, "INT");
                        strcpy($$.lexeme, $1.lexeme);
                    }
                    | F_CONST {
                        strcpy($$.type, "FLOAT");
                        strcpy($$.lexeme, $1.lexeme);
                    }
                    | C_CONST {
                        strcpy($$.type, "CHAR");
                        strcpy($$.lexeme, $1.lexeme);
                    }
                    ;
init_declarator_list
	: init_declarator
	| init_declarator_list ',' init_declarator
	;

init_declarator
	: declarator
	| declarator '=' initializer
	;

storage_class_specifier
	: TYPEDEF
	| EXTERN
	| STATIC
	| AUTO
	| REGISTER
	;


struct_or_union_specifier
	: struct_or_union IDENTIFIER '{' struct_declaration_list '}'
	| struct_or_union '{' struct_declaration_list '}'
	| struct_or_union IDENTIFIER
	;

struct_or_union
	: STRUCT
	| UNION
	;

struct_declaration_list
	: struct_declaration
	| struct_declaration_list struct_declaration
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list ';'
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list
	| type_specifier
	| type_qualifier specifier_qualifier_list
	| type_qualifier
	;

struct_declarator_list
	: struct_declarator
	| struct_declarator_list ',' struct_declarator
	;

struct_declarator
	: declarator
	| ':' constant_expression
	| declarator ':' constant_expression
	;

enum_specifier
	: ENUM '{' enumerator_list '}'
	| ENUM IDENTIFIER '{' enumerator_list '}'
	| ENUM IDENTIFIER
	;

enumerator_list
	: enumerator
	| enumerator_list ',' enumerator
	;

enumerator
	: IDENTIFIER
	| IDENTIFIER '=' constant_expression
	;

type_qualifier
	: CONST
	| VOLATILE
	;

declarator
	: pointer direct_declarator
	| direct_declarator
	;

direct_declarator
	: IDENTIFIER
	| '(' declarator ')'
	| direct_declarator '[' constant_expression ']'
	| direct_declarator '[' ']'
	| direct_declarator '(' parameter_type_list ')'
	| direct_declarator '(' identifier_list ')'
	| direct_declarator '(' ')'
	;

pointer
	: '*'
	| '*' type_qualifier_list
	| '*' pointer
	| '*' type_qualifier_list pointer
	;

type_qualifier_list
	: type_qualifier
	| type_qualifier_list type_qualifier
	;


parameter_type_list
	: parameter_list
	| parameter_list ',' ELLIPSIS
	;

parameter_list
	: parameter_declaration
	| parameter_list ',' parameter_declaration
	;

parameter_declaration
	: declaration_specifiers declarator
	/* | declaration_specifiers abstract_declarator */
	| declaration_specifiers
	;

identifier_list
	: IDENTIFIER
	| identifier_list ',' IDENTIFIER
	;

type_name
	: specifier_qualifier_list
	| specifier_qualifier_list abstract_declarator
	;

abstract_declarator
	: pointer
	| direct_abstract_declarator
	| pointer direct_abstract_declarator
	;

direct_abstract_declarator
	: '(' abstract_declarator ')'
	| '[' ']'
	| '[' constant_expression ']'
	| direct_abstract_declarator '[' ']'
	| direct_abstract_declarator '[' constant_expression ']'
	| '(' ')'
	| '(' parameter_type_list ')'
	| direct_abstract_declarator '(' ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
	;

initializer
	: assignment_expression
	| '{' initializer_list '}'
	| '{' initializer_list ',' '}'
	;

initializer_list
	: initializer
	| initializer_list ',' initializer
	;
// changing compound_statement to declaration_list
statement
	: labeled_statement
	| declaration
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	;

labeled_statement
	: IDENTIFIER ':' statement
	| CASE constant_expression ':' statement
	| DEFAULT ':' statement
	;

compound_statement
	: '{'  '}'
	| '{'
statement_list '}'
	/* | '{' 
	declaration_list '}'
	| '{' 
	

	declaration_list statement_list '}'  */
	;

declaration_list
	: declaration
	| declaration_list declaration

	;

statement_list
	: statement
	| statement_list statement 
	;

expression_statement
	: ';'
	| expression ';'
	;

selection_statement
	: IF '(' expression ')' statement
	| IF '(' expression ')' statement ELSE statement
	| SWITCH '(' expression ')' statement
	;

iteration_statement
	: WHILE '(' expression ')' statement
	| DO statement WHILE '(' expression ')' ';'
	| FOR '(' expression_statement expression_statement ')' statement
	| FOR '(' expression_statement expression_statement expression ')' statement
	;

jump_statement
	: GOTO IDENTIFIER ';'
	| CONTINUE ';'
	| BREAK ';'
	| RETURN ';'
	| RETURN expression ';'
	;
begin : 
	translation_unit

translation_unit
	: external_declaration
	| translation_unit external_declaration
	;


function_definition
	:
	     /* declaration_specifiers declarator declaration_list compound_statement */
	declaration_specifiers MAIN {   
                        if(func_table.find(string($2.lexeme)) != func_table.end()){
                            sem_errors.push_back("Error: Duplicate function name - " + string($2.lexeme));
                        }
                        tac.push_back(string($2.lexeme) + ": " + string($1.type)); 
                        curr_func_name = string($2.lexeme);
                    }
    '(' ')' 
    {
                        func_table[curr_func_name].return_type = string($1.type);
                        func_table[curr_func_name].num_params = 0;
    }
    '{'
     {
                        has_return_stmt = 0;
                        scope_history.push(++scope_counter);
    }
     statement_list '}'
     
     {
                        if(func_table[curr_func_name].return_type != "void" && has_return_stmt == 0){
                            sem_errors.push_back("Return stmt not there for function: " + curr_func_name);
                        }
                        scope_history.pop();
                        --scope_counter;
                        tac.push_back("end:\n");
                        has_return_stmt = 0;
} 
	/* | declaration_specifiers declarator compound_statement
	| declarator declaration_list compound_statement
	| declarator compound_statement */
	;

%%
#include <stdio.h>

/* extern char yytext[]; */
extern int column;

/* yyerror(s)
char *s;
{
	fflush(stdout);
	printf("\n%*s\n%*s\n", column, "^", column, s);
} */

/* int yyerror(char *s){
	
  
  printf("Error \n ");
  printf("%s \n",s);
  yyparse();
} */

int main(int argc, char* argv[])
{

	if(argc > 1)
	{
		FILE *fp = fopen(argv[1], "r");
		if(fp)
			yyin = fp;
	}
	yyparse();
	for(auto item: sem_errors){
        cout << item << endl;
    }
    if(sem_errors.size() > 0)
        exit(0);
    for(auto x: tac)
        cout << x << endl;
	return 0;
}

bool check_declaration(string variable){
    if(func_table[curr_func_name].symbol_table.find(variable) == func_table[curr_func_name].symbol_table.end()){
        sem_errors.push_back("Variable not declared in line " + to_string(countn+1) + " before usage.");
        return false;
    }
    return true;
}

bool check_scope(string variable){
    int var_scope = func_table[curr_func_name].symbol_table[variable].scope;
    // int curr_scope = scope_counter;
    stack<int> temp_stack(scope_history);
    // cout << "variable: " << variable << endl;
    // cout << "var_scope: " << var_scope << endl;
    // PrintStack(temp_stack);
    // cout << endl;
    while(!temp_stack.empty()){
        if(temp_stack.top() == var_scope){
            return true;
        }
        temp_stack.pop();
    }
    sem_errors.push_back("Scope of variable '" + variable +"' not matching in line " + to_string(countn+1) + ".");
    return true;
}

bool multiple_declaration(string variable){
    if(!(func_table[curr_func_name].symbol_table.find(variable) == func_table[curr_func_name].symbol_table.end())){
        sem_errors.push_back("redeclaration of '" + variable + "' in line " + to_string(countn+1));
        return true;
    }
    return false;
}

bool check_type(string l, string r){
    if(r == "FLOAT" && l == "CHAR"){
        sem_errors.push_back("Cannot convert type FLOAT to CHAR in line " + to_string(countn+1));
        return false;
    }
    if(l == "FLOAT" && r == "CHAR"){
        sem_errors.push_back("Cannot convert typr CHAR to FLOAT in line " + to_string(countn+1));
        return false;
    }
    return true;
}

bool is_reserved_word(string id){
    for(auto &item: id){
        item = tolower(item);
    }
    auto iterator = find(reserved.begin(), reserved.end(), id);
    if(iterator != reserved.end()){
        sem_errors.push_back("usage of reserved keyword '" + id + "' in line " + to_string(countn+1));
        return true;
    }
    return false;
}

bool type_check(string type1, string type2) {
    if((type1 == "FLOAT" and type2 == "CHAR") or (type1 == "CHAR" and type2 == "FLOAT")) {
        return true;
    }
    return false;
}

void yyerror(const char* msg) {
    sem_errors.push_back("syntax error in line " + to_string(countn+1));
    for(auto item: sem_errors)
        cout << item << endl;
    fprintf(stderr, "%s\n", msg);
    exit(1);
}

string get_temp(){
    if(free_temp.empty()){
        return "@t" + to_string(variable_count++);
    }
    string t=free_temp.front();
    free_temp.pop(); 
    return t; 
}
void PrintStack(stack<int> s)
{
    if (s.empty())
        return;
    int x = s.top();
    s.pop();
    cout << x << ' ';
    PrintStack(s);
    s.push(x);
}

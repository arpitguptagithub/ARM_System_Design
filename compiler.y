// definition section
// includes declaration of tokens, types of values used
// a literal block, C code in %{ %}

/*
Todo:
1. int a[3][3] = {{1,2},{3,4,5,6}} checking is not done
2. Change symbol_table initialization accordingly - done
3. Switch case
4. Function call - done
5. Classes
6. is_type_same function
7. type_check_arg function
8.  Extend component to include namespace and using directives 
9. for string literals - create a global temp based on file name or something

Note: Removed conditional_expression from assignment_expression
*/

/*

assignemnt_expression modification - removed this
IDENTIFIER assignment_operator conditional_expression
    {
        // Ex: INT a = 10;
        // strcpy($2.type, $1.type);
        // is_multiple_declared(string($2.lexeme));
        is_var_declared(string($1.lexeme));
        is_reserved_word(string($1.lexeme));
        is_in_scope(string($1.lexeme));

        // is_type_same(string($2.type),string($4.type));
        if(string($2.lexeme) == "+="){
        TAC.push_back(string($1.lexeme) + " = " + string($1.lexeme) + " + "+string($3.lexeme) + " " + string($3.type));
        }
        else  if(string($2.lexeme) == "-="){
        TAC.push_back(string($1.lexeme) + " = " + string($1.lexeme) + " - "+string($3.lexeme) + " " + string($3.type));
        }
        else TAC.push_back(string($1.lexeme) + " = " + string($3.lexeme) + " " + string($3.type));
        
        

        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

    }
    | 

/////


Embedded Actions
Rules in yacc may contain embedded actions: list: item1 { do_item1($1); } item2 { do_item2($3); } item3 

Note that the actions take a slot in the stack. As a result do_item2 must use $3 to reference item2. Internally this grammar is transformed by yacc into the following: 
*/
%{
    #include <stdio.h>
    #include <string>
    #include <string.h>
    #include <map>
    #include <vector>
    #include <unordered_map>
    #include <algorithm>
    #include <fstream>
    #include <set>
    #include <queue>
    #include <stack>
    #include <iostream>
    using namespace std;
    int yylex();
    void yyerror(const char *msg);
    int yywrap();
    int yytext();
    extern FILE *yyin;

    #define array_access function_table[curr_function_name].symbol_table_for_vars_in_it[scope_counter][cur_array_name]
    #define array_access_scope function_table[curr_function_name].symbol_table_for_vars_in_it[scope][cur_array_name]
    #define add_tac($$,$1,$2,$3) {strcpy($$.type, $1.type);\
    sprintf($$.lexeme, get_temp().c_str());\
    string lt = string($1.type);\
    string rt = string($3.type);\
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
    semantic_errors.push_back("Cannot convert between CHAR and FLOAT in line: " + to_string(countn + 1));\
    }\
    }

    extern int countn; // line number -> initialized in lexer file

    int is_var_declared(string var);
    bool is_in_scope(string var);
    bool is_multiple_declared(string var);
    bool is_reserved_word(string var);
    bool is_function_declared(string var, int flag);
    bool is_type_same(string var1, string var2);
    bool type_check_arg(string var1, string var2);
    queue<string> free_temp; // previously used var label for local vars but not used now.
    set<string> const_temps; // labels for constants
    map<string, string> temp_map;

    stack<string> if_stack;

    void printStack(stack<int> s);

    struct variable_info {
        string data_type; // ex: INT, FLOAT
        int scope; // ex: outer if or inner if
        int nDims; // ex: for array dimensions
        int isArray; // check for array
        int line_num; // where it is declared
        // arrays
        vector<int> dims;
        int type_size;
        int total_size;
        // pointers 
        int pointer_size;
    }; 

    struct function_info{
        string return_type; // type of return varaible ex: INT, FLOAT
        int num_params; // number of parameters
        vector<string> param_types; // types of those parameters
        unordered_map<int, unordered_map <string, struct variable_info>> symbol_table_for_vars_in_it; // scope -> variable -> var_info; 
    };



    vector<string> TAC;

    string get_temp();
    int variable_count = 0; // for varaible labels
    int label_counter = 1; // for functions
    

    vector<string> semantic_errors; // to store semantic errors

    int temp_index;
    int temp_label;
    stack<int> loop_continue, loop_break;
    stack<pair<string, vector<string>>> func_call_id;


    int get_scope(string var);
    stack<int> scope_history;
    int scope_counter = 0;

    // for functions
    unordered_map<string, struct function_info> function_table;
    string curr_function_name = "";
    int has_return_stmt = 0;
    int num_params = 0;
    vector<string> cur_function_param_types;
    vector<string> reserved_words_vec = {"int", "float", "char", "PRINT", "SCAN", "string", "void", "return", "IF", "ELSE" };
    unordered_map<string,bool> reserved_words;
    stack<pair<string, string>> iteration_break_labels; // label, func_name
    stack<pair<string, string>> iteration_continue_labels; // label, func_name
    vector<struct function_signature> func_details;
    struct function_signature{
        string func_name;
        int num_params ;
        int is_defined;
    };

    // for arrays
    string cur_array_name;
    int cur_array_index = 0;
    int cur_array_depth = 0;

    // for pointers
    string pointer_name;
    int cur_pointer_depth = 0;

    // for global_variables
    struct global_var_info{
        string name;
        int nDims;
        bool is_defined;
    };

    vector<struct global_var_info> global_vars;

%}

%union {
    struct node {
        char lexeme[100]; // to store variable name
        int line_number; // self explanatory
        char type[100]; // type of variable
        char if_body[5]; 
        char else_body[5];
        char loop_body[5];
        char afterIf[5]; // Label to start code after if else is ended
        char case_body[5];
        char id[5];
        char temp[5];
        int nParams;
        int type_size;
    } node;
}

%token  CONSTANT STRING_LITERAL SIZEOF
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token  LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token <node> ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN PRINT SCAN MAIN XOR NEG NOT AND OR BIT_OR BIT_AND EQ NE LE LT GE GT LEFTSHIFT RIGHTSHIFT ADD SUB MUL DIV MOD IDENTIFIER C_CONST S_CONST B_CONST I_CONST F_CONST CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELLIPSIS

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%token CLASS PRIVATE PUBLIC PROTECTED VIRTUAL
%token NEW DELETE THIS OPERATOR TEMPLATE FRIEND
%token NAMESPACE USING THROW TRY CATCH
%type <node>  arg array_level func_call array_constant assignment_operator declaration param assignment_expression unary_operator primary_expression postfix_expression unary_expression cast_expression const multiplicative_expression additive_expression shift_expression relational_expression equality_expression and_expression exclusive_or_expression inclusive_or_expression logical_and_expression conditional_expression logical_or_expression type_specifier declaration_specifiers

%right ASSIGN MUL_ASSIGN ADD_ASSIGN SUB_ASSIGN DIV_ASSIGN



%%

begin:
        components
        {
        TAC.push_back("label glob_init");
        TAC.push_back("return_init");
        TAC.push_back("end_init");
        }
        ;

components
    : component
    | components component
    ;

component:
      class_specifier
    | function_definition {
        curr_function_name = "";
    }
    | declaration { 
        TAC.push_back("return_init");
        TAC.push_back("end_init");

        /*for global variables */}
    ;

class_specifier
    : CLASS IDENTIFIER {
        
    } '{' class_body '}'
    ;

class_body
    : class_member_declaration
    | class_body class_member_declaration
    ;

access_specifier
    : PRIVATE
    | PROTECTED
    | PUBLIC
    ;

class_member_declaration
    : access_specifier ':'
    | member_declaration
    ;

member_declaration
    : declaration
    | function_definition
    | constructor_definition
    | destructor_definition
    ;

destructor_definition
    : '~' IDENTIFIER '(' ')' block_statement
    ;

constructor_definition
    : IDENTIFIER '(' param_list ')'  block_statement
    ;

function_definition:
    declaration_specifiers MAIN 
    {
                string func_name = string($2.lexeme);
        if(function_table.find(func_name) != function_table.end()){
            semantic_errors.push_back("Error: Duplicate function name - " + func_name);
        }

        TAC.push_back(func_name + ": " + string($1.type));
        function_table[curr_function_name].return_type = string($1.type);
        curr_function_name = func_name;
        function_table[curr_function_name].num_params = 0;
    }
    '(' ')'
    block_statement {
        if(function_table[curr_function_name].return_type != "void" && has_return_stmt == 0){
            semantic_errors.push_back("Return statement not there for non-void function: " + curr_function_name);
        }
        unordered_map <string, struct variable_info> temp;
        function_table[curr_function_name].symbol_table_for_vars_in_it[scope_counter] = temp;
        
        func_details.push_back({curr_function_name, function_table[curr_function_name].num_params, 1});

        scope_history.pop();
        scope_counter--;
        TAC.push_back("end: \n");
        has_return_stmt = 0;
    }
    

    | declaration_specifiers IDENTIFIER {
        string func_name = string($2.lexeme);
        if(function_table.find(func_name) != function_table.end()){
            semantic_errors.push_back("Error: Duplicate function name - " + func_name);
        }
        // printf("\n-dsa%sdsa-\n", $1.type);
        // cout << "type: "<<$1.type << endl;
        TAC.push_back(func_name + ": " + string($1.type));
        curr_function_name = func_name;
        function_table[curr_function_name].return_type = string($1.type);
    } '(' param_list ')' {
        function_table[curr_function_name].num_params = num_params;
        num_params = 0;
    } block_statement {
        if(function_table[curr_function_name].return_type != "void" && has_return_stmt == 0){
            semantic_errors.push_back("Return statement not there for non-void function: " + curr_function_name);
        }

        func_details.push_back({curr_function_name, function_table[curr_function_name].num_params, 1});


        scope_history.pop();
        scope_counter--;
        TAC.push_back("end: \n");
        has_return_stmt = 0;
    }
    ;
param_list : 
    param {
        num_params++; 
        function_table[curr_function_name].param_types.push_back(string($1.type));
        function_table[curr_function_name].symbol_table_for_vars_in_it[scope_counter + 1][string($1.lexeme)] = {string($1.type), scope_counter + 1, 0, 0, countn + 1};
        TAC.push_back("-  arg " + string($1.type) + " " + string($1.lexeme));
    } ',' param_list
    | param {
        num_params++; 
        function_table[curr_function_name].param_types.push_back(string($1.type));
        function_table[curr_function_name].symbol_table_for_vars_in_it[scope_counter + 1][string($1.lexeme)] = {string($1.type), scope_counter + 1, 0, 0, countn + 1};
        TAC.push_back("-  arg " + string($1.type) + " " + string($1.lexeme));
    } 
    | {
        
    }
    ;

param : type_specifier IDENTIFIER {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $2.lexeme);
}


declaration_specifiers:
    type_specifier {
        strcpy($$.type, $1.type);
        $$.type_size = $1.type_size;
    }
    | type_qualifier declaration_specifiers

    ;

type_specifier : 
    VOID 
    {
        sprintf($$.type, "void");
    }
    | CHAR 
    {
                sprintf($$.type, "CHAR");
                $$.type_size = 1;
    }
    | SHORT
    {
                   sprintf($$.type, "SHORT");
                   $$.type_size = 2;
    } 
    | INT {
                   sprintf($$.type, "INT");
                   $$.type_size = 4;

    }
    | FLOAT {
                   sprintf($$.type, "FLOAT");
                    $$.type_size = 4;
    }
    | DOUBLE{
                   sprintf($$.type, "DOUBLE");
                   $$.type_size = 8;
    }

    ;

type_qualifier:
    CONST
    | VOLATILE
    ;

statement_list:
    statement 
    | statement_list statement
    ;

statement
    : 
    labeled_statement
    {/* for switch cases, goto  if required */}
	| declaration
    {/* declarations */}
	| assignment_expression ';'
    { /*1102*/ }
    | conditional_expression ';'
	| selection_statement
	| iteration_statement
	| jump_statement
	;


/* IO_statement: 
    PRINT '(' STRING_LITERAL ')' 
    {
        TAC.push_back("PRINT " + string($3.lexeme)+ " " + "STR" );
    }
    | PRINT '(' conditional_expression ')' 
    {
        TAC.push_back("PRINT " + string($3.lexeme) + " " + string($3.type));
    }
    | 
    SCAN '(' postfix_expression ')' 
    {
        is_var_declared(string($3.lexeme));
        string temp = get_temp();
        TAC.push_back("SCAN " + temp + " " + string($3.type));
        TAC.push_back(string($3.lexeme) + " = " + temp + " " + string($3.type));
        free_temp.push(temp);
    } */
    
/*  INPUT OC ID OS expr CS CC SCOL {
                        check_declaration($3.lexeme);
                        string temp = get_temp();
                        tac.push_back("input " + temp + " " + func_table[curr_func_name].symbol_table[string($3.lexeme)].data_type);
                        tac.push_back(string($3.lexeme) + " [ " + string($5.lexeme) + " ] = " + temp + " " + func_table[curr_func_name].symbol_table[string($3.lexeme)].data_type);
                        free_temp.push(temp);
                        // check_scope(string($3.lexeme));
                    } */

block_statement: 
    '{' '}'
    | '{' 
    {
        scope_history.push(++scope_counter);
    }
    statement_list '}' 
;

labeled_statement : 
        CASE IDENTIFIER ':' block_statement
    |   DEFAULT ':' statement
;

/*
    // init_declarator_list is replaced by IDENTIFIER as of now
    // new grammar rules are added
    // in second rule assignment_expression is replaced by conditional_expression
    // arrays to be done
    */
declaration
    : declaration_specifiers IDENTIFIER ';' {
        if(curr_function_name == ""){
            TAC.push_back("label glob_init");
        }
        strcpy($2.type, $1.type);
        is_multiple_declared(string($2.lexeme));
        is_reserved_word(string($2.lexeme));
        TAC.push_back("- " + string($2.type) + " " + string($2.lexeme));
        vector<int> temp;
        function_table[curr_function_name].symbol_table_for_vars_in_it[scope_counter][string($2.lexeme)] = {string($2.type), scope_counter, 0 , 0, countn + 1,temp, $1.type_size, $1.type_size,0};
        if(curr_function_name == "")
        global_vars.push_back({string($2.lexeme),  0, false});
    }
    | declaration_specifiers IDENTIFIER {
        if(curr_function_name == ""){
            TAC.push_back("label glob_init");
        }

    }ASSIGN conditional_expression ';' {
        strcpy($2.type, $1.type);
        is_multiple_declared(string($2.lexeme));
        is_reserved_word(string($2.lexeme));
        TAC.push_back("- " + string($2.type) + " " + string($2.lexeme));
        TAC.push_back(string($2.lexeme) + " = " + string($5.lexeme) + " " + string($5.type));
        
        vector<int> temp;
        function_table[curr_function_name].symbol_table_for_vars_in_it[scope_counter][string($2.lexeme)] = {string($2.type), scope_counter, 0 , 0, countn + 1,temp, $1.type_size, $1.type_size,0};

        if(const_temps.find(string($5.lexeme)) == const_temps.end() && string($5.lexeme)[0] == '@') free_temp.push(string($5.lexeme));
        
        if(curr_function_name == "")
            global_vars.push_back({string($2.lexeme), 0,  true});

    }
    | declaration_specifiers IDENTIFIER {
        if(curr_function_name == ""){
            TAC.push_back("label glob_init");
        }
        strcpy($2.type, $1.type);
        is_multiple_declared(string($2.lexeme));
        is_reserved_word(string($2.lexeme));
        // TAC.push_back("- " + string($2.type) + " " + string($2.lexeme));
        cur_array_name = string($2.lexeme);
        vector<int> temp;
        function_table[curr_function_name].symbol_table_for_vars_in_it[scope_counter][string($2.lexeme)] = {string($2.type), scope_counter, 0 , 1, countn + 1, temp, 0,0,0};
    } array_constant {
         reverse(array_access.dims.begin(), array_access.dims.end());
        int total_size = 1;
        for(int i : array_access.dims){
            total_size *= i;
        }

        total_size  *= $1.type_size;
        array_access.total_size = total_size;
        array_access.type_size = $1.type_size;
        TAC.push_back("- " + string($2.type) + " " + string($2.lexeme) + '[' + to_string((int)(array_access.total_size / int (array_access.type_size))) +']');
        if(curr_function_name == "")
        global_vars.push_back({string($2.lexeme), array_access.dims.size(), false});
        
    }array_declaration {
                

        cur_array_index = 0;
    }
    | declaration_specifiers pointers_level IDENTIFIER {    
        strcpy($3.type, $1.type);
        is_multiple_declared(string($3.lexeme));
        is_reserved_word(string($3.lexeme));
        vector<int> temp;
        function_table[curr_function_name].symbol_table_for_vars_in_it[scope_counter][string($3.lexeme)] = {string($3.type), scope_counter, 0 , 0, countn + 1,temp, $1.type_size, $1.type_size,cur_pointer_depth};
        string temp1 = "";
        for(int i =0 ; i < cur_pointer_depth; i++){
            temp1 += '*';
        }
        TAC.push_back("- " + string($3.type) + " " + temp1 + string($3.lexeme));
        cur_pointer_depth = 0;
    }
    ;


pointers_level : 
MUL pointers_level {
    cur_pointer_depth++;
}|
MUL {
    cur_pointer_depth++;
} 
;

array_declaration
    : array_declaration_without_init
    | array_declaration_with_init {
        if(curr_function_name=="")
        global_vars[global_vars.size() - 1].is_defined = true;
    }
    ;

array_declaration_without_init
    : ';' 
    ;

array_declaration_with_init
    : ASSIGN array_contents ';' 
    ;

array_constant
    : '[' I_CONST ']' {
        array_access.nDims = 1;
        array_access.dims.push_back(stoi(string($2.lexeme)));
    }
    | array_constant '[' I_CONST ']' {
        array_access.nDims++;
        array_access.dims.push_back(stoi(string($3.lexeme)));
    }
    ;


array_contents:
    '{' array_values '}' |
    '{' array_contents ',' '{' array_values '}' '}'
    ;

array_values:
    const {
        is_type_same(array_access.data_type, string($1.type));
        TAC.push_back(cur_array_name + "[" + to_string(cur_array_index++) + "] = " + string($1.lexeme) + " " + array_access.data_type);
        if(cur_array_index > (int)(array_access.total_size / int (array_access.type_size))){
            semantic_errors.push_back("Line no: "+ to_string(array_access.line_num) + "error: too many initializers for 'array [" + to_string((int)(array_access.total_size / int (array_access.type_size))) + "]");
        }        
    }
    ',' array_values
    |
    const {
        is_type_same(array_access.data_type, string($1.type));
        TAC.push_back(cur_array_name + "[" + to_string(cur_array_index++) + "] = " + string($1.lexeme) + " " + array_access.data_type);
        if(cur_array_index > (int)(array_access.total_size / int (array_access.type_size))){
            semantic_errors.push_back("Line no: "+ to_string(array_access.line_num) + "error: too many initializers for 'array [" + to_string((int)(array_access.total_size / int (array_access.type_size))) + "]");
        }        
    }
assignment_operator:
    ASSIGN
    {
                strcpy($$.lexeme, $1.lexeme);

    }
    | MUL_ASSIGN 
    {
                strcpy($$.lexeme, $1.lexeme);

    }
    | DIV_ASSIGN
    {
                strcpy($$.lexeme, $1.lexeme);

    }
    | ADD_ASSIGN
    {
                strcpy($$.lexeme, $1.lexeme);

    }
    | SUB_ASSIGN
    {
                strcpy($$.lexeme, $1.lexeme);

    }
    | MOD_ASSIGN
    {
                strcpy($$.lexeme, $1.lexeme);

    }
    | LEFT_ASSIGN
    | RIGHT_ASSIGN
    | AND_ASSIGN
    | XOR_ASSIGN
    | OR_ASSIGN

conditional_expression
    : logical_or_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
    | logical_or_expression '?' conditional_expression ':' conditional_expression {

        strcpy($$.type, $3.type);
        sprintf($$.lexeme, get_temp().c_str());

        // add_tac($$,$1,$2,$3)

        string t0 = get_temp();
        string dtype = string($$.type);
        TAC.push_back(t0 + " = " + "~ "+string($1.lexeme)  + " " +dtype);


        string l0 = "#L" + to_string(++label_counter);

        string a = string($$.lexeme);
        string b = string($3.lexeme);
        string c = string($5.lexeme);
        // string dtype=  string($$.type);



        TAC.push_back(a + " = " + c + " " + dtype);
        TAC.push_back("if " +  t0 + " GOTO " + l0);
        TAC.push_back(a + " = " + b + " " +dtype);
        TAC.push_back(l0 + ":");

        // TAC.push_back("if " +  c + "GOTO " + "#L"+ l0);

        free_temp.push(t0);


        if(const_temps.find(string($1.lexeme)) == const_temps.end() && string($1.lexeme)[0] == '@') free_temp.push(string($1.lexeme));
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));
        if(const_temps.find(string($5.lexeme)) == const_temps.end() && string($5.lexeme)[0] == '@') free_temp.push(string($5.lexeme));

        label_counter++;

    }
    ;

logical_or_expression
    : logical_and_expression {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
        
    }
    | logical_or_expression OR logical_and_expression
    {
        add_tac($$,$1,$2,$3)

        string l0 = "#L" + to_string(++label_counter);

        string a = string($$.lexeme);
        string b = string($1.lexeme);
        string c = string($3.lexeme);
        string dtype=  string($$.type);



        TAC.push_back(a + " = " + "0" + " " +dtype);
        TAC.push_back("if " +  b + " GOTO " + "#L"+ l0);
        TAC.push_back("if " +  c + " GOTO " + "#L"+ l0);
        TAC.push_back(a + " = " + "1" + " " +dtype);
        TAC.push_back(l0 + ":");



        if(const_temps.find(string($1.lexeme)) == const_temps.end() && string($1.lexeme)[0] == '@') free_temp.push(string($1.lexeme));
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

        label_counter++;

    }
    ;

logical_and_expression:
    inclusive_or_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
    | logical_and_expression AND inclusive_or_expression
    {
        add_tac($$,$1,$2,$3)

        string l0 = "#L" + to_string(++label_counter);

        string a = string($$.lexeme);
        string b = string($1.lexeme);
        string c = string($3.lexeme);
        string dtype=  string($$.type);

        string t0 = get_temp();
        string t1 = get_temp();

        TAC.push_back(t0 + " = " + "~ "+b  + " " +dtype);
        TAC.push_back(t1 + " = " + "~ "+ c  + " " +dtype);
        TAC.push_back(a + " = " + "0" + " " +dtype);

        TAC.push_back("if " +  t0 + " GOTO " + "#L"+ l0);
        TAC.push_back("if " +  t1 + " GOTO " + "#L"+ l0);
        TAC.push_back(a + " = " + "1" + " " +dtype);
        TAC.push_back(l0 + ":");

        free_temp.push(t0);
        free_temp.push(t1);


        if(const_temps.find(string($1.lexeme)) == const_temps.end() && string($1.lexeme)[0] == '@') free_temp.push(string($1.lexeme));
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

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
        add_tac($$,$1,$2,$3)

        string a = string($$.lexeme);
        string b = string($1.lexeme);
        string c = string($3.lexeme);
        string dtype=  string($$.type);

        TAC.push_back(a + " = " + b + " | " + c + " " +dtype);

        if(const_temps.find(string($1.lexeme)) == const_temps.end() && string($1.lexeme)[0] == '@') free_temp.push(string($1.lexeme));
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

        
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
        add_tac($$,$1,$2,$3)

        string a = string($$.lexeme);
        string b = string($1.lexeme);
        string c = string($3.lexeme);
        string dtype=  string($$.type);

        string t0 = get_temp();
        string t1 = get_temp();
        string t2 = get_temp();
        string t3 = get_temp();


        TAC.push_back(t0 + " = " + "~ "+b  + " " +dtype);
        TAC.push_back(t1 + " = " + "~ "+ c  + " " +dtype);
        TAC.push_back(t2 + " = " + b + " & " + t1 + " " +dtype);
        TAC.push_back(t3 + " = " + c + " & " + t0 + " " +dtype);

        TAC.push_back(a + " = " + t2 + " | " + t3 + " " +dtype);

        free_temp.push(t0);
        free_temp.push(t1);
        free_temp.push(t2);
        free_temp.push(t3);


        if(const_temps.find(string($1.lexeme)) == const_temps.end() && string($1.lexeme)[0] == '@') free_temp.push(string($1.lexeme));
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

        
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
        add_tac($$,$1,$2,$3)

        string a = string($$.lexeme);
        string b = string($1.lexeme);
        string c = string($3.lexeme);
        string dtype=  string($$.type);

        TAC.push_back(a + " = " + b + " & " + c + " " +dtype);

        if(const_temps.find(string($1.lexeme)) == const_temps.end() && string($1.lexeme)[0] == '@') free_temp.push(string($1.lexeme));
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

        
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
        add_tac($$,$1,$2,$3)

        string a = string($$.lexeme);
        string b = string($1.lexeme);
        string c = string($3.lexeme);
        string dtype=  string($$.type);

        TAC.push_back(a + " = " + b + " == " + c + " " +dtype);

        if(const_temps.find(string($1.lexeme)) == const_temps.end() && string($1.lexeme)[0] == '@') free_temp.push(string($1.lexeme));
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

        
    }
    | equality_expression NE relational_expression
    { // has to be changed from != to ==
        add_tac($$,$1,$2,$3)

        string a = string($$.lexeme);
        string b = string($1.lexeme);
        string c = string($3.lexeme);
        string dtype=  string($$.type);

        TAC.push_back(a + " = " + b + " != " + c + " " +dtype);

        if(const_temps.find(string($1.lexeme)) == const_temps.end() && string($1.lexeme)[0] == '@') free_temp.push(string($1.lexeme));
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

        
    }
    ;

relational_expression
    : shift_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
    | relational_expression LT shift_expression
    {
        {
        add_tac($$,$1,$2,$3)

        string a = string($$.lexeme);
        string b = string($1.lexeme);
        string c = string($3.lexeme);
        string dtype=  string($$.type);

        TAC.push_back(a + " = " + b + " < " + c + " " +dtype);

        if(const_temps.find(string($1.lexeme)) == const_temps.end() && string($1.lexeme)[0] == '@') free_temp.push(string($1.lexeme));
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

        
    }
    }
    |
    relational_expression GT shift_expression
    {
        add_tac($$,$1,$2,$3)

        string a = string($$.lexeme);
        string b = string($1.lexeme);
        string c = string($3.lexeme);
        string dtype=  string($$.type);

        TAC.push_back(a + " = " + b + " > " + c + " " +dtype);

        if(const_temps.find(string($1.lexeme)) == const_temps.end() && string($1.lexeme)[0] == '@') free_temp.push(string($1.lexeme));
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

        
    }
    | relational_expression LE shift_expression
    {
        add_tac($$,$1,$2,$3)

        string a = string($$.lexeme);
        string b = string($1.lexeme);
        string c = string($3.lexeme);
        string dtype=  string($$.type);

        TAC.push_back(a + " = " + b + " <= " + c + " " +dtype);

        if(const_temps.find(string($1.lexeme)) == const_temps.end() && string($1.lexeme)[0] == '@') free_temp.push(string($1.lexeme));
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

        
    }
    |
    relational_expression GE shift_expression
    {
        add_tac($$,$1,$2,$3)

        string a = string($$.lexeme);
        string b = string($1.lexeme);
        string c = string($3.lexeme);
        string dtype=  string($$.type);

        TAC.push_back(a + " = " + b + " >= " + c + " " +dtype);

        if(const_temps.find(string($1.lexeme)) == const_temps.end() && string($1.lexeme)[0] == '@') free_temp.push(string($1.lexeme));
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

        
    }
    ;

shift_expression
    : additive_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
    | shift_expression LEFTSHIFT additive_expression
    {}
    | shift_expression RIGHTSHIFT additive_expression
    {}
    ;

additive_expression
    : multiplicative_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
    | additive_expression ADD multiplicative_expression
    {
        add_tac($$,$1,$2,$3)

        string a = string($$.lexeme);
        string b = string($1.lexeme);
        string c = string($3.lexeme);
        string dtype=  string($$.type);

        TAC.push_back(a + " = " + b + " + " + c + " " +dtype);

        if(const_temps.find(string($1.lexeme)) == const_temps.end() && string($1.lexeme)[0] == '@') free_temp.push(string($1.lexeme));
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

        label_counter++;
        
    }
    | additive_expression SUB multiplicative_expression
    {
        add_tac($$,$1,$2,$3)

        string a = string($$.lexeme);
        string b = string($1.lexeme);
        string c = string($3.lexeme);
        string dtype=  string($$.type);

        TAC.push_back(a + " = " + b + " - " + c + " " +dtype);
        
        if(const_temps.find(string($1.lexeme)) == const_temps.end() && string($1.lexeme)[0] == '@') free_temp.push(string($1.lexeme));
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

        label_counter++;
    }
    ;

multiplicative_expression
    : cast_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
    | multiplicative_expression MUL cast_expression
    {
        add_tac($$,$1,$2,$3)
        // method - 1, direct multiplication operation
        // method - 2, multiplication by addition

        string a = string($$.lexeme);
        string b = string($1.lexeme);
        string c = string($3.lexeme);
        string dtype =  string($$.type);
        // method-1

        TAC.push_back(a + " = " + b + " * " + c + " " +dtype);

        // method-2
        // a = b * c
        // conversion- 
        // i = 1
        // L0:
        // if i > c:
        // goto L1
        // j = j + b
        // i = i + 1
        // goto L0
        // L1:
        // a = j

        // string t0 = get_temp();
        // string t1 = get_temp();
        // // string t2 = get_temp();

        // TAC.push_back(t0 + " = 1" + " " + dtype);
        // TAC.push_back("#L" + to_string(++label_counter) + ":");
        // TAC.push_back(t1 + " = " + t0 + " > " + c + " " + dtype);
        // TAC.push_back("if " +  t1 + " GOTO " + "#L"+ to_string(++label_counter));
        // TAC.push_back(a + " = " + a + " + " + b + " " + dtype);
        // TAC.push_back(t0 + " = " + t0 + " + 1" + " " + dtype);
        // TAC.push_back("GOTO %L" + to_string(label_counter-1));
        // TAC.push_back("#L" + to_string(label_counter) + ":");
        
        // free_temp.push(t0);
        // free_temp.push(t1);
        // free_temp.push(t2);

        if(const_temps.find(string($1.lexeme)) == const_temps.end() && string($1.lexeme)[0] == '@') free_temp.push(string($1.lexeme));
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

        label_counter++;
    }
    | multiplicative_expression DIV cast_expression
    {
        add_tac($$,$1,$2,$3)

        // division
        // a = b /c ; a = 25 /3;
        // q = 0
        // L0:
        // if b < c goto L1:
        // b = b - c
        // q= q+1
        // goto L0
        // L1:
        // a= q

        string a = string($$.lexeme);
        string b = string($1.lexeme);
        string c = string($3.lexeme);
        string dtype=  string($$.type);

        string t0 = get_temp();
        string t1 = get_temp();
        string t2 = get_temp();

        TAC.push_back(t0 + " = 0" + " "+dtype);
        TAC.push_back(t2 + " = " + b +  " "+dtype);
        TAC.push_back("#L" + to_string(++label_counter) + ":");
        TAC.push_back(t1 + " = " + t2 + " < " + c + " " + dtype);
        TAC.push_back("if " +  t1 + " GOTO " + "#L"+ to_string(++label_counter));
        TAC.push_back(t2 + " = " + t2 + " - " + c + " " + dtype);
        TAC.push_back(t0 + " = " + t0 + " + 1" + " " + dtype);
        TAC.push_back("GOTO %L" + to_string(label_counter-1));
        TAC.push_back("#L" + to_string(label_counter) + ":");
        TAC.push_back(a + " = " + t0 + " " + dtype);
        free_temp.push(t0);
        free_temp.push(t1);
        free_temp.push(t2);

        if(const_temps.find(string($1.lexeme)) == const_temps.end() && string($1.lexeme)[0] == '@') free_temp.push(string($1.lexeme));
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

        label_counter++;
    }
    |
    multiplicative_expression MOD cast_expression
    {
        
        add_tac($$,$1,$2,$3)

        // division
        // a = b /c ; a = 25 /3;
        // q = 0
        // L0:
        // if b < c goto L1:
        // b = b - c
        // q= q+1
        // goto L0
        // L1:
        // a = b

        string a = string($$.lexeme);
        string b = string($1.lexeme);
        string c = string($3.lexeme);
        string dtype=  string($$.type);

        string t0 = get_temp();
        string t1 = get_temp();
        string t2 = get_temp();

        TAC.push_back(t0 + " = 0" + " "+dtype);
        TAC.push_back(t2 + " = " + b +  " "+dtype);
        TAC.push_back("#L" + to_string(++label_counter) + ":");
        TAC.push_back(t1 + " = " + t2 + " < " + c + " " + dtype);
        TAC.push_back("if " +  t1 + " GOTO " + "#L"+ to_string(++label_counter));
        TAC.push_back(t2 + " = " + t2 + " - " + c + " " + dtype);
        TAC.push_back(t0 + " = " + t0 + " + 1" + " " + dtype);
        TAC.push_back("GOTO %L" + to_string(label_counter-1));
        TAC.push_back("#L" + to_string(label_counter) + ":");
        TAC.push_back(a + " = " + t2 + " " + dtype);
        free_temp.push(t0);
        free_temp.push(t1);
        free_temp.push(t2);


        if(const_temps.find(string($1.lexeme)) == const_temps.end() && string($1.lexeme)[0] == '@') free_temp.push(string($1.lexeme));
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

        label_counter++;
    }
    ;

cast_expression
    : unary_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
    | '(' type_specifier ')' cast_expression
    {}
    ;

unary_expression
    : postfix_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }
    | INC_OP unary_expression {
        strcpy($$.type, $2.type);
        strcpy($$.lexeme, get_temp().c_str());
        TAC.push_back(string($2.lexeme) + " = " + string($2.lexeme) + " + 1 " + string($$.type));
        TAC.push_back(string($$.lexeme) + " = " + string($2.lexeme)+ " "+ string($$.type));
        const_temps.insert(string($$.lexeme));
    }

    | DEC_OP unary_expression {
        strcpy($$.type, $2.type);
        strcpy($$.lexeme, get_temp().c_str());
        TAC.push_back(string($2.lexeme) + " = " + string($2.lexeme) + " - 1 " + string($$.type));
        TAC.push_back(string($$.lexeme) + " = " + string($2.lexeme)+ " "+ string($$.type));
        const_temps.insert(string($$.lexeme));
    }
    | unary_operator primary_expression 
    {}
    | '$' primary_expression {
                strcpy($$.type, $2.type);
                string temp = get_temp();
                sprintf($$.lexeme, temp.c_str());
                TAC.push_back(string($$.lexeme) + " = $"  + string($2.lexeme) + " " + string($$.type));
                // temp_map[string($1.lexeme)] = string($$.lexeme);
                const_temps.insert(temp);
    }

    ;

unary_operator :
    ADD 
    | NEG
    | NOT
    ;

postfix_expression
    : primary_expression
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
        
    }
    |
    primary_expression {
        cur_array_name = string($1.lexeme);
        int scope = is_var_declared(cur_array_name);
        scope--;
        if(scope+1 && array_access_scope.isArray == 0){
            
            semantic_errors.push_back("Line no " + to_string(countn + 1)+ ": variable is not an array");
        }
        is_in_scope(cur_array_name);

    } array_level{
         int scope = is_var_declared(cur_array_name);
        scope--;
        strcpy($$.type, array_access_scope.data_type.c_str());
        sprintf($$.lexeme, get_temp().c_str());
        TAC.push_back(string($$.lexeme) + " = " + string($1.lexeme) + "[" + string($3.lexeme) + "] " + string($$.type));
    }
    | postfix_expression INC_OP
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, get_temp().c_str());
        TAC.push_back(string($$.lexeme) + " = " + string($1.lexeme)+ " "+ string($$.type));
        TAC.push_back(string($1.lexeme) + " = " + string($1.lexeme) + " + 1 " + string($$.type));
        const_temps.insert(string($$.lexeme));
    }
    | postfix_expression DEC_OP
    {
        strcpy($$.type, $1.type);
        strcpy($$.lexeme, get_temp().c_str());
        TAC.push_back(string($$.lexeme) + " = " + string($1.lexeme)+ " "+ string($$.type));
        TAC.push_back(string($1.lexeme) + " = " + string($1.lexeme) + " - 1 " + string($$.type));
        const_temps.insert(string($$.lexeme));
    }
    | postfix_expression '.' IDENTIFIER
    {}
    |
     /* postfix_expression PTR_OP IDENTIFIER
    {
        strcpy($$.type, function_table[curr_function_name].symbol_table_for_vars_in_it[get_scope($1.lexeme)][$3.lexeme].data_type.c_str());
        strcpy($$.lexeme, $1.lexeme);
        
    } */
    |  pointers_level postfix_expression {
        string temp = "";
        for(int i =0 ; i < cur_pointer_depth; i++){
            temp += '*';
        }

        strcpy($$.type, $2.type);
        strcpy($$.lexeme, $2.lexeme);

        // TAC.push_back("- " + string($3.type) + " " + temp + string($3.lexeme));
        cur_pointer_depth = 0;
    }
    
    

    | func_call {
strcpy($$.type, $1.type);
        strcpy($$.lexeme, $1.lexeme);
    }

    ;

array_level :
    '[' conditional_expression ']'
    {
        if(string($2.type) != "INT"){
            semantic_errors.push_back("Line no: " + to_string(countn + 1)+ ": "+ string($2.type) + " used for array access");
        }
        string t0 = get_temp();
        TAC.push_back(t0 + " = "+ string($2.lexeme) + " INT");
        sprintf($$.lexeme, t0.c_str());
        cur_array_depth = 0;
    }
    |  '[' conditional_expression ']' array_level {
         if(string($2.type) != "INT"){
            semantic_errors.push_back("Line no: " + to_string(countn + 1)+ ": "+ string($2.type) + " used for array access");
        }
        string t2 = get_temp();

        string t0 = get_temp();
        string t1 = get_temp();
        // string t2 = get_temp();

        int scope = is_var_declared(cur_array_name);
        scope--;
        // Method-1 for multplication

        // TAC.push_back(t0 + " = 0" + " " + "INT");
        // TAC.push_back(t2 + " = 0" + " " + "INT");
        // TAC.push_back("#L" + to_string(++label_counter) + ":");
        // TAC.push_back(t1 + " = " + t0 + " > " + to_string(array_access_scope.dims[cur_array_depth]) + " " + "INT");
        // TAC.push_back("if " +  t1 + " GOTO " + "#L"+ to_string(++label_counter));
        // TAC.push_back(t2 + " = " + t2 + " + " + string($2.lexeme) + " " + "INT");
        // TAC.push_back(t0 + " = " + t0 + " + 1" + " " + "INT");
        // TAC.push_back("GOTO %L" + to_string(label_counter-1));
        // TAC.push_back("#L" + to_string(label_counter) + ":");

        // Method-2 for multplication

        TAC.push_back(t2 + " = " + string($2.lexeme) + " * " + to_string(array_access_scope.dims[cur_array_depth]) + " " + "INT");

        TAC.push_back(t2 + " = "+ t2 + " + "+ string($4.lexeme)  + " INT");
        sprintf($$.lexeme, t2.c_str());
        cur_array_depth++;
        free_temp.push(t0);
        free_temp.push(t1);

        if(const_temps.find(string($4.lexeme)) == const_temps.end() && string($4.lexeme)[0] == '@') free_temp.push(string($4.lexeme));

        label_counter++;

    }
    
    ;

func_call : 
    IDENTIFIER {
        func_call_id.push({string($1.lexeme), function_table[string($1.lexeme)].param_types});
    }
    '(' arg_list ')' {
        strcpy($$.type, function_table[string($1.lexeme)].return_type.c_str());
        // printf("\n-dsa%sdsa-\n", $$.type);
        func_call_id.pop();
        sprintf($$.lexeme, get_temp().c_str());
        // TAC.push_back(string($$.lexeme) + " = @call " + string($1.lexeme) + " " + function_table[string($1.lexeme)].return_type + " "+ to_string(function_table[string($1.lexeme)].num_params));
            TAC.push_back(string($$.lexeme) + " = @call " + string($1.lexeme) + " "+ to_string(function_table[string($1.lexeme)].num_params));

    }
    ;
arg_list : arg ',' arg_list {
        int _size = func_call_id.top().second.size();
        string type = func_call_id.top().second[_size-1];
        func_call_id.top().second.pop_back();
        if(type_check_arg(string($1.type), type)){
            semantic_errors.push_back("datatype for argument not matched in line " + to_string(countn + 1));
        }
    } | 
    arg {
        int _size = func_call_id.top().second.size();
        string type = func_call_id.top().second[_size-1];
        func_call_id.top().second.pop_back();
        if(type_check_arg(string($1.type), type)){
            semantic_errors.push_back("datatype for argument not matched in line " + to_string(countn + 1));
        }
    }
    ;
    arg : conditional_expression{
        TAC.push_back("param " + string($1.lexeme) + " " + string($1.type));
        strcpy($$.type, $1.type);
    }

primary_expression 
    : IDENTIFIER
    {
        is_var_declared(string($1.lexeme));
        is_in_scope(string($1.lexeme));
        is_reserved_word(string($1.lexeme));
        strcpy($$.lexeme, $1.lexeme);
        strcpy($$.type, function_table[curr_function_name].symbol_table_for_vars_in_it[get_scope($1.lexeme)][$1.lexeme].data_type.c_str());
        // cur_array_name = string($1.lexeme);
        // cur_array_depth = 1;
    }
    | const 
    {
        strcpy($$.type, $1.type);
        string temp = get_temp();
        sprintf($$.lexeme, temp.c_str());
        TAC.push_back(string($$.lexeme) + " = " + string($1.lexeme) + " " + string($$.type));
        // temp_map[string($1.lexeme)] = string($$.lexeme);
        const_temps.insert(temp);

    }
    | STRING_LITERAL
    | '(' conditional_expression ')' {
        strcpy($$.type, $2.type);
        strcpy($$.lexeme, $2.lexeme);
    }
    | THIS
    ;

const 
    : I_CONST {
        printf("%s", $1.lexeme);
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


argument_expression_list
    : assignment_expression
    {}
    | argument_expression_list ',' assignment_expression
    {}
    ;


    

selection_statement
    : IF {
        // scope also has to be handled
        // sprintf($1.afterIf, "#L%d", label_counter++);
        if_stack.push("#L" + to_string(label_counter++));
    } '(' conditional_expression ')' {

        // jump handling

        string b = string($4.lexeme);
        string t0 = get_temp();
        string dtype = string($4.type);

        TAC.push_back(t0 + " = " + "~ "+b  + " " +dtype);
        TAC.push_back("if " +  t0  + " GOTO " + "#L"+ to_string(label_counter++));
        sprintf($4.else_body, "#L%d", label_counter - 1);

        // recycling labels

        free_temp.push(t0);
        if(const_temps.find(string($4.lexeme)) == const_temps.end() && string($4.lexeme)[0] == '@') free_temp.push(string($4.lexeme));

        
    } block_statement 
    {

        // scope handling
        unordered_map <string, struct variable_info> temp;
        function_table[curr_function_name].symbol_table_for_vars_in_it[scope_counter] = temp;
        scope_history.pop();
        --scope_counter;

        // jump handling

        TAC.push_back("GOTO " +  if_stack.top());
        TAC.push_back(string($4.else_body) +":");
    }
     else_if_stmt  
     {
                // jump handling
                TAC.push_back(if_stack.top() +":");
                if_stack.pop();

     }
    | SWITCH '(' conditional_expression ')'  block_statement
    ;
else_if_stmt :
    ELSE IF '(' conditional_expression ')' {
        string b = string($4.lexeme);
        string t0 = get_temp();
                string dtype = string($4.type);

        TAC.push_back(t0 + " = " + "~ "+b  + " " +dtype);
        TAC.push_back("if " +  t0  + " GOTO " + "#L"+ to_string(label_counter++));
        sprintf($4.else_body, "#L%d", label_counter - 1);
        

        // recycling labels

        free_temp.push(t0);
        if(const_temps.find(string($4.lexeme)) == const_temps.end() && string($4.lexeme)[0] == '@') free_temp.push(string($4.lexeme));

    }
    block_statement {

        // scope handling
        unordered_map <string, struct variable_info> temp;
        function_table[curr_function_name].symbol_table_for_vars_in_it[scope_counter] = temp;
        scope_history.pop();
        --scope_counter;

        iteration_break_labels.pop();
        iteration_continue_labels.pop();


        // jump handling

        TAC.push_back("GOTO " +  if_stack.top());
        TAC.push_back(string($4.else_body) +":");
    } else_if_stmt
    |
    ELSE block_statement 
    {
        // scope handling
        unordered_map <string, struct variable_info> temp;
        function_table[curr_function_name].symbol_table_for_vars_in_it[scope_counter] = temp;
        scope_history.pop();
        --scope_counter;
    }
    |
    ;

    ;

iteration_statement
    : WHILE '(' conditional_expression {
        sprintf($3.if_body, "#L%d", label_counter++);
        TAC.push_back(string($3.if_body) +":");

        string b = string($3.lexeme);
        string t0 = get_temp();
                string dtype = string($3.type);

        TAC.push_back(t0 + " = " + "~ "+b  + " " +dtype);
        TAC.push_back("if " +  t0  + " GOTO " + "#L"+ to_string(label_counter++));
        sprintf($3.else_body, "#L%d", label_counter-1);
        iteration_break_labels.push({string($3.else_body), curr_function_name}); // for break statement
        iteration_continue_labels.push({string($3.if_body), curr_function_name}); // for continue statement

        // recycling labels

        free_temp.push(t0);
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

     } ')' block_statement {
                TAC.push_back("GOTO " + string($3.if_body));
        TAC.push_back(string($3.else_body) +":");
        unordered_map <string, struct variable_info> temp;
        function_table[curr_function_name].symbol_table_for_vars_in_it[scope_counter] = temp;
                    scope_history.pop();
                    iteration_break_labels.pop();
                    iteration_continue_labels.pop();
            scope_counter--;
     }
    | DO block_statement WHILE '(' conditional_expression ')' ';'


    | FOR '('
    {
        scope_history.push(++scope_counter);
    }
     assignment_expression ';'
    {
        sprintf($4.if_body, "#L%d", label_counter++); // for (; label ;)
        sprintf($4.else_body, "#L%d", label_counter++); // for () label {}
        sprintf($4.afterIf, "#L%d", label_counter++); // for (){} label
        iteration_break_labels.push({string($4.afterIf), curr_function_name}); // for break statement
        TAC.push_back(string($4.if_body) +":");
    }
     conditional_expression {
        string b = string($7.lexeme);
        string t0 = get_temp();
        string dtype = string($7.type);

        TAC.push_back(t0 + " = " + "~ "+b  + " " +dtype);
        TAC.push_back("if " +  t0  + " GOTO " + string($4.afterIf) + " else GOTO " + string($4.else_body));


        sprintf($7.if_body, "#L%d", label_counter++); // for (; ; label ){}
        TAC.push_back(string($7.if_body) +":"); 
        iteration_continue_labels.push({string($7.if_body), curr_function_name}); // for continue statements
        

        // recycling labels

        free_temp.push(t0);
        if(const_temps.find(string($7.lexeme)) == const_temps.end() && string($7.lexeme)[0] == '@') free_temp.push(string($7.lexeme));

     }';' assignment_expression {
            TAC.push_back("GOTO " +  string($4.if_body));
            TAC.push_back(string($4.else_body) +":");

     } ')' '{' statement_list '}' {
            TAC.push_back("GOTO " +  string($7.if_body));
            TAC.push_back(string($4.afterIf) +":");
            unordered_map <string, struct variable_info> temp;
        function_table[curr_function_name].symbol_table_for_vars_in_it[scope_counter] = temp;
            scope_history.pop();
            scope_counter--;
     }

assignment_expression
    :
     
    postfix_expression assignment_operator conditional_expression 
    {
        cur_array_name = string($1.lexeme);
        is_type_same(string($1.type), string($3.type));
        if(string($1.type) == "CHAR" && string($3.type) == "INT"){
        }
        if(string($2.lexeme) == "+="){
        TAC.push_back(cur_array_name + " = " + cur_array_name  + " + "+ string($3.lexeme) + " " + string($1.type));
        }
        else  if(string($2.lexeme) == "-="){
        TAC.push_back(cur_array_name + " = " + cur_array_name  + " - "+ string($3.lexeme) + " " + string($1.type));
        }
        else
        TAC.push_back(cur_array_name + " = " + string($3.lexeme) + " " + string($1.type));
    
        if(const_temps.find(string($3.lexeme)) == const_temps.end() && string($3.lexeme)[0] == '@') free_temp.push(string($3.lexeme));

    }
    ; 



jump_statement
    : GOTO IDENTIFIER ';'
    | CONTINUE {
        // cout <<endl << iteration_continue_labels.size() << endl; 
        if(iteration_continue_labels.empty() || iteration_continue_labels.top().second != curr_function_name){
            semantic_errors.push_back("Continue statement not within a loop");
        }
        else{
            TAC.push_back("GOTO " + iteration_continue_labels.top().first);
        }
    }';'
    | BREAK {
        if(iteration_break_labels.empty() || iteration_break_labels.top().second != curr_function_name){
            semantic_errors.push_back("break statement not within a loop");
        }
        else{
            TAC.push_back("GOTO " + iteration_break_labels.top().first);
        }
    } ';'
    | RETURN ';'
    | RETURN conditional_expression {
        is_type_same(function_table[curr_function_name].return_type,string($2.type));
        TAC.push_back("return "+ string($2.lexeme) + " " + function_table[curr_function_name].return_type);
        has_return_stmt = 1;

        if(const_temps.find(string($2.lexeme)) == const_temps.end() && string($2.lexeme)[0] == '@') free_temp.push(string($2.lexeme));

    }';'
    ;

%%


/***************************************************************************************************************************** 
Function name: main 
Function return type: int 
Function arguments: None 
Function body description: The main function initializes the reserved_words map by iterating over the reserved_words_vec vector and setting the corresponding keys in the map to true. Then, it calls the yyparse() function. After that, it prints any semantic errors that occurred during parsing. If there are any semantic errors, the program exits. Next, it prints the symbol table, including the variables and functions. Finally, it prints the TAC (Three-Address Code) instructions. 
*****************************************************************************************************************************/

int main(){
    for(string  i : reserved_words_vec){
        reserved_words[i] = true;
    }
    yyparse();
    for(auto item : semantic_errors){
        cout << item << endl;
    }
    if(semantic_errors.size()) exit(0);
    /* cout << semantic_errors.size() << endl; */
    cout <<endl <<"Symboltable:";
    cout <<endl <<"Variable:" << endl;
    for(int i = 0; i< global_vars.size(); i++){
        if(global_vars[i].nDims){
            cout << global_vars[i].name << " " << to_string(global_vars[i].nDims * 4) << " " << global_vars[i].is_defined << endl;
        }
        else{
            cout << global_vars[i].name << " " << "4" << " " << global_vars[i].is_defined << endl;
        }
    }
    cout << endl << "Function:" << endl;
    for(int i = 0; i < func_details.size(); i++){
        cout << func_details[i].func_name << " " << to_string(func_details[i].num_params) << " " << func_details[i].is_defined << endl;
    }
    /* for(auto i : function_table[curr_function_name].symbol_table_for_vars_in_it){
        cout <<endl << "Scope: " << i.first;
        for(auto j : function_table[curr_function_name].symbol_table_for_vars_in_it[i.first]){
            cout <<endl << j.first << " " << function_table[curr_function_name].symbol_table_for_vars_in_it[i.first][j.first].data_type;
        }
    } */
    cout <<endl << "VM:";
    for(auto x : TAC) cout<<endl<< x;
    /* cout << TAC[0] << endl; */
}

/***************************************************************************************************************************** 
Function name: yyerror 
Function return type: void 
Function arguments: const char * msg 
Function body description: The yyerror function is a custom error handler for syntax errors. It adds a semantic error message to the semantic_errors vector and prints the error message to stderr. Then, it exits the program with an exit code of 1. 
*****************************************************************************************************************************/
void yyerror(const char * msg){
    semantic_errors.push_back("syntax error in line " + to_string(countn + 1));
    for (auto item : semantic_errors){
        cout << item << endl;
    }
    fprintf(stderr, "%s\n", msg);
    exit(1);
}


/*****************************************************************************************************************************
Function name: is_var_declared 
Function return type: int 
Function arguments: string var 
Function body description: The is_var_declared function checks if a variable is declared in the current function's symbol table. It iterates over the symbol table for each scope in the function and checks if the variable exists. If the variable is found, it returns the scope number plus one. If the variable is not found, it adds a semantic error message to the semantic_errors vector and returns false. 
*****************************************************************************************************************************/
int is_var_declared(string var){
    for(auto i : function_table[curr_function_name].symbol_table_for_vars_in_it){
        if(function_table[curr_function_name].symbol_table_for_vars_in_it[i.first].find(var) != function_table[curr_function_name].symbol_table_for_vars_in_it[i.first].end()){
            return i.first + 1;
        }
    }
    semantic_errors.push_back("Variable not declared in line" + to_string(countn + 1) + "before usage.");
    return false;
}

/***************************************************************************************************************************** 
Function name: is_in_scope 
Function return type: bool 
Function arguments: string var 
Function body description: The is_in_scope function checks if a variable is in scope in the current function. It uses a temporary stack to iterate over the scope history and checks if the variable exists in each scope's symbol table. If the variable is found, it returns true. If the variable is not found, it adds a semantic error message to the semantic_errors vector and returns false. 
*****************************************************************************************************************************/
bool is_in_scope(string var){
    stack<int> temp_stack(scope_history);
    while(!temp_stack.empty()){
        int i = temp_stack.top();
        if(function_table[curr_function_name].symbol_table_for_vars_in_it[i].find(var) != function_table[curr_function_name].symbol_table_for_vars_in_it[i].end()){
            return true;
        }
        temp_stack.pop();
    }

    semantic_errors.push_back("Scope of variable " + var + " not matching in line " + to_string(countn+1));
    return false;
}

/***************************************************************************************************************************** 
Function name: get_scope 
Function return type: int 
Function arguments: string var 
Function body description: The get_scope function returns the scope number in which a variable is declared in the current function's symbol table. It iterates over the symbol table for each scope in the function and checks if the variable exists. If the variable is found, it returns the scope number. 
*****************************************************************************************************************************/
int get_scope(string var){
    for(auto i : function_table[curr_function_name].symbol_table_for_vars_in_it){
        if(function_table[curr_function_name].symbol_table_for_vars_in_it[i.first].find(var) != function_table[curr_function_name].symbol_table_for_vars_in_it[i.first].end()){
            return i.first;
        }
    }
}

/***************************************************************************************************************************** 
Function name: is_multiple_declared 
Function return type: bool 
Function arguments: string var 
Function body description: The is_multiple_declared function checks if a variable is declared multiple times in the current function's symbol table. It iterates over the symbol table for each scope in the function and checks if the variable exists. If the variable is found, it adds a semantic error message to the semantic_errors vector and returns true. If the variable is not found, it returns false. 
*****************************************************************************************************************************/
bool is_multiple_declared(string var){
   for(auto i : function_table[curr_function_name].symbol_table_for_vars_in_it){
        if(function_table[curr_function_name].symbol_table_for_vars_in_it[i.first].find(var) != function_table[curr_function_name].symbol_table_for_vars_in_it[i.first].end()){
            semantic_errors.push_back("redeclaration of '" + var + "' in line " + to_string(countn + 1));
            return true;
        }
    }
    return false;
}

/*****************************************************************************************************************************
Function name: get_temp 
Function return type: string 
Function arguments: None 
Function body description: The get_temp function returns a temporary variable name. If the free_temp queue is empty, it generates a new temporary variable name using the variable_count. If the free_temp queue is not empty, it retrieves a temporary variable name from the queue and returns it. 
*****************************************************************************************************************************/
string get_temp(){
    if(free_temp.empty()){
        return "@t" + to_string(variable_count++); 
    }
    string temp = free_temp.front();
    free_temp.pop();
    return temp;
}


/***************************************************************************************************************************** 
Function name: is_reserved_word 
Function return type: bool 
Function arguments: string var 
Function body description: The is_reserved_word function checks if a given variable is a reserved word. It checks if the variable exists as a key in the reserved_words map. If the variable is found, it returns true. If the variable is not found, it returns false. 
*****************************************************************************************************************************/
bool is_reserved_word(string var){
    return reserved_words.find(var) == reserved_words.end() ?  false :  true;
}


/***************************************************************************************************************************** 
Function name: is_type_same 
Function return type: bool 
Function arguments: string var1, string var2 
Function body description: The is_type_same function checks if two variable types are the same. It compares the two variable types and checks for specific type mismatches. If a type mismatch is found, it adds a semantic error message to the semantic_errors vector and returns false. If the types are the same, it returns true. 
*****************************************************************************************************************************/
bool is_type_same(string var1, string var2){
    if((var1 == "FLOAT" && var2 == "CHAR") || (var2 == "FLOAT" && var1 == "CHAR")){
        semantic_errors.push_back("Type mismatch in line " + to_string(countn + 1));
        return false;
    }
    return true;
}

/*****************************************************************************************************************************
Function name: type_check_arg 
Function return type: bool 
Function arguments: string var1, string var2 
Function body description: The type_check_arg function is currently empty and does not have any implementation. It always returns false. 
*****************************************************************************************************************************/
bool type_check_arg(string var1, string var2){
    return false;
}
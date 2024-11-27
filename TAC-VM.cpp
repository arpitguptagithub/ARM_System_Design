/*


*/
/*****************************************************************************************************************************
Function name: 
Function retur type:
Function arguments:
Function body description:
*****************************************************************************************************************************/



#include <bits/stdc++.h>
#include <fstream>  // Include fstream for file handling
using namespace std;

vector<vector<string>> inptac;

vector<vector<string>> gtac; // to store tac code for global variables
vector<vector<string>> tac; // to store tac code for other variables

vector<string> vm;
map<string, pair<string, string>> constant; // to track constant values with their type 
map<string, pair<string, string>> local; // to track local variables with their type and index
map<string, pair<string, string>> global; // to global variables with their type and index

int local_idx = 0; // to track local variable index
map<string, pair<string, string>> argument; // Maps function arguments to their type and index
int arg_idx = 0; // to track argument index
map<string, pair<string, string>> temp; // to track temporary variables with their type and index
int temp_idx = 0; // to track temporary variable index
map<string, string> op_map; // to map operators to their vm code
map<string, int> strings; // to store strings with their index
int str_idx = 0;

map<string, pair<int, int>> fun_var_count; // no of local variables in a function
string curr_fun_name, curr_ret_type;

bool is_global = false; // a check to see if we are in global scope or not


/*****************************************************************************************************************************
Function name: initialize
Function return type: void
Function arguments: void
Function body description: This function initializes the operator map with the corresponding vm code.
*****************************************************************************************************************************/

void initialize(){
    // Adding binary operations
    op_map["+"] = "addi";
    op_map["-"] = "subi";
    op_map["*"] = "muli";
    op_map["=="] = "eq";
    op_map[">"] = "gt";
    op_map["<"] = "ls";
    op_map["&"] = "and";
    op_map["|"] = "or";
    op_map["<="] = "le";
    op_map[">="] = "ge";
    op_map["!="] = "neq";
}

/*****************************************************************************************************************************
Function name:  tokenize
Function return type: vector<string>
Function arguments: string in
Function body description: This function tokenizes the input string and returns a vector of tokens.
*****************************************************************************************************************************/


vector<string> tokenize(string in){
    vector<string> res;
    string temp_t = "";
    for(int i = 0; i < in.size(); i++){
        if(in[i] == ' '){
            res.push_back(temp_t);
            temp_t = "";
            while(i < in.size() && in[i] == ' '){
                i++;
            }
            i--;
        }
        else{
            if(in[i] == '"'){
                string str = "";
                while(i < in.size() && in[i] != '\n')
                    str += in[i++];

                int l = 0;
                while(in[i] != '"'){
                    i--;
                    l++;
                }

                temp_t = str.substr(0, str.length() - l + 1);
            }
            else{
                temp_t += in[i];
            }
        }
    }
    if(temp_t.size())
        res.push_back(temp_t);
    return res;
}


/*****************************************************************************************************************************
Function name: print
Function retur type: void
Function arguments: void
Function body description: This function prints the tac code.
*****************************************************************************************************************************/

void print(){
    for(auto i: tac){
        for(auto j: i){
            cout << j << " ";
        }
        cout << endl;
    }
}

/*****************************************************************************************************************************
Function name: isNumber
Function retur type: bool
Function arguments: string& str
Function body description: This function checks if the input string is a number or not.
*****************************************************************************************************************************/


bool isNumber(string& str){
    for (char const &c : str){
        if (isdigit(c) == 0 && c != '.')
            return false;
    }
    return true;
}

/*****************************************************************************************************************************
Function name: isOperator
Function return type: bool 
Function arguments: string op
Function body description: This function checks if the input string is an operator or not.
*****************************************************************************************************************************/


bool isOperator(string op){
    if(op_map.find(op) != op_map.end())
        return true;
    return false;
}


/*****************************************************************************************************************************
Function name: get_type
Function return type: pair<pair<string, string>, string>
Function arguments: string var, string type
Function body description: This function returns the type of the input variable.
*****************************************************************************************************************************/


pair<pair<string, string>, string> get_type(string var, string type){
    pair<pair<string, string>, string> temp_var;
    if(var[0] == '@'){ // for temporary variables
        if(temp.find(var) == temp.end()){
            temp[var].first = to_string(temp_idx);
            temp[var].second = type;
            temp_idx++;
        }
        temp_var.first.first = temp[var].first;
        temp_var.first.second = temp[var].second;
        temp_var.second = "temp";
    }
    else if(isNumber(var) || var[0] == '\''){ // for constants
        if(constant.find(var) == constant.end()){
            constant[var].first = var;
            constant[var].second = type;
        }
        temp_var.first.first = constant[var].first;
        temp_var.first.second = constant[var].second;
        temp_var.second = "constant";
    }
    else{
        // for arrays
        bool is_array = false;
        if(var.find('[') != string::npos){
            is_array = true;
        }
        // for addresses
        bool is_address = false;
        if(var.find('$') != string::npos){
             is_address = true;
           }

        // for pointers
        bool is_pointer = false;
        if(var.find('*') != string::npos){
            is_pointer = true;
        }
        if(argument.find(var) != argument.end()){ // for arguments
            if(is_array){
                string index = var.substr(var.find('[') + 1, var.find(']') - var.find('[') - 1);
                temp_var.first.first = to_string(stoi(argument[var].first) + stoi(index));
            }
            else{
                temp_var.first.first = argument[var].first;
            }
            temp_var.first.second = argument[var].second;
            temp_var.second = "argument";
        }
        else{   
            if(!is_global){ // for local variables
                if(is_array){
                string exp = var.substr(var.find('[') + 1, var.find(']') - var.find('[') - 1);
                var = var.substr(0, var.find('['));
                if(exp[0] >= '0' && exp[0] <= '9' ){
                temp_var.first.first = to_string(stoi(local[var].first) + stoi(exp));
                temp_var.first.second = local[var].second;
                temp_var.second = "local";
                }
                else{
                    pair<pair<string, string>, string> type_a = get_type(exp, "INT");
                    vm.push_back("push static lcl");
                    vm.push_back("push " + type_a.second + " " + type_a.first.first);
                    vm.push_back("push constant " +local[var].first);
                    vm.push_back("addi");
                    vm.push_back("push constant 4");
                    vm.push_back("muli");
                    vm.push_back("addi");


                    // temp_var.first.first = to_string(local_idx);
                    temp_var.first.second = "var_index";
                    // temp_var.second = "local";
                }
            }
             else if(is_address){
                 string exp = var.substr(var.find('$') + 1, var.size() - var.find('$') - 1);
                 pair<pair<string, string>, string> type_a = get_type(exp, "INT");
                 vm.push_back("push static lcl");
                 vm.push_back("push " + type_a.second + " " + type_a.first.first);
                 vm.push_back("addi");
                 temp_var.first.second = "address"; // have to write something here
                                                    // temp_var.second = "local";
             }
             else if(is_pointer){
                 string exp = var.substr(var.find('*') + 1, var.size() - var.find('*') - 1);
                 pair<pair<string, string>, string> type_a = get_type(exp, "INT");
                 vm.push_back("push " + type_a.second + " " + type_a.first.first);
                 vm.push_back("pop local "+ to_string(temp_idx));
                 vm.push_back("rmem temp "+ to_string(temp_idx));
                 temp_idx++;
                 vm.push_back("push temp "+ to_string(temp_idx));   
                 temp_var.first.first = to_string(temp_idx);
                 temp_var.first.second = "INT";
                 temp_var.second = "temp";
             }
            else{
            if(local.find(var) == local.end()){
                local[var].first = to_string(local_idx);
                local[var].second = type;
                local_idx++;
            }
                temp_var.first.first = local[var].first;
            temp_var.first.second = local[var].second;
            temp_var.second = "local";
            }
            }

            // for globals
            else{
                if(is_array){
                string exp = var.substr(var.find('[') + 1, var.find(']') - var.find('[') - 1);
                var = var.substr(0, var.find('['));
                if(exp[0] >= '0' && exp[0] <= '9' ){
                temp_var.first.first = to_string(stoi(local[var].first) + stoi(exp));
                temp_var.first.second = local[var].second;
                temp_var.second = "local";
                }
                else{
                    pair<pair<string, string>, string> type_a = get_type(exp, "INT");
                    vm.push_back("push static lcl");
                    vm.push_back("push " + type_a.second + " " + type_a.first.first);
                    vm.push_back("push constant " +local[var].first);
                    vm.push_back("addi");
                    vm.push_back("push constant 4");
                    vm.push_back("muli");
                    vm.push_back("addi");
                    temp_var.first.second = "var_index";
                }
            }
             else if(is_address){
                 string exp = var.substr(var.find('&') + 1, var.size() - var.find('&') - 1);
                 pair<pair<string, string>, string> type_a = get_type(exp, "INT");
                 vm.push_back("push static lcl");
                 vm.push_back("push " + type_a.second + " " + type_a.first.first);
                 vm.push_back("addi");
                 temp_var.first.second = "address"; // have to write something here
                                                    // temp_var.second = "local";
             }
             else if(is_pointer){
                 string exp = var.substr(var.find('*') + 1, var.size() - var.find('*') - 1);
                 pair<pair<string, string>, string> type_a = get_type(exp, "INT");
                 vm.push_back("push " + type_a.second + " " + type_a.first.first);
                 vm.push_back("pop local "+ to_string(temp_idx));
                 vm.push_back("rmem temp "+ to_string(temp_idx));
                 temp_idx++;
                 vm.push_back("push temp "+ to_string(temp_idx));   
                 temp_var.first.first = to_string(temp_idx);
                 temp_var.first.second = "INT";
                 temp_var.second = "temp";
             }
            else{
                vm.push_back("push static " + var);
                vm.push_back("pop temp " + to_string(temp_idx));
                temp_idx++;
                temp_var.first.first = to_string(temp_idx);
                temp_var.first.second = global[var].second;
                temp_var.second = "temp";
            }
            }
          
        }
    }
    return temp_var;
}

/*****************************************************************************************************************************
Function name: global_conversion
Function return type:  void
Function arguments: void
Function body description: This function converts the tac code for global variables to vm code.
*****************************************************************************************************************************/

void global_conversion()
{
    for (int i = 0; i < gtac.size(); i++)
    {
        if (gtac[i].size() == 1 && gtac[i][0][gtac[i][0].size() - 1] == ':')
        {
            string ins = "";
            if (gtac[i][0][0] == '#')
            {
                ins += "label ";
                ins += gtac[i][0];
                ins.pop_back();
                vm.push_back(ins);
            }
        }

        if (gtac[i].size() > 1)
        {
            if (gtac[i].size() == 6 && gtac[i][1] == "=" && isOperator(gtac[i][3]))
            {
                pair<pair<string, string>, string> type_b = get_type(gtac[i][2], gtac[i][5]);
                if (type_b.first.second == "var_index")
                {
                    vm.push_back("pop temp " + to_string(temp_idx++));
                    vm.push_back("rmem temp " + to_string(temp_idx - 1));
                }
                else
                {
                    vm.push_back("rmem " + type_b.second + " " + type_b.first.first);
                }
                pair<pair<string, string>, string> type_c = get_type(gtac[i][4], gtac[i][5]);
                if (type_c.first.second == "var_index")
                {
                    vm.push_back("pop temp " + to_string(temp_idx++));
                    vm.push_back("rmem temp " + to_string(temp_idx - 1));
                }
                else
                {
                    vm.push_back("rmem " + type_c.second + " " + type_c.first.first);
                }
                vm.push_back(op_map[gtac[i][3]]);
                pair<pair<string, string>, string> type_a = get_type(gtac[i][0], gtac[i][5]);
                if (type_a.first.second == "var_index")
                {
                    vm.push_back("pop temp " + to_string(temp_idx++));
                    vm.push_back("wmem temp " + to_string(temp_idx - 1));
                }
                else
                {
                    vm.push_back("wmem " + type_a.second + " " + type_a.first.first);
                }
            }
            else if (gtac[i].size() == 2)
            {
                if (gtac[i][0] == "GOTO")
                {
                    vm.push_back("goto " + gtac[i][1]);
                }
                else if (gtac[i][0][gtac[i][0].size() - 1] == ':')
                {
                    string ins = "function " + gtac[i][0];
                    ins.pop_back();
                    ins += " " + gtac[i][1];
                    vm.push_back(ins);
                    curr_fun_name = gtac[i][0].substr(0, gtac[i][0].size() - 1);
                    curr_ret_type = gtac[i][1];
                }
                else if (gtac[i][0] == "return")
                {
                    pair<pair<string, string>, string> type_a = get_type(gtac[i][1], "INT");
                    vm.push_back("push " + type_a.second + " " + type_a.first.first);
                    vm.push_back("return");
                }
            }
            else if (gtac[i].size() == 3)
            {
                if (gtac[i][0] == "-")
                {
                    if (gtac[i][1] == "STR")
                        continue;
                    if (gtac[i].size() == 3)
                    {
                        if (gtac[i][2][gtac[i][2].size() - 1] == ']')
                        {   // for array declarations
                            // local[gtac[i][2]].first = to_string(local_idx++);
                            int j;
                            for (j = 0; gtac[i][2][j] != '['; j++)
                            {
                            }

                            local[gtac[i][2].substr(0, j)].first = to_string(local_idx);
                            local[gtac[i][2].substr(0, j)].second = gtac[i][1];
                            string len = gtac[i][2].substr(j + 1, gtac[i][2].size() - j - 2);
                            local_idx += stoi(len);
                        }
                        else
                        {
                            local[gtac[i][2]].first = to_string(local_idx++);
                            local[gtac[i][2]].second = gtac[i][1];
                        }
                    }
                }
                else if (gtac[i][0] == "return")
                {
                    pair<pair<string, string>, string> type_a = get_type(gtac[i][1], gtac[i][2]);
                    vm.push_back("push " + type_a.second + " " + type_a.first.first);
                    vm.push_back("return");
                }
            }
            else if (gtac[i].size() == 4)
            { // for assignment expressions

                if (gtac[i][1] == "=")
                {
                    // check for array with variable as index
                    pair<pair<string, string>, string> type_b = get_type(gtac[i][2], gtac[i][3]);
                    if (type_b.first.second == "var_index")
                    {
                        vm.push_back("pop temp " + to_string(temp_idx++));
                        vm.push_back("rmem temp " + to_string(temp_idx - 1));
                    }
                    else if (type_b.first.second == "address")
                    {
                    }
                    else
                    {
                        vm.push_back("rmem " + type_b.second + " " + type_b.first.first);
                    }
                    pair<pair<string, string>, string> type_a = get_type(gtac[i][0], gtac[i][3]);
                    if (type_a.first.second == "var_index")
                    {
                        vm.push_back("pop temp " + to_string(temp_idx++));
                        vm.push_back("wmem temp " + to_string(temp_idx - 1));
                    }
                    else
                    {
                        vm.push_back("wmem " + type_a.second + " " + type_a.first.first);
                    }
                    // vm.push_back("pop " + type_a.second + " " + type_a.first.first );
                }
                else if (gtac[i][0] == "if")
                {
                    pair<pair<string, string>, string> type_a = get_type(gtac[i][1], gtac[i][3]);
                    // pair<pair<string, string>, string> type_b = get_type(gtac[i][3], gtac[i][3]);
                    vm.push_back("push " + type_a.second + " " + type_a.first.first);
                    vm.push_back("if-goto " + gtac[i][gtac[i].size() - 1]);
                }
            }
            else if (gtac[i].size() == 5)
            { // for array operations

                if (gtac[i][1] == "=" && gtac[i][2] == "~")
                {
                    pair<pair<string, string>, string> type_a = get_type(gtac[i][0], gtac[i][4]);
                    pair<pair<string, string>, string> type_b = get_type(gtac[i][3], gtac[i][4]);
                    vm.push_back("push " + type_b.second + " " + type_b.first.first);
                    vm.push_back("not");
                    vm.push_back("pop " + type_a.second + " " + type_a.first.first);
                }
            }
            else if (gtac[i].size() == 7)
            { // for if goto else goto
                if (gtac[i][0] == "if")
                {
                    pair<pair<string, string>, string> type_a = get_type(gtac[i][1], gtac[i][6]);
                    vm.push_back("push " + type_a.second + " " + type_a.first.first);
                    vm.push_back("if-goto " + gtac[i][3]);
                    vm.push_back("goto " + gtac[i][6]);
                }
            }
        }

        // Handle function calls
    }
}

/*****************************************************************************************************************************
Function name: conversion
Function return type:  void
Function arguments: void
Function body description: This function converts the tac code to vm code.
*****************************************************************************************************************************/

void conversion()
{
    for(int i = 0; i < tac.size(); i++) { 
        if(tac[i].size() == 1 && tac[i][0][tac[i][0].size() - 1] == ':') { 
            string ins = ""; 
            if(tac[i][0][0] == '#') { 
                ins += "label "; 
                ins += tac[i][0]; 
                ins.pop_back(); 
                vm.push_back(ins); 
            } else if(tac[i][0] == "end:") { 
                fun_var_count[curr_fun_name] = {local_idx, temp_idx}; 
                if(curr_ret_type == "void") { 
                    vm.push_back("push constant 0 INT"); 
                    vm.push_back("return"); 
                } 
                local_idx = 0; 
                temp_idx = 0; 
                local.clear(); 
                argument.clear(); 
                temp.clear(); 
            } 
        }

        if(tac[i].size() > 1) { 
            if(tac[i].size() == 6 && tac[i][1] == "=" && isOperator(tac[i][3])) { 
                pair<pair<string, string>, string> type_b = get_type(tac[i][2], tac[i][5]); 
                if(type_b.first.second == "var_index"){
                        vm.push_back("pop temp " + to_string(temp_idx++));
                        vm.push_back("rmem temp "+ to_string(temp_idx - 1));
                    }
                    else{
                        vm.push_back("push " + type_b.second + " " + type_b.first.first);
                    }
                pair<pair<string, string>, string> type_c = get_type(tac[i][4], tac[i][5]); 
               if(type_c.first.second == "var_index"){
                        vm.push_back("pop temp " + to_string(temp_idx++));
                        vm.push_back("rmem temp "+ to_string(temp_idx - 1));
                    }
                    else{
                        vm.push_back("push " + type_c.second + " " + type_c.first.first);
                    }
                vm.push_back(op_map[tac[i][3]]);
                pair<pair<string, string>, string> type_a = get_type(tac[i][0], tac[i][5]); 
                if(type_a.first.second == "var_index"){
                    vm.push_back("pop temp " + to_string(temp_idx++));
                    vm.push_back("wmem temp "+ to_string(temp_idx - 1));
                    }
                    else{
                        vm.push_back("pop " + type_a.second + " " + type_a.first.first);
                    }
            } else if(tac[i].size() == 2) { 
                if(tac[i][0] == "GOTO") { 
                    vm.push_back("goto " + tac[i][1]); 
                } else if(tac[i][0][tac[i][0].size() - 1] == ':') { 
                    string ins = "function " + tac[i][0]; 
                    ins.pop_back(); 
                    ins += " " + tac[i][1]; 
                    vm.push_back(ins); 
                    curr_fun_name = tac[i][0].substr(0, tac[i][0].size() - 1); 
                    curr_ret_type = tac[i][1]; 
                }
                else if(tac[i][0] == "return") { 
                    pair<pair<string, string>, string> type_a = get_type(tac[i][1], "INT"); 
                    vm.push_back("push " + type_a.second + " " + type_a.first.first); 
                    vm.push_back("return"); 
                } 
            } else if(tac[i].size() == 3) { 
                if(tac[i][0] == "-") { 
                    if(tac[i][1] == "STR") continue; 
                    if(tac[i].size() == 3) { 
                        if(tac[i][2][tac[i][2].size() - 1]== ']'){ // for array declarations
                        // local[tac[i][2]].first = to_string(local_idx++);
                            int j;
                            for( j = 0; tac[i][2][j] != '['; j++){
                            
                            } 
                            
                            local[tac[i][2].substr(0, j)].first = to_string(local_idx);
                            local[tac[i][2].substr(0, j)].second = tac[i][1];
                            string len = tac[i][2].substr(j + 1, tac[i][2].size() - j - 2);
                            local_idx += stoi(len);
                        }
                        else{
                        local[tac[i][2]].first = to_string(local_idx++); 
                        local[tac[i][2]].second = tac[i][1]; 
                        }
                    } 
                } else if(tac[i][0] == "param") { 
                    pair<pair<string, string>, string> type_a = get_type(tac[i][1], tac[i][2]); 
                    vm.push_back("push " + type_a.second + " " + type_a.first.first); 

                } else if(tac[i][0] == "SCAN") { 
                    pair<pair<string, string>, string> type_a = get_type(tac[i][1], tac[i][2]); 
                    vm.push_back("scan " + type_a.second + " " + type_a.first.first + " " + tac[i][2]); 
                } else if(tac[i][0] == "PRINT") { 
                    if(tac[i][2] == "STR") { 
                        if(tac[i][1][0] == '"') { 
                            vm.push_back("push data " + to_string(str_idx) + " " + tac[i][1] + " STR"); 
                            strings[tac[i][1]] = str_idx++; 
                        } 
                        vm.push_back("push data " + to_string(strings[tac[i][1]]) + " STR"); 
                    } else { 
                        pair<pair<string, string>, string> type_a = get_type(tac[i][1], tac[i][2]); 
                        vm.push_back("push " + type_a.second + " " + type_a.first.first + " " + type_a.first.second); 
                    } 
                    vm.push_back("print " + tac[i][2]); 
                }
                else if(tac[i][0] == "return") { 
                    pair<pair<string, string>, string> type_a = get_type(tac[i][1], tac[i][2]); 
                    vm.push_back("push " + type_a.second + " " + type_a.first.first); 
                    vm.push_back("return"); 
                }  
            } 
            else if(tac[i].size() == 4){ // for assignment expressions
                
                if(tac[i][1] == "="){
                    // check for array with variable as index
                    pair<pair<string, string>, string> type_b = get_type(tac[i][2], tac[i][3]);
                    if(type_b.first.second == "var_index"){
                        vm.push_back("pop temp " + to_string(temp_idx++));
                        vm.push_back("rmem temp "+ to_string(temp_idx - 1));
                    }
                    else if(type_b.first.second=="address"){}
                    else{
                        vm.push_back("push " + type_b.second + " " + type_b.first.first);
                    }
                    pair<pair<string, string>, string> type_a = get_type(tac[i][0], tac[i][3]);
                    if(type_a.first.second == "var_index"){
                    vm.push_back("pop temp " + to_string(temp_idx++));
                    vm.push_back("wmem temp "+ to_string(temp_idx - 1));
                    }
                    else{
                        vm.push_back("pop " + type_a.second + " " + type_a.first.first);
                    }
                }
                else if(tac[i][0] == "if"){
                    pair<pair<string, string>, string> type_a = get_type(tac[i][1], tac[i][3]);
                    vm.push_back("push " + type_a.second + " " + type_a.first.first);
                    vm.push_back("if-goto " + tac[i][tac[i].size() - 1]);
                }
                else if(tac[i][0] == "-"){ // for function arguments, example: - arg INT n
                    if(tac[i][1] == "arg"){
                        argument[tac[i][3]].first = to_string(arg_idx++);
                        argument[tac[i][3]].second = tac[i][2];
                    }
                }
            }
            else if(tac[i].size() == 5){ // for array operations
                
                if(tac[i][1] == "=" && tac[i][2] == "~"){
                    pair<pair<string, string>, string> type_a = get_type(tac[i][0], tac[i][4]);
                    pair<pair<string, string>, string> type_b = get_type(tac[i][3], tac[i][4]);
                    vm.push_back("push " + type_b.second + " " + type_b.first.first);
                    vm.push_back("not");
                    vm.push_back("pop " + type_a.second + " " + type_a.first.first);
                }
            }
            else if(tac[i].size() == 7){ // for if goto else goto
                if(tac[i][0] == "if"){
                    pair<pair<string, string>, string> type_a = get_type(tac[i][1], tac[i][6]);
                    vm.push_back("push " + type_a.second + " " + type_a.first.first);
                    vm.push_back("if-goto " + tac[i][3]);
                    vm.push_back("goto " + tac[i][6]);
                    
                }

            }
        }

        // Handle function calls
        if (tac[i].size() >= 4 && tac[i][2] == "@call") {
            if (tac[i].size() == 5 || (tac[i].size() == 6 && tac[i][3] == "INT")) {
                string func_name = tac[i][3] == "INT" ? tac[i][4] : tac[i][3];
                int arg_count = stoi(tac[i][tac[i].size() - 1]);

                // Push the call instruction
                vm.push_back("call " + func_name + " " + to_string(arg_count));

                // Handle the assignment of the return value
                pair<pair<string, string>, string> type_a = get_type(tac[i][0], tac[i][tac[i].size() - 2]);
                // vm.push_back("pop " + type_a.second + " " + type_a.first.first + " " + type_a.first.second);
                vm.push_back("pop " + type_a.second + " " + type_a.first.first);
            } else {
                cerr << "Error: Malformed function call syntax in TAC at line " << i << endl;
            }
        }
    }
}

/*****************************************************************************************************************************
Function name: print_vm
Function return type:  void
Function arguments: void
Function body description: This function prints the vm code.
*****************************************************************************************************************************/


void print_vm(){
    for(int i = 0; i < vm.size(); i++){
        if(vm[i].substr(0, 8) == "function"){
            vector<string> temp;
            temp = tokenize(vm[i]);
            // cout << temp[0] + " " + temp[1] + " " + to_string(fun_var_count[temp[1]].first) + " " + to_string(fun_var_count[temp[1]].second) << endl;
            cout << temp[0] + " " + temp[1] + " " + to_string(fun_var_count[temp[1]].first) << endl;
        }
        else{
            cout << vm[i] << endl;
        }
    }
}


vector<string> final_global_vm;
vector<string> final_vm;


/*****************************************************************************************************************************
Function name: filterTACCode
Function return type:  void
Function arguments:  const vector<vector<string>>& originalTAC
Function body description: This function filters the TAC code to process only specific parts.
*****************************************************************************************************************************/

void filterTACCode(const vector<vector<string>>& originalTAC) {
    bool inGlobalInit = false; // Flag to track if we are inside the global initialization section
    bool inEndInit = false; // Flag to track if we are inside the end initialization section

    for (const auto& line : originalTAC) {
        if (inGlobalInit) {
            gtac.push_back(line); // Add lines from global initialization to gtac vector
        }
        if(inEndInit){
            tac.push_back(line); // Add lines from end initialization onwards to tac vector
        }
        
        // Check for start of global initialization
        if (!line.empty() && line[0] == "label" && line.size() > 1 && line[1] == "glob_init") {
            inGlobalInit = true; // Set inGlobalInit flag to true
        }

        // Check for end of global initialization
        if (!line.empty() && line[0] == "return_init") {
            inGlobalInit = false; // Set inGlobalInit flag to false
        }

        // Check for end of initialization
        if (!line.empty() && line[0] == "end_init") {
            global_conversion(); // Convert the global initialization code to vm code
            for(auto i : vm){
                final_global_vm.push_back(i); // Add converted vm code to final_global_vm vector
            }
            local_idx = 0; // Reset local index
            is_global = false; // Set is_global flag to false
            vector<string> tempo; // Create an empty vector
            vm = tempo; // Clear the vm vector
            inEndInit = true; // Set inEndInit flag to true
            continue; // Skip to the next iteration of the loop
        }

        // Include lines from global init, end_init onwards, and function definitions
       
    }

}



/*****************************************************************************************************************************
Function name: main
Function return type:  int
Function arguments: int argc, char* argv[]
Function body description: This is the main function that reads the input TAC code, filters it, converts it to VM code, and writes the VM code to the output file.
*****************************************************************************************************************************/

int main(int argc, char* argv[]) {
    // Check if output filename is provided
    if (argc < 3) {
        cerr << "Usage: " << argv[0] << " <input_tac_file> <output_vm_file>" << endl;
        return 1;
    }

    string inputFileName = argv[1];
    string outputFileName = argv[2];

    initialize();
    ifstream file(inputFileName);  // Open the input file

    if (!file.is_open()) {  // Check if file is open
        cerr << "Error opening input file: " << inputFileName << endl;
        return 1;
    }

    string line;
    bool local_in_global = false;
    bool local_in_end = false;
    while (getline(file, line)) {  // Read lines from file
        vector<string> temp = tokenize(line);
        if(!local_in_global){
            final_vm.push_back(line);
        }
        if (!temp.empty() && temp[0] == "label" && temp.size() > 1 && temp[1] == "glob_init") {
            local_in_global = true;
            
        }
        inptac.push_back(temp);
    }
    file.close();  // Close the file after reading

    // Filter the TAC code to process only specific parts
    filterTACCode(inptac);

    // Convert the TAC code to VM code for other than global initialization
    conversion();

    // Stitching the VM code together
    for(auto i : final_global_vm){
        final_vm.push_back(i);
    }
    final_vm.push_back("return_init");
    final_vm.push_back("label end_init");
    for(auto i : vm){
        final_vm.push_back(i);
    }
    
    // Write the VM code to the specified output file
    ofstream outfile(outputFileName);
    if (!outfile.is_open()) {
        cerr << "Error opening output file: " << outputFileName << endl;
        return 1;
    }

    for (const auto& vmLine : final_vm) {
        if(vmLine.substr(0, 8) == "function"){
            vector<string> temp;
            temp = tokenize(vmLine);
            outfile << temp[0] + " " + temp[1] + " " + to_string(fun_var_count[temp[1]].first) << endl;
        }
        else{
            outfile << vmLine << endl;
        }
    }
    outfile.close();

    // Optional: print VM code to console as well
    // print_vm();
    return 0;
}
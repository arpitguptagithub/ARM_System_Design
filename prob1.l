%{
// Standard header files for input/output and to include the parser file.
#include <stdio.h>
#include "y.tab.h"

// Counter variable used to track some metrics, such as the number of tokens encountered (if needed).
int countn = 0;

%}

// Definition of regular expressions for different token types.

// D defines any digit from 0-9.
D			[0-9]

// 'digits' token is one or more digits.
digits		{D}+

// 'Letter' defines any alphabetic character or underscore.
Letter			[a-zA-Z_]

// L represents an alphabetic character or underscore, same as Letter.
L			[a-zA-Z_]

// H represents a hexadecimal digit (0-9, a-f, A-F).
H			[a-fA-F0-9]

// E defines a scientific notation for floating-point numbers.
E			[Ee][+-]?{D}+

// FS represents a floating-point suffix such as f, F, l, or L.
FS			(f|F|l|L)

// IS represents integer suffixes like u, U, l, L.
IS			(u|U|l|L)*

// integer defines an integer token which could be a regular number or one with scientific notation.
integer			{digits}|[+-]?({digits}(E|e)[+-]?{digits}) 

// drown represents a floating-point number token with optional scientific notation.
drown			[-]?({digits}\.{digits})((E|e)[+-]?{digits})?

// char defines a single character enclosed in single quotes.
char			'[a-zA-Z]?'

// string defines a string of characters enclosed in double quotes.
string			(\"([^"\\\n]|(\\['"\?\\abfnrtv]))*\")+ 

// bool represents boolean constants: true or false.
bool			true|false

// identifier defines a variable name starting with a letter or underscore, followed by alphanumeric characters or underscores.
identifier		{Letter}({Letter}|{D})*

%%

// Token rules section: Each rule returns a corresponding token type to the parser.

// Keyword token rules: Each keyword is mapped to a specific token.
// strcpy is used to store the matched keyword lexeme.
"auto"			{ strcpy(yylval.node.lexeme, yytext); return(AUTO); }
"break"			{ strcpy(yylval.node.lexeme, yytext); return(BREAK); }
"case"			{ strcpy(yylval.node.lexeme, yytext); return(CASE); }
"char"			{ strcpy(yylval.node.lexeme, yytext); return(CHAR); }
"class"			{ strcpy(yylval.node.lexeme, yytext); return(CLASS); }
"const"			{ strcpy(yylval.node.lexeme, yytext); return(CONST); }
"continue"		{ strcpy(yylval.node.lexeme, yytext); return(CONTINUE); }
"default"		{ strcpy(yylval.node.lexeme, yytext); return(DEFAULT); }
"delete"		{ strcpy(yylval.node.lexeme, yytext); return(DELETE); }
"do"			{ strcpy(yylval.node.lexeme, yytext); return(DO); }
"double"		{ strcpy(yylval.node.lexeme, yytext); return(DOUBLE); }
"ELSE"			{ strcpy(yylval.node.lexeme, yytext); return(ELSE); }
"enum"			{ strcpy(yylval.node.lexeme, yytext); return(ENUM); }
"extern"		{ strcpy(yylval.node.lexeme, yytext); return(EXTERN); }
"float"			{ strcpy(yylval.node.lexeme, yytext); return(FLOAT); }
"FOR"			{ strcpy(yylval.node.lexeme, yytext); return(FOR); }
"friend"		{ strcpy(yylval.node.lexeme, yytext); return(FRIEND); }
"function"      { strcpy(yylval.node.lexeme, yytext); return(FUNCTION); }
"goto"			{ strcpy(yylval.node.lexeme, yytext); return(GOTO); }
"IF"			{ strcpy(yylval.node.lexeme, yytext); return(IF); }
"int"			{ strcpy(yylval.node.lexeme, yytext); return(INT); }
"long"			{ strcpy(yylval.node.lexeme, yytext); return(LONG); }
"main"			{ strcpy(yylval.node.lexeme, yytext); return(MAIN); }
"method"        { strcpy(yylval.node.lexeme, yytext); return(METHOD); }
"namespace"		{ strcpy(yylval.node.lexeme, yytext); return(NAMESPACE); }
"new"			{ strcpy(yylval.node.lexeme, yytext); return(NEW); }
"operator"		{ strcpy(yylval.node.lexeme, yytext); return(OPERATOR); }
"PRINT" 		{ strcpy(yylval.node.lexeme, yytext); return(PRINT); }
"private"		{ strcpy(yylval.node.lexeme, yytext); return(PRIVATE); }
"protected"		{ strcpy(yylval.node.lexeme, yytext); return(PROTECTED); }
"public"		{ strcpy(yylval.node.lexeme, yytext); return(PUBLIC); }
"register"		{ strcpy(yylval.node.lexeme, yytext); return(REGISTER); }
"RETURN"		{ strcpy(yylval.node.lexeme, yytext); return(RETURN); }
"SCAN"			{ strcpy(yylval.node.lexeme, yytext); return(SCAN); }
"short"			{ strcpy(yylval.node.lexeme, yytext); return(SHORT); }
"signed"		{ strcpy(yylval.node.lexeme, yytext); return(SIGNED); }
"sizeof"		{ strcpy(yylval.node.lexeme, yytext); return(SIZEOF); }
"static"		{ strcpy(yylval.node.lexeme, yytext); return(STATIC); }
"struct"		{ strcpy(yylval.node.lexeme, yytext); return(STRUCT); }
"switch"		{ strcpy(yylval.node.lexeme, yytext); return(SWITCH); }
"template"		{ strcpy(yylval.node.lexeme, yytext); return(TEMPLATE); }
"this"			{ strcpy(yylval.node.lexeme, yytext); return(THIS); }
"throw"			{ strcpy(yylval.node.lexeme, yytext); return(THROW); }
"try"			{ strcpy(yylval.node.lexeme, yytext); return(TRY); }
"typedef"		{ strcpy(yylval.node.lexeme, yytext); return(TYPEDEF); }
"union"			{ strcpy(yylval.node.lexeme, yytext); return(UNION); }
"unsigned"		{ strcpy(yylval.node.lexeme, yytext); return(UNSIGNED); }
"using"			{ strcpy(yylval.node.lexeme, yytext); return(USING); }
"virtual"		{ strcpy(yylval.node.lexeme, yytext); return(VIRTUAL); }
"void"			{ strcpy(yylval.node.lexeme, yytext); return(VOID); }
"volatile"		{ strcpy(yylval.node.lexeme, yytext); return(VOLATILE); }
"WHILE"			{ strcpy(yylval.node.lexeme, yytext); return(WHILE); }

// Handling variable identifiers.
{L}({L}|{D})*		{
     strcpy(yylval.node.lexeme, yytext);
		return IDENTIFIER;
}

// Handling character literals.
{char}				{ 
						strcpy(yylval.node.lexeme, yytext);
						return C_CONST;
					}

// Handling string literals.
{string}			{ 	
						strcpy(yylval.node.lexeme, yytext);
						return S_CONST;
					}

// Handling boolean constants.
{bool}				{ 	
						strcpy(yylval.node.lexeme, yytext);
						return B_CONST;
					}

// Handling integer constants.
{integer}			{
						strcpy(yylval.node.lexeme, yytext);
						return I_CONST;
					}

// Handling floating-point constants (e.g., numbers with decimal points).
{drown}				{
						strcpy(yylval.node.lexeme, yytext);
						return F_CONST;
					}

// Operator and punctuation rules: These return the corresponding operator or punctuation token.

"..."			{ strcpy(yylval.node.lexeme, yytext); return(ELLIPSIS); }
">>="			{ strcpy(yylval.node.lexeme, yytext); return(RIGHT_ASSIGN); }
"<<="			{ strcpy(yylval.node.lexeme, yytext); return(LEFT_ASSIGN); }
"+="			{ strcpy(yylval.node.lexeme, yytext); return(ADD_ASSIGN); }
"-="			{ strcpy(yylval.node.lexeme, yytext); return(SUB_ASSIGN); }
"*="			{ strcpy(yylval.node.lexeme, yytext); return(MUL_ASSIGN); }
"/="			{ strcpy(yylval.node.lexeme, yytext); return(DIV_ASSIGN); }
"%="			{ strcpy(yylval.node.lexeme, yytext); return(MOD_ASSIGN); }
"&="			{ strcpy(yylval.node.lexeme, yytext); return(AND_ASSIGN); }
"^="			{ strcpy(yylval.node.lexeme, yytext); return(XOR_ASSIGN); }
"|="			{ strcpy(yylval.node.lexeme, yytext); return(OR_ASSIGN); }
"&&"			{ strcpy(yylval.node.lexeme, yytext); return(AND_OP); }
"||"			{ strcpy(yylval.node.lexeme, yytext); return(OR_OP); }
">="			{ strcpy(yylval.node.lexeme, yytext); return(GE_OP); }
"<="			{ strcpy(yylval.node.lexeme, yytext); return(LE_OP); }
"++"			{ strcpy(yylval.node.lexeme, yytext); return(INC_OP); }
"--"			{ strcpy(yylval.node.lexeme, yytext); return(DEC_OP); }
"->"			{ strcpy(yylval.node.lexeme, yytext); return(PTR_OP); }
"<<"			{ strcpy(yylval.node.lexeme, yytext); return(LEFT_OP); }
">>"			{ strcpy(yylval.node.lexeme, yytext); return(RIGHT_OP); }
"=="			{ strcpy(yylval.node.lexeme, yytext); return(EQ_OP); }
"!="			{ strcpy(yylval.node.lexeme, yytext); return(NE_OP); }
";"				{ strcpy(yylval.node.lexeme, yytext); return(SEMICOLON); }
"{"				{ strcpy(yylval.node.lexeme, yytext); return(LCURLY); }
"}"				{ strcpy(yylval.node.lexeme, yytext); return(RCURLY); }
"["				{ strcpy(yylval.node.lexeme, yytext); return(LBRACK); }
"]"				{ strcpy(yylval.node.lexeme, yytext); return(RBRACK); }
"("				{ strcpy(yylval.node.lexeme, yytext); return(LPAREN); }
")"				{ strcpy(yylval.node.lexeme, yytext); return(RPAREN); }
"."				{ strcpy(yylval.node.lexeme, yytext); return(DOT); }
"&"				{ strcpy(yylval.node.lexeme, yytext); return(AMPERSAND); }
"!"				{ strcpy(yylval.node.lexeme, yytext); return(EXCL); }
"~"				{ strcpy(yylval.node.lexeme, yytext); return(TILDE); }
"-"				{ strcpy(yylval.node.lexeme, yytext); return(MINUS); }
"+"				{ strcpy(yylval.node.lexeme, yytext); return(PLUS); }
"*"				{ strcpy(yylval.node.lexeme, yytext); return(STAR); }
"/"				{ strcpy(yylval.node.lexeme, yytext); return(SLASH); }
"%"				{ strcpy(yylval.node.lexeme, yytext); return(PERCENT); }
"<"				{ strcpy(yylval.node.lexeme, yytext); return(LT); }
">"				{ strcpy(yylval.node.lexeme, yytext); return(GT); }
"^"				{ strcpy(yylval.node.lexeme, yytext); return(CARET); }
"|"				{ strcpy(yylval.node.lexeme, yytext); return(BAR); }
"?"				{ strcpy(yylval.node.lexeme, yytext); return(QUESTION); }
":"				{ strcpy(yylval.node.lexeme, yytext); return(COLON); }
"="				{ strcpy(yylval.node.lexeme, yytext); return(EQUAL); }
","				{ strcpy(yylval.node.lexeme, yytext); return(COMMA); }

// Handling whitespace (space, tab, newline). We simply skip these characters.
[ \t\n]			{ /* Skip whitespace characters */ }

// Handling unrecognized characters.
.				{ printf("Unknown character: %s\n", yytext); }

%%

// Main function, used to run the lexical analyzer.
int yywrap(void) {
    return 1;
}

// Entry point: Reads from standard input and starts the lexer.
int main() {
    yylex();  // Calls the lexical analyzer
    return 0;
}

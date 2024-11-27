D			[0-9]
digits		{D}+
Letter			[a-zA-Z_]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*
integer			{digits}|[+-]?({digits}(E|e)[+-]?{digits}) 
drown			[-]?({digits}\.{digits})((E|e)[+-]?{digits})?
char			'[a-zA-Z]?'
string			(\"([^"\\\n]|(\\['"\?\\abfnrtv]))*\")+
bool			true|false
identifier		{Letter}({Letter}|{D})*
%{
#include <stdio.h>
#include "y.tab.h"
#include <string>
#include <map>
using namespace std;
int countn = 0;
void count();
void preprocess_file(FILE *fp);
/* Define a map to store macros */
std::map<std::string, std::string> macro_table;

%}

%%


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
"goto"			{ strcpy(yylval.node.lexeme, yytext); return(GOTO); }
"IF"			{ strcpy(yylval.node.lexeme, yytext); return(IF); }
"int"			{ strcpy(yylval.node.lexeme, yytext); return(INT); }
"long"			{ strcpy(yylval.node.lexeme, yytext); return(LONG); }
"main"			{strcpy(yylval.node.lexeme, yytext); return(MAIN);}
"namespace"		{ strcpy(yylval.node.lexeme, yytext); return(NAMESPACE); }
"new"			{ strcpy(yylval.node.lexeme, yytext); return(NEW); }
"operator"		{ strcpy(yylval.node.lexeme, yytext); return(OPERATOR); }
"PRINT" 		{strcpy(yylval.node.lexeme, yytext); return(PRINT);}
"private"		{ strcpy(yylval.node.lexeme, yytext); return(PRIVATE); }
"protected"		{ strcpy(yylval.node.lexeme, yytext); return(PROTECTED); }
"public"		{ strcpy(yylval.node.lexeme, yytext); return(PUBLIC); }
"register"		{ strcpy(yylval.node.lexeme, yytext); return(REGISTER); }
"RETURN"		{ strcpy(yylval.node.lexeme, yytext); return(RETURN); }
"SCAN"			{strcpy(yylval.node.lexeme, yytext); return(SCAN);}
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

{L}({L}|{D})*		{strcpy(yylval.node.lexeme, yytext); return(IDENTIFIER);}



{char}				{ 
						strcpy(yylval.node.lexeme, yytext);
						return C_CONST;
					}

{string}			{ 	
						strcpy(yylval.node.lexeme, yytext);
						return S_CONST;
					}

{bool}				{ 	
						strcpy(yylval.node.lexeme, yytext);
						return B_CONST;
					}

{digits}			{
						strcpy(yylval.node.lexeme, yytext);
						return I_CONST;
					}

{drown}				{
						strcpy(yylval.node.lexeme, yytext);
						return F_CONST;
					}

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
">>"			{ strcpy(yylval.node.lexeme, yytext); return(RIGHT_OP); }
"<<"			{ strcpy(yylval.node.lexeme, yytext); return(LEFT_OP); }
"++"			{ strcpy(yylval.node.lexeme, yytext); return(INC_OP); }
"--"			{ strcpy(yylval.node.lexeme, yytext); return(DEC_OP); }
"->"			{ strcpy(yylval.node.lexeme, yytext); return(PTR_OP); }
"&&"			{ strcpy(yylval.node.lexeme, yytext); return(AND); }
"||"			{ strcpy(yylval.node.lexeme, yytext); return(OR); }
"<="			{ strcpy(yylval.node.lexeme, yytext); return(LE); }
">="			{ strcpy(yylval.node.lexeme, yytext); return(GE); }
"=="			{ strcpy(yylval.node.lexeme, yytext); return(EQ); }
"!="			{ strcpy(yylval.node.lexeme, yytext); return(NE); }
";"			{ strcpy(yylval.node.lexeme, yytext); return(';'); }
("{")		{ strcpy(yylval.node.lexeme, yytext); return('{'); }
("}")		{ strcpy(yylval.node.lexeme, yytext); return('}'); }
","			{ strcpy(yylval.node.lexeme, yytext); return(','); }
":"			{ strcpy(yylval.node.lexeme, yytext); return(':'); }
"="			{ strcpy(yylval.node.lexeme, yytext); return(ASSIGN); }
"("			{ strcpy(yylval.node.lexeme, yytext); return('('); }
")"			{ strcpy(yylval.node.lexeme, yytext); return(')'); }
"["		{ strcpy(yylval.node.lexeme, yytext); return('['); }
"]"		{ strcpy(yylval.node.lexeme, yytext); return(']'); }
"."			{ strcpy(yylval.node.lexeme, yytext); return('.'); }
"&"			{ strcpy(yylval.node.lexeme, yytext); return(BIT_AND); }
"!"			{ strcpy(yylval.node.lexeme, yytext); return(NOT); }
"~"			{ strcpy(yylval.node.lexeme, yytext); return(NEG); }
"-"			{ strcpy(yylval.node.lexeme, yytext); return(SUB); }
"+"			{ strcpy(yylval.node.lexeme, yytext); return(ADD); }
"*"			{ strcpy(yylval.node.lexeme, yytext); return(MUL); }
"/"			{ strcpy(yylval.node.lexeme, yytext); return(DIV); }
"%"			{ strcpy(yylval.node.lexeme, yytext); return(MOD); }
"<"			{ strcpy(yylval.node.lexeme, yytext); return(LT); }
">"			{ strcpy(yylval.node.lexeme, yytext); return(GT); }
"^"			{ strcpy(yylval.node.lexeme, yytext); return(XOR); }
"|"			{ strcpy(yylval.node.lexeme, yytext); return(BIT_OR); }
"?"			{ strcpy(yylval.node.lexeme, yytext); return('?'); }
"$"			{ strcpy(yylval.node.lexeme, yytext); return('$'); }
[\n]		{ countn++; }
.			{ /* ignore bad characters */ }

%%




/* comment()
{
	char c, c1;

loop:
	while ((c = input()) != '*' && c != 0)
		putchar(c);

	if ((c1 = input()) != '/' && c != 0)
	{
		unput(c1);
		goto loop;
	}

	if (c != 0)
		putchar(c1);
} */


int column = 0;

void count()
{
	int i;

	for (i = 0; yytext[i] != '\0'; i++)
		if (yytext[i] == '\n')
			column = 0;
		else if (yytext[i] == '\t')
			column += 8 - (column % 8);
		else
			column++;
}


int check_type()
{
/*
* pseudo code --- this is what it should check
*
*	if (yytext == type_name)
*		return(TYPE_NAME);
*
*	return(IDENTIFIER);
*/

/*
*	it actually will only return IDENTIFIER
*/

	return(IDENTIFIER);
}


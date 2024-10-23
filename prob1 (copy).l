%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
%}
alpha [A-Za-z_]
digit [0-9]
%%

"if"                                {return IF;}
"else"                              {return ELSE;}
"while"                             {return WHILE;}
"switch"                            {return SWITCH;}
"case"                              {return CASE;}
"break"                             {return BREAK;}
"default"                           {return DEFAULT;}
"class"                             {return CLASS;}
"method"                            {return METHOD;}
"function"                          {return FUNCTION;}
"public"                            {return PUBLIC;}
"private"                            {return PRIVATE;}
"protected"                            {return PROTECTED;}
"return"                            {return RETURN;}
"new"                               {return NEW;}
"print"                             {return PRINT;}
"public"                            {return PUBLIC;}
"struct"                            {return STRUCT;}

{alpha}({alpha}|{digit})*    	    {strcpy(yylval.lexeme , yytext);
                                        /*printf("%s",yytext);*/ return ID;}
{digit}+"."{digit}+		            {/*printf("%s",yytext);*/
                                        yylval.fval = atof(yytext) ;
                                        return FLOAT_NUMBER;}
{digit}+ 							{/*printf("%s",yytext);*/
                                        yylval.dval = atoi(yytext) ;
                                        return NUMBER;}
">"                                 {/*printf("%s",yytext);*/return RELGREAT;}                                
"<"                             {/*printf("%s",yytext);*/return RELLESS;}
">="                                {/*printf("%s",yytext);*/return RELGREATEQUAL;}
"<="                                {/*printf("%s",yytext);*/return RELLESSEQUAL;}
"!="                                {/*printf("%s",yytext);*/return RELNOTEQUAL;}
"=="                                {/*printf("%s",yytext);*/return RELEQUAL;}
"&&"                                {/*printf("%s",yytext);*/return BOOLAND;}
"||"                                {/*printf("%s",yytext);*/return BOOLOR;}       
"!"                                 {/*printf("%s",yytext);*/return NOT;}
"++"					            {/*printf("%s",yytext);*/return INC;}
"--"					            {/*printf("%s",yytext);*/return DEC;}
"+"      							{/*printf("%s",yytext);*/return '+';}
"-"      							{/*printf("%s",yytext);*/return '-';}
"*"	 								{/*printf("%s",yytext);*/return '*';}
"/"     							{/*printf("%s",yytext);*/return '/';}
"=" 								{/*printf("%s",yytext);*/return '=';}
"("									{/*printf("%s",yytext);*/return '(';}
")"									{/*printf("%s",yytext);*/return ')';}
"{"									{/*printf("%s",yytext);*/return '{';}
"}"									{/*printf("%s",yytext);*/return '}';}
";"									{/*printf("%s",yytext);*/return ';';}
":"                                 {return ':';}
[ \t\n] {;}      /* ignore white space */

"$"		{ return 0; }

.  		{ return yytext[0]; }
%%

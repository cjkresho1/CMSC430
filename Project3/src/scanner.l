/* Compiler Theory and Design
   Duane J. Jarc */

/* This file contains flex input file */

%{
#include <string>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		[\-/]{2}.*\n
line		[\n]
id		[A-Za-z](_?[A-Za-z0-9]+)*
digit		[0-9]
int		{digit}+
double	{digit}+\.{digit}*([eE][+-]?{digit}+)?
punc		[\(\),:;]
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
"=>"	   { ECHO; return(ARROW); }
"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
"="		{ ECHO; yylval.oper = EQUAL; return(RELOP); }
"/="	   { ECHO; yylval.oper = NOTEQUAL; return(RELOP); }
">"		{ ECHO; yylval.oper = GREATER; return(RELOP); }
">="	   { ECHO; yylval.oper = GREATEREQUAL; return(RELOP); }
"<="	   { ECHO; yylval.oper = LESSEQUAL; return(RELOP); }
"+"		{ ECHO; yylval.oper = ADD; return(ADDOP); }
"-"		{ ECHO; yylval.oper = SUBTRACT; return(ADDOP); }
"*"		{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/"		{ ECHO; yylval.oper = DIVIDE; return(MULOP); }
"**"	   { ECHO; yylval.oper = EXP; return(EXPOP); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
case	{ ECHO; return(CASE); }
else	{ ECHO; return(ELSE); }
end		{ ECHO; return(END); }
endcase		{ ECHO; return(ENDCASE); }
endif		{ ECHO; return(ENDIF); }
endreduce	{ ECHO; return(ENDREDUCE); }
false		{ ECHO; yylval.value = 0; return(BOOL_LITERAL); }
function	{ ECHO; return(FUNCTION); }
if		{ ECHO; return(IF); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
not		{ ECHO; return(NOTOP); }
or		{ ECHO; return(OROP); }
others		{ ECHO; return(OTHERS); }
real		{ ECHO; return(REAL); }
reduce		{ ECHO; return(REDUCE); }
rem			{ ECHO; yylval.oper = REMAINDER; return (REMOP);}
returns		{ ECHO; return(RETURNS); }
then	{ ECHO; return(THEN); }
true	{ ECHO; yylval.value = 1; return(BOOL_LITERAL); }
when	{ ECHO; return(WHEN); }
and		{ ECHO; return(ANDOP); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{double}	{ ECHO; yylval.value = atof(yytext); return(REAL_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%

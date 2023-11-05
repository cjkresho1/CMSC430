/* Compiler Theory and Design
   Dr. Duane J. Jarc */

/* This file contains flex input file */

%{
#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		[\-/]{2}.*\n
line		[\n]
id		[A-Za-z](_?[A-Za-z0-9]+_?)*[A-Za-z0-9]
digit		[0-9]
int		{digit}+
double	{digit}+\.{digit}*([eE][+-]?{digit}+)?
punc		[\(\),:;]
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
"=>"	{ ECHO; return(ARROW); }
"<"		{ ECHO; return(RELOP); }
"="		{ ECHO; return(RELOP); }
"/="	{ ECHO; return(RELOP); }
">"		{ ECHO; return(RELOP); }
">="	{ ECHO; return(RELOP); }
"<="	{ ECHO; return(RELOP); }
"+"		{ ECHO; return(ADDOP); }
"-"		{ ECHO; return(ADDOP); }
"*"		{ ECHO; return(MULOP); }
"/"		{ ECHO; return(MULOP); }
"**"	{ ECHO; return(EXPOP); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
case	{ ECHO; return(CASE); }
else	{ ECHO; return(ELSE); }
end		{ ECHO; return(END); }
endcase		{ ECHO; return(ENDCASE); }
endif		{ ECHO; return(ENDIF); }
endreduce	{ ECHO; return(ENDREDUCE); }
false		{ ECHO; return(BOOL_LITERAL); }
function	{ ECHO; return(FUNCTION); }
if		{ ECHO; return(IF); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
not		{ ECHO; return(NOTOP); }
or		{ ECHO; return(OROP); }
others		{ ECHO; return(OTHERS); }
real		{ ECHO; return(REAL); }
reduce		{ ECHO; return(REDUCE); }
rem			{ ECHO; return (REMOP);}
returns		{ ECHO; return(RETURNS); }
then	{ ECHO; return(THEN); }
true	{ ECHO; return(BOOL_LITERAL); }
when	{ ECHO; return(WHEN); }
and		{ ECHO; return(ANDOP); }
{id}		{ ECHO; return(IDENTIFIER);}
{int}		{ ECHO; return(INT_LITERAL); }
{double}	{ ECHO; return(REAL_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }
%%

int main()
{
	firstLine();
	
	FILE *file = fopen("lexemes.txt", "wa"); 
	int token = yylex();
	while (token)
	{
		fprintf(file, "%d %s\n", token, yytext);
		token = yylex();
	}
	lastLine();
	fclose(file);
	return 0;
}
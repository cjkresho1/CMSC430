/* Compiler Theory and Design
   Duane J. Jarc */

/* @file scanner.l
 * @author Charles Kresho
 * @brief Project 4
 * @version 1.0
 * @date 2023-12-12
 *
 * This file contains flex input file. */

%{
#include <string>

using namespace std;

#include "types.h"
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
false		{ ECHO; yylval.type = BOOL_TYPE; return(BOOL_LITERAL); }
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
true	{ ECHO; yylval.type = BOOL_TYPE; return(BOOL_LITERAL); }
when	{ ECHO; return(WHEN); }
and		{ ECHO; return(ANDOP); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.type = INT_TYPE; return(INT_LITERAL); }
{double}	{ ECHO; yylval.type = REAL_TYPE; return(REAL_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%

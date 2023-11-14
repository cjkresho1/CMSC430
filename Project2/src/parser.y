/* Compiler Theory and Design
   Dr. Duane J. Jarc */

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER
%token INT_LITERAL
%token BOOL_LITERAL
%token REAL_LITERAL

%token ARROW

%token RELOP ADDOP MULOP REMOP EXPOP ANDOP OROP NOTOP 

%token BEGIN_ BOOLEAN CASE ELSE END ENDCASE ENDIF ENDREDUCE FUNCTION IF INTEGER IS OTHERS REAL REDUCE RETURNS THEN WHEN 

%%

function:	
	function_header optional_variable body ;
	
function_header:	
	FUNCTION IDENTIFIER optional_parameters RETURNS type ';' ;

optional_variable:
	variables |
	;

variables:
	IDENTIFIER ':' type IS statement_ |
	IDENTIFIER ':' type IS statement_ variables;

optional_parameters:
	parameters |
	parameters ',' optional_parameters |
	;

parameters:
	IDENTIFIER ':' type ;

type:
	INTEGER |
    REAL | 
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' ;
    
statement_:
	statement ';' |
	error ';' ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE |
	IF expression THEN statement_ ELSE statement_ ENDIF |
	CASE expression IS optional_cases OTHERS ARROW statement_ ENDCASE;

optional_cases:
	cases |
	;

cases:
	WHEN INT_LITERAL ARROW statement_ |
	WHEN INT_LITERAL ARROW statement_ cases;

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ |
	;
		    
expression:
	expression ANDOP relation |
	relation ;

relation:
	relation RELOP term |
	term;

term:
	term ADDOP factor |
	factor ;
      
factor:
	factor MULOP primary |
	primary ;

primary:
	'(' expression ')' |
	INT_LITERAL |
    REAL_LITERAL |
    BOOL_LITERAL |
	IDENTIFIER ;
    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 

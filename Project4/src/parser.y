/* Compiler Theory and Design
   Duane J. Jarc */

%{

#include <string>
#include <vector>
#include <map>

using namespace std;

#include "types.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<Types> symbols;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER
%token <type> INT_LITERAL
%token <type> BOOL_LITERAL
%token <type> REAL_LITERAL

%token ARROW

%token RELOP ADDOP MULOP REMOP EXPOP ANDOP OROP NOTOP 
%token BEGIN_ BOOLEAN CASE ELSE END ENDCASE ENDIF ENDREDUCE FUNCTION IF INTEGER IS OTHERS REAL REDUCE RETURNS THEN WHEN 

%type <type> function_header type body statement statement_ optional_cases case reductions expression wedge relation term
	factor exponent negation primary

%%

function:	
	function_header optional_variable body {checkAssignment($1, $3, "Function Return");} ;
	
function_header:	
	FUNCTION IDENTIFIER optional_parameters RETURNS type ';' {$$ = ($5);} ;

optional_variable:
	variables |
	;

variables:
	variables IDENTIFIER ':' type IS statement_
		{checkAssignment($4, $6, "Variable Initialization");
		Types temp;
		symbols.find($2, temp) ? appendError(DUPLICATE_IDENTIFIER, $2) : symbols.insert($2, $4);} |
	IDENTIFIER ':' type IS statement_ 
		{checkAssignment($3, $5, "Variable Initialization");
		Types temp;
		symbols.find($1, temp) ? appendError(DUPLICATE_IDENTIFIER, $1) : symbols.insert($1, $3);} ;

optional_parameters:
	parameters |
	parameters ',' optional_parameters |
	;

parameters:
	IDENTIFIER ':' type {Types temp;
		symbols.find($1, temp) ? appendError(DUPLICATE_IDENTIFIER, $1) : symbols.insert($1, $3);} ;

type:
	INTEGER {$$ = INT_TYPE;} |
	REAL {$$ = REAL_TYPE;} |
	BOOLEAN {$$ = BOOL_TYPE;} ;

body:
	BEGIN_ statement_ END ';' {$$ = ($2);} ;
    
statement_:
	statement ';' {$$ = $1;} |
	error ';' {$$ = MISMATCH;} ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
	IF expression THEN statement_ ELSE statement_ ENDIF {$$ = checkIfExpression($2, $4, $6);} |
	CASE expression IS optional_cases OTHERS ARROW statement_ ENDCASE
		{$$ = checkCaseTypes($4, $7); 
		if ($2 != INT_TYPE) { appendError(GENERAL_SEMANTIC, "Case Expression Not Integer"); } };

optional_cases:
    optional_cases case {$$ = checkCaseTypes($1, $2);} |
	{$$ = NO_TYPE; };

case:
	WHEN INT_LITERAL ARROW statement_ {$$ = $4;};

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ {$$ = checkArithmetic($1, $2);} |
	{$$ = INT_TYPE;} ;
		    
expression:
	expression OROP wedge {$$ = checkLogical($1, $3);} |
	wedge ;
		    
wedge:
	wedge ANDOP relation {$$ = checkLogical($1, $3);} |
	relation ;

relation:
	relation RELOP term {$$ = checkRelational($1, $3);}|
	term ;

term:
	term ADDOP factor {$$ = checkArithmetic($1, $3);} |
	factor ;
      
factor:
	factor MULOP exponent  {$$ = checkArithmetic($1, $3);} |
	factor REMOP exponent {$$ = checkRemainder($1, $3);} |
	exponent ;
    
exponent:
    negation EXPOP exponent {$$ = checkArithmetic($1, $3);} |
    negation ;

negation:
	NOTOP primary {$$ = checkLogical(BOOL_TYPE, $2);} |
	primary;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL |
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;
    
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

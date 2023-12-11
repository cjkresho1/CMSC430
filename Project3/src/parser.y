/* Compiler Theory and Design
   Duane J. Jarc */

%{

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<float> symbols;

float result;

float* params;
int paramIndex = 0;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Operators oper;
	float value;
}

%token <iden> IDENTIFIER
%token <value> INT_LITERAL
%token <value> BOOL_LITERAL
%token <value> REAL_LITERAL

%token ARROW

%token <oper> RELOP ADDOP MULOP REMOP EXPOP
%token ANDOP OROP NOTOP

%token BEGIN_ BOOLEAN CASE ELSE END ENDCASE ENDIF ENDREDUCE FUNCTION IF INTEGER IS OTHERS REAL REDUCE RETURNS THEN WHEN 

%type <value> body statement_ statement optional_cases case reductions expression wedge relation term
	factor exponent negation primary
%type <oper> operator

%%

function:	
	function_header optional_variable body {result = $3;} ;
	
function_header:	
	FUNCTION IDENTIFIER optional_parameters RETURNS type ';' ;

optional_variable:
	variables |
	;

variables:	
	variables IDENTIFIER ':' type IS statement_ {symbols.insert($2, $6);} | 
	IDENTIFIER ':' type IS statement_ {symbols.insert($1, $5);} ;

optional_parameters:
	parameters |
	parameters ',' optional_parameters |
	;

parameters:
	IDENTIFIER ':' type {symbols.insert($1, params[paramIndex]); paramIndex++;};

type:
	INTEGER |
	REAL |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' |
	error ';' {$$ = 0;} ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
	IF expression THEN statement_ ELSE statement_ ENDIF {$$ = $2 ? $4 : $6;} |
	CASE expression IS optional_cases OTHERS ARROW statement_ ENDCASE {$$ = isnan($4) ? $7 : $4;};

optional_cases:
    optional_cases case {$$ = isnan($1) ? $2 : $1;} |
	{$$ = NAN;};

case:
	WHEN INT_LITERAL ARROW statement_ {$$ = ($<value>-2 == $2) ? $4 : NAN;};

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2);} |
	{$$ = $<oper>0 == ADD ? 0 : 1;} ;

expression:
	expression OROP wedge {$$ = $1 || $3;}|
	wedge ;

wedge:
	wedge ANDOP relation {$$ = $1 && $3;}|
	relation ;

relation:
	relation RELOP term {$$ = evaluateRelational($1, $2, $3);} |
	term ;

term:
	term ADDOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	factor ;
      
factor:
	factor MULOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
    factor REMOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
	exponent ;

exponent:
    negation EXPOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
    negation;

negation: 
	NOTOP primary {$$ = ! $2;} |
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
	params = (float *) malloc((argc - 1) * sizeof(float));
	for (int i = 0; i < argc - 1; i++ ) 
	{
		params[i] = atof(argv[i + 1]);
	}

	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	
	free(params);
	return 0;
} 

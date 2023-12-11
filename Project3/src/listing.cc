// Compiler Theory and Design
// Dr. Duane J. Jarc

// This file contains the bodies of the functions that produces the compilation
// listing

#include <cstdio>
#include <string>
#include <queue>

using namespace std;

#include "listing.h"

static int lineNumber;
static queue<string> errorQueue;
static int totalErrors = 0;
static int lexicalErrors = 0;
static int syntaxErrors = 0;
static int semanticErrors = 0;

static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ", lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ", lineNumber);
}

int lastLine()
{
	printf("\r");
	displayErrors();
	printf("     \n");

	if (totalErrors == 0)
	{
		printf("Compiled Successfully\n");
	}
	else
	{
		printf("Lexical Errors %d\n", lexicalErrors);
		printf("Syntax Errors %d\n", syntaxErrors);
		printf("Semantic Errors %d\n", semanticErrors);
	}

	return totalErrors;
}

void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = {"Lexical Error, Invalid Character ", "",
						 "Semantic Error, ", "Semantic Error, Duplicate Identifier: ",
						 "Semantic Error, Undeclared "};

	errorQueue.push(messages[errorCategory] + message);
	totalErrors++;
	if (errorCategory == 0)
		lexicalErrors++;
	else if (errorCategory == 1)
		syntaxErrors++;
	else
		semanticErrors++;
}

void displayErrors()
{
	while (errorQueue.size() != 0)
	{
		printf("%s\n", errorQueue.front().c_str());
		errorQueue.pop();
	}
}

// Compiler Theory and Design
// Duane J. Jarc

/**
 * @file listing.h
 * @author Charles Kresho
 * @brief Project 3
 * @version 1.0
 * @date 2023-12-11
 *
 * This file contains the function prototypes for the functions that produce the compilation listing.
 *
 */

enum ErrorCategories
{
	LEXICAL,
	SYNTAX,
	GENERAL_SEMANTIC,
	DUPLICATE_IDENTIFIER,
	UNDECLARED
};

void firstLine();
void nextLine();
int lastLine();
void appendError(ErrorCategories errorCategory, string message);

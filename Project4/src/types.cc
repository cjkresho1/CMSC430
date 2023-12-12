// Compiler Theory and Design
// Duane J. Jarc

// This file contains the bodies of the type checking functions

#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

void checkAssignment(Types lValue, Types rValue, string message)
{
	if (lValue == MISMATCH || rValue == MISMATCH)
	{
		return;
	}

	if (lValue == INT_TYPE && rValue == REAL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Illegal Narrowing " + message);
	}
	else if (lValue != rValue)
	{
		appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
	}
}

Types checkArithmetic(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == BOOL_TYPE || right == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Numeric Type Required");
		return MISMATCH;
	}
	if (left == REAL_TYPE || right == REAL_TYPE)
	{
		return REAL_TYPE;
	}
	return INT_TYPE;
}

Types checkLogical(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left != BOOL_TYPE || right != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}
	return BOOL_TYPE;
	return MISMATCH;
}

Types checkRelational(Types left, Types right)
{
	if (checkArithmetic(left, right) == MISMATCH)
		return MISMATCH;
	return BOOL_TYPE;
}

Types checkRemainder(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left != INT_TYPE || right != INT_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Remainder Operator Requires Integer Operands");
		return MISMATCH;
	}
	return INT_TYPE;
}

Types checkIfExpression(Types condition, Types first, Types second)
{
	if (condition != MISMATCH && condition != BOOL_TYPE)
		appendError(GENERAL_SEMANTIC, "If Expression Must Be Boolean");
	if (first != second)
	{
		appendError(GENERAL_SEMANTIC, "If-Then Type Mismatch");
		return MISMATCH;
	}
	return first;
}

Types checkCaseTypes(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
	{
		return MISMATCH;
	}
	if (left == NO_TYPE)
	{
		return right;
	}
	if (right == NO_TYPE)
	{
		return left;
	}
	if (left != right)
	{
		appendError(GENERAL_SEMANTIC, "Case Types Mismatch");
		return MISMATCH;
	}
	return left;
}
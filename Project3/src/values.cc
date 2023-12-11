// CMSC 430
// Duane J. Jarc

// This file contains the bodies of the evaluation functions

#include <string>
#include <vector>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"

float evaluateReduction(Operators operator_, float head, float tail)
{
	float result;
	switch (operator_)
	{
	case ADD:
		result = head + tail;
	case SUBTRACT:
		result = head - tail;
	case MULTIPLY:
		result = head * tail;
	case DIVIDE:
		result = head / tail;
	default:
		result = head * tail;
	}
	return result;
}

float evaluateRelational(float left, Operators operator_, float right)
{
	float result;
	switch (operator_)
	{
	case LESS:
		result = left < right;
		break;
	case EQUAL:
		result = left == right;
		break;
	case NOTEQUAL:
		result = left != right;
		break;
	case GREATER:
		result = left > right;
		break;
	case GREATEREQUAL:
		result = left >= right;
		break;
	case LESSEQUAL:
		result = left <= right;
	}
	return result;
}

float evaluateArithmetic(float left, Operators operator_, float right)
{
	float result;
	switch (operator_)
	{
	case ADD:
		result = left + right;
		break;
	case SUBTRACT:
		result = left - right;
		break;
	case MULTIPLY:
		result = left * right;
		break;
	case DIVIDE:
		result = left / right;
		break;
	case EXP:
		result = powf(left, right);
		break;
	case REMAINDER:
		result = (int) left % (int) right;
		break;
	}
	return result;
}

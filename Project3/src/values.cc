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
	if (operator_ == ADD)
		return head + tail;
	return head * tail;
}


float evaluateRelational(float left, Operators operator_, float right)
{
	float result;
	switch (operator_)
	{
		case LESS:
			result = left < right;
			break;
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
		case MULTIPLY:
			result = left * right;
			break;
	}
	return result;
}


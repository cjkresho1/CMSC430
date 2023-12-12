// Compiler Theory and Design
// Duane J. Jarc

/**
 * @file types.h
 * @author Charles Kresho
 * @brief Project 4
 * @version 1.0
 * @date 2023-12-12
 *
 * This file contains type definitions and the function prototypes for the type checking functions.
 *
 */

typedef char *CharPtr;

enum Types
{
    MISMATCH,
    INT_TYPE,
    REAL_TYPE,
    BOOL_TYPE,
    NO_TYPE
};

void checkAssignment(Types lValue, Types rValue, string message);
Types checkArithmetic(Types left, Types right);
Types checkLogical(Types left, Types right);
Types checkRelational(Types left, Types right);
Types checkRemainder(Types left, Types right);
Types checkIfExpression(Types condition, Types first, Types second);
Types checkCaseTypes(Types left, Types right);
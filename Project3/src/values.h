// CMSC 430
// Duane J. Jarc

/**
 * @file listing.cc
 * @author Charles Kresho
 * @brief Project 3
 * @version 1.0
 * @date 2023-12-11
 *
 * This file contains function definitions for the evaluation functions.
 *
 */

typedef char *CharPtr;
enum Operators
{
    LESS,
    EQUAL,
    NOTEQUAL,
    GREATER,
    GREATEREQUAL,
    LESSEQUAL,
    ADD,
    SUBTRACT,
    MULTIPLY,
    DIVIDE,
    EXP,
    REMAINDER
};

float evaluateReduction(Operators operator_, float head, float tail);
float evaluateRelational(float left, Operators operator_, float right);
float evaluateArithmetic(float left, Operators operator_, float right);

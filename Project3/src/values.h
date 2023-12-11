// CMSC 430
// Duane J. Jarc

// This file contains function definitions for the evaluation functions

typedef char* CharPtr;
enum Operators {LESS, ADD, MULTIPLY};

float evaluateReduction(Operators operator_, float head, float tail);
float evaluateRelational(float left, Operators operator_, float right);
float evaluateArithmetic(float left, Operators operator_, float right);


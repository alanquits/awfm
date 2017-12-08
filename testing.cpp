#include "testing.h"

#include <iostream>

#include "specialfunctions.h"
#include "theis.h"
#include "well.h"

Testing::Testing()
{

}

void Testing::runTests()
{
    testWellFunction();
}

void Testing::testWellFunction()
{
    double x = W(1.0);
    std::cout << "W(1.0) = " << x;
}

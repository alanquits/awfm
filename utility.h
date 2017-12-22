#ifndef UTILITY_H
#define UTILITY_H

#include <cmath>

namespace awfm {
    class Utility
    {
    public:
        static bool floatCompare(double x1, double x2, double tol=1e-6);
    };
}

#endif // UTILITY_H

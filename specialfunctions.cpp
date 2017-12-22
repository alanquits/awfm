#include "specialfunctions.h"

namespace awfm {
    double Factorial(int n)
    {
      return dfac_(&n);
    }

    double K0(double x)
    {
        return dbesk0_(&x);
    }

    double W(double u)
    {
      return (u > 100) ? 0 : de1_(&u);
    }
}

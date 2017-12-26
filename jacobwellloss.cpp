#include <cmath>
#include "jacobwellloss.h"

namespace awfm {
    JacobWellLoss::JacobWellLoss(double B, double C)
    {
        modelType_ = JACOB;
        B_ = B;
        C_ = C;
    }

    double JacobWellLoss::drawdown(double Q)
    {
        C_*pow(Q,2) + B_*Q;
    }
}


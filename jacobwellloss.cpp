#include "jacobwellloss.h"

namespace awfm {
    JacobWellLoss::JacobWellLoss(double B, double C)
    {
        modelType_ = JACOB;
        B_ = B;
        C_ = C;
    }

    double JacobWellLoss::drawdown(Well &w, double t)
    {
        return 0;
    }
}


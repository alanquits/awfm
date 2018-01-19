#include <cmath>
#include "jacobsimplifiedwellloss.h"

namespace awfm {
    JacobSimplifiedWellLoss::JacobSimplifiedWellLoss(double C)
    {
        C_ = C;
        dC_ = 0;
        modelType_ = SIMPLIFIEDJACOB;
    }

    double JacobSimplifiedWellLoss::drawdown(double Q)
    {
        return C_*pow(Q,2);

    }
}

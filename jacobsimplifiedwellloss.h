#ifndef JACOBSIMPLIFIEDWELLLOSS_H
#define JACOBSIMPLIFIEDWELLLOSS_H

#include "abstractwelllossmodel.h"

namespace awfm {
    class JacobSimplifiedWellLoss : public AbstractWellLossModel {
    private:
        double C_;
        double dC_;

    public:
        JacobSimplifiedWellLoss(double C);
        virtual WellLossModel modelType() { return SIMPLIFIEDJACOB; }
        virtual QString modelTypeAsString() { return "simplified jacob"; }
//        virtual double drawdown(Well &w, double t);
        virtual double drawdown(double Q);
        double C() { return C_; }
        double dC() { return dC_; }
    };
}

#endif // #define JACOBSIMPLIFIEDWELLLOSS_H

#ifndef JACOBWELLLOSS_H
#define JACOBWELLLOSS_H

#include "abstractwelllossmodel.h"

namespace awfm {
    class JacobWellLoss : public AbstractWellLossModel {
    private:
        double B_;
        double C_;
        double dB_;
        double dC_;

    public:
        JacobWellLoss(double B, double C);
        virtual WellLossModel modelType() { return JACOB; }
        virtual QString modelTypeAsString() { return "jacob"; }
        virtual double drawdown(double Q);

        double B() { return B_; }
        double C() { return C_; }
        double dB() { return dB_; }
        double dC() { return dC_; }
    };
}

#endif // #define JACOBWELLLOSS_H

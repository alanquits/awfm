#ifndef JACOBWELLLOSS_H
#define JACOBWELLLOSS_H

#include "abstractwelllossmodel.h"

namespace awfm {
    class JacobWellLoss : public AbstractWellLossModel {
    private:
        double B_;
        double C_;

    public:
        JacobWellLoss(double B, double C);
        virtual WellLossModel modelType() { return JACOB; }
        virtual QString modelTypeAsString() { return "jacob"; }
        virtual double drawdown(double Q);
    };
}

#endif // #define JACOBWELLLOSS_H

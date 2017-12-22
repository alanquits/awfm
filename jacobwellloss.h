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
        virtual double drawdown(Well &w, double t);
    };
}

#endif // #define JACOBWELLLOSS_H

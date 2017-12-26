#ifndef JACOBSIMPLIFIEDWELLLOSS_H
#define JACOBSIMPLIFIEDWELLLOSS_H

#include "abstractwelllossmodel.h"

namespace awfm {
    class JacobSimplifiedWellLoss : public AbstractWellLossModel {
    private:
        double C_;

    public:
        JacobSimplifiedWellLoss(double C);
//        virtual double drawdown(Well &w, double t);
        virtual double drawdown(double Q);
    };
}

#endif // #define JACOBSIMPLIFIEDWELLLOSS_H

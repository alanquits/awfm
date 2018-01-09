#ifndef THEIS_H
#define THEIS_H

#include "abstractaquiferdrawdownmodel.h"
#include "specialfunctions.h"
#include "timeseries.h"
#include "well.h"

namespace awfm {
    class Theis : public AbstractAquiferDrawdownModel
    {
    private:
        double T_;
        double S_;


    public:
        Theis(double S, double T);
        virtual AquiferDrawdownModel modelType() { return THEIS; }
        virtual double drawdownAtWell(Well &w, double x, double y, double t);

        double T() { return T_; }
        double S() { return S_; }
    };
}
#endif // THEIS_H

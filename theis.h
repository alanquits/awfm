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
        virtual QString modelTypeAsString() { return "theis"; }
        virtual double drawdownAtWell(Well &w, double x, double y, double t, bool spinup=false);

        double T() { return T_; }
        double S() { return S_; }

        virtual void toStdUnits(LengthUnit lu, TimeUnit tu);
        virtual void fromStdUnits(LengthUnit lu, TimeUnit tu);

    };
}
#endif // THEIS_H

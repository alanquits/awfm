#ifndef THEIS_H
#define THEIS_H

#include "abstractaquiferdrawdownmodel.h"
#include "specialfunctions.h"
#include "timeseries.h"
#include "well.h"

class Theis : public AbstractAquiferDrawdownModel
{
private:
    double T_;
    double S_;


public:
    Theis(double S, double T);

    virtual double drawdownAtWell(Well &w, double x, double y, double t);
};

#endif // THEIS_H

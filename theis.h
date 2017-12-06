#ifndef THEIS_H
#define THEIS_H

#include "abstractaquiferdrawdownmodel.h"

class Theis : AbstractAquiferDrawdownModel
{
private:
    double T_;
    double S_;

public:
    Theis(double S, double T);

    virtual double drawdown(double x, double y, double t);
};

#endif // THEIS_H

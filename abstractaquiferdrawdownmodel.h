#ifndef ABSTRACTAQUIFERDRAWDOWNMODEL_H
#define ABSTRACTAQUIFERDRAWDOWNMODEL_H

#include <vector>

#include "well.h"

typedef enum {
    THEIS,
    HANTUSHJACOB
} AquiferDrawdownModel;

class AbstractAquiferDrawdownModel
{
protected:
    AquiferDrawdownModel modelType_;
    std::vector<Well> *wells_;
public:
    AbstractAquiferDrawdownModel();

    virtual double drawdown(double x, double y, double t)=0;

    void setWells(std::vector<Well> *wells) { wells_ = wells; }
};

#endif // ABSTRACTAQUIFERDRAWDOWNMODEL_H

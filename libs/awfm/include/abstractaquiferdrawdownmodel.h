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

    double drawdown(std::vector<Well> &wells, double x, double y, double t);
    virtual double drawdownAtWell(Well &well, double x, double y, double t)=0;

    void setWells(std::vector<Well> *wells) { wells_ = wells; }
};

#endif // ABSTRACTAQUIFERDRAWDOWNMODEL_H

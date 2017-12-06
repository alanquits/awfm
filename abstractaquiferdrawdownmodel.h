#ifndef ABSTRACTAQUIFERDRAWDOWNMODEL_H
#define ABSTRACTAQUIFERDRAWDOWNMODEL_H

typedef enum {
    THEIS,
    HANTUSH_JACOB
} AquiferDrawdownModel;

class AbstractAquiferDrawdownModel
{
private:
    AquiferDrawdownModel modelType_;
public:
    AbstractAquiferDrawdownModel();

    virtual double drawdown(double x, double y, double t)=0;
};

#endif // ABSTRACTAQUIFERDRAWDOWNMODEL_H

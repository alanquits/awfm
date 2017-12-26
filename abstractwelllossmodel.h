#ifndef ABSTRACTWELLLOSSMODEL_H
#define ABSTRACTWELLLOSSMODEL_H

#include <QList>

namespace awfm {

    typedef enum {
        JACOB,
        SIMPLIFIEDJACOB
    } WellLossModel;

    class AbstractWellLossModel
    {
    protected:
        WellLossModel modelType_;

    public:
        WellLossModel modelType() { return modelType_; }
        virtual double drawdown(double Q)=0;
    };

}

#endif // ABSTRACTWELLLOSSMODEL_H

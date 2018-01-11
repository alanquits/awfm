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
        virtual WellLossModel modelType() { return modelType_; }
        virtual QString modelTypeAsString()=0;
        virtual double drawdown(double Q)=0;
    };

}

#endif // ABSTRACTWELLLOSSMODEL_H

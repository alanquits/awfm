#ifndef ABSTRACTWELLLOSSMODEL_H
#define ABSTRACTWELLLOSSMODEL_H

#include <vector>
#include "well.h"

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
        AbstractWellLossModel();

        virtual double drawdown(Well &well, double t)=0;
    };

}

#endif // ABSTRACTWELLLOSSMODEL_H

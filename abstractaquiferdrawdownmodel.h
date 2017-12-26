#ifndef ABSTRACTAQUIFERDRAWDOWNMODEL_H
#define ABSTRACTAQUIFERDRAWDOWNMODEL_H

#include <QList>
#include "well.h"

namespace awfm {

    typedef enum {
        THEIS,
        HANTUSHJACOB
    } AquiferDrawdownModel;

    class AbstractAquiferDrawdownModel
    {
    protected:
        AquiferDrawdownModel modelType_;
        QList<Well> *wells_;
    public:
        AbstractAquiferDrawdownModel();

        double drawdown(QList<Well> &wells, double x, double y, double t);
        virtual double drawdownAtWell(Well &well, double x, double y, double t)=0;

        void setWells(QList<Well> *wells) { wells_ = wells; }
    };

}

#endif // ABSTRACTAQUIFERDRAWDOWNMODEL_H

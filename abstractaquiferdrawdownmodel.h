#ifndef ABSTRACTAQUIFERDRAWDOWNMODEL_H
#define ABSTRACTAQUIFERDRAWDOWNMODEL_H

#include <QList>
#include <QString>
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

        virtual AquiferDrawdownModel modelType()=0;
        virtual QString modelTypeAsString()=0;

        double drawdown(QList<Well> &wells, double x, double y, double t);
        virtual double drawdownAtWell(Well &well, double x, double y, double t)=0;

        void setWells(QList<Well> *wells) { wells_ = wells; }
        virtual void toStdUnits(LengthUnit lu, TimeUnit tu)=0;
        virtual void fromStdUnits(LengthUnit lu, TimeUnit tu)=0;
    };

}

#endif // ABSTRACTAQUIFERDRAWDOWNMODEL_H

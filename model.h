#ifndef MODEL_H
#define MODEL_H

#include "abstractaquiferdrawdownmodel.h"
#include "abstractwelllossmodel.h"
#include "definitions.h"
#include "temporaldomain.h"
#include "well.h"
#include <QList>

namespace awfm {
    class Model {
    private:
    AbstractAquiferDrawdownModel *aquiferDrawdownModel_;
    WellLossModel wellLossModel_;
    LengthUnit lengthUnit_;
    TimeUnit timeUnit_;
    DischargeUnit dischargeUnit_;
    QList<Well> wells_;
    TemporalDomain temporalDomain_;

    public:
    Model();
    void setAquiferDrawdownModel(AbstractAquiferDrawdownModel*);
    void setWells(QList<Well> wells);
    void setTemporalDomain(TemporalDomain td);

    void run();
    void runAtWell(size_t idx);
    };
}

#endif //MODEL_H

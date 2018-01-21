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
    QMap<QString, bool> options_;
    TemporalDomain temporalDomain_;

    public:
    Model();
    AbstractAquiferDrawdownModel *aquiferDrawdownModel() { return aquiferDrawdownModel_; }

    LengthUnit lengthUnit() { return lengthUnit_; }
    TimeUnit timeUnit() { return timeUnit_; }
    DischargeUnit dischargeUnit() { return dischargeUnit_; }
    bool isOptionOn(QString option);

    void setOption(QString option, bool is_on);
    void setAquiferDrawdownModel(AbstractAquiferDrawdownModel*);
    void setWells(QList<Well> wells);
    void setTemporalDomain(TemporalDomain td);

    void setLengthUnit(LengthUnit u) { lengthUnit_ = u; }
    void setTimeUnit(TimeUnit u) { timeUnit_ = u; }
    void setDischargeUnit(DischargeUnit u) { dischargeUnit_ = u; }

    QList<Well> wells() { return wells_; }
    QList<Well>* wellsRef() { return &wells_; }
    Well* wellRef(int idx) { return &wells_[idx]; }

    void run();
    void runAtWell(size_t idx);
    };
}

#endif //MODEL_H

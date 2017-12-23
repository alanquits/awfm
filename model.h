#ifndef MODEL_H
#define MODEL_H

#include "abstractaquiferdrawdownmodel.h"
#include "abstractwelllossmodel.h"
#include "temporaldomain.h"
#include "well.h"

namespace awfm {
    class Model {
    private:
    AbstractAquiferDrawdownModel *aquiferDrawdownModel_;
    AbstractWellLossModel *wellLossModel_;
    std::vector<Well> wells_;
    TemporalDomain temporalDomain_;

    public:
    Model();
    void setAquiferDrawdownModel(AbstractAquiferDrawdownModel*);
    void setWellLossModel(AbstractWellLossModel *m);
    void setWells(std::vector<Well> wells);
    void setTemporalDomain(TemporalDomain td);

    void run();
    void runAtWell(size_t idx);
    };
}

#endif //MODEL_H

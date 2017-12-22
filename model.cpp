#include "model.h"

#include "temporaldomain.h"

namespace awfm {
    Model::Model()
    {
        temporalDomain_ = TemporalDomain();
    }

    void Model::setAquiferDrawdownModel(AbstractAquiferDrawdownModel *m)
    {
        aquiferDrawdownModel_ = m;
    }

    void Model::setWellLossModel(AbstractWellLossModel *m)
    {
        wellLossModel_ = m;
    }

    void Model::setWells(std::vector<Well> wells)
    {
        wells_ = wells;
    }

    void Model::run()
    {
        for (int i = 0; i < wells_.size(); i++) {
            runAtWell(i);
        }
    }

    void Model::runAtWell(size_t idx)
    {
        Timeseries sAq;
        Timeseries sLoss;
        double x = wells_[idx].x();
        double y = wells_[idx].y();
        std::vector<double> ts_at_well;
        ts_at_well = temporalDomain_.domainType() == TEMPORALDOMAIN_ATWELLS
                    ? wells_[idx].wl().ts()
                    : temporalDomain_.ts();

        for (int i = 0; i < ts_at_well.size(); i++) {
            double t = ts_at_well[i];
            double s_aq = aquiferDrawdownModel_->drawdown(wells_, x, y, t);
            sAq.append(t, s_aq);
            double s_wl = wellLossModel_->drawdown(wells_[idx], t);
            sLoss.append(t, s_wl);
        }

        wells_[idx].setSAq(sAq);
        wells_[idx].setSLoss(sLoss);
    }
}

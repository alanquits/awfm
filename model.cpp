#include "model.h"

#include "jacobwellloss.h"
#include "jacobsimplifiedwellloss.h"
#include "theis.h"
#include "temporaldomain.h"
#include "resources/create_db.h"

#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>


namespace awfm {
    Model::Model()
    {
        aquiferDrawdownModel_ = NULL;
        setAquiferDrawdownModel(new Theis(1e-4, 200));
        temporalDomain_ = TemporalDomain();
        lengthUnit_ = METERS;
        timeUnit_ = DAYS;
        dischargeUnit_ = M3D;
        wells_.push_back(awfm::Well("Well 1", 0, 0, 1, 0));
    }

    void Model::setAquiferDrawdownModel(AbstractAquiferDrawdownModel *m)
    {
        if (aquiferDrawdownModel_) {
            delete aquiferDrawdownModel_;
            aquiferDrawdownModel_ = NULL;
        }
        aquiferDrawdownModel_ = m;
    }

    void Model::setTemporalDomain(TemporalDomain td)
    {
        temporalDomain_ = td;
    }

    void Model::setWells(QList<Well> wells)
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
        QList<double> ts_at_well;
        ts_at_well = temporalDomain_.domainType() == TEMPORALDOMAIN_ATWELLS
                    ? wells_[idx].wl().ts()
                    : temporalDomain_.ts();

        for (int i = 0; i < ts_at_well.size(); i++) {
            double t = ts_at_well[i];
            double s_aq = aquiferDrawdownModel_->drawdown(wells_, x, y, t);
            sAq.append(t, s_aq);
//            double s_wl = wellLossModel_->drawdown(wells_[idx], t);
//            sLoss.append(t, s_wl);
        }

        wells_[idx].setSAq(sAq);
        wells_[idx].setSLoss(sLoss);
    }
}

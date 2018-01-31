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

        options_["h0_transient_on"] = false;
        options_["well_loss_turbulant_on"] = false;
        options_["well_loss_laminar_on"] = false;
        options_["well_loss_transient_on"] = false;
    }

    bool Model::isOptionOn(QString option)
    {
        if (options_.keys().contains(option)) {
            return options_[option];
        } else {
            return false;
        }
    }

    void Model::setOption(QString option, bool is_on)
    {
        if (options_.keys().contains(option)) {
            options_[option] = is_on;
        }
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
        bool turbulant_well_loss =
                isOptionOn("well_loss_turbulant_on");
        bool laminar_well_loss =
                isOptionOn("well_loss_laminar_on");
        bool transient_well_loss =
                isOptionOn("well_loss_transient_on");
        bool transient_h0 =
                isOptionOn("h0_transient_on");

        for (int i = 0; i < wells_.length(); i++) {
            wells_[i].toStdUnits(lengthUnit_, timeUnit_, dischargeUnit_);
        }
        temporalDomain_.toStdUnits(timeUnit_);
        aquiferDrawdownModel_->toStdUnits(lengthUnit_, timeUnit_);



        Well *observation_well = wellRef(idx);
        observation_well->clearResults();
        QList<double> ts_at_observation_well;
        ts_at_observation_well =
            temporalDomain_.domainType() == TEMPORALDOMAIN_ATWELLS
            ? observation_well->wl().ts()
            : temporalDomain_.ts();

        double x = observation_well->x();
        double y = observation_well->y();
        foreach(double t, ts_at_observation_well) {
            double s_aq = 0;
            for (int i = 0; i < wellsRef()->length(); i++) {
                Well *pumping_well = wellRef(i);
                s_aq += aquiferDrawdownModel_->drawdownAtWell(*pumping_well, x, y, t);
            }
            double s_w = observation_well->wellLossAt(t, turbulant_well_loss,
                                                      laminar_well_loss, transient_well_loss);
            double h0 = observation_well->h0AtT(t, transient_h0);
            // Convert results in std units back to displayed units
            t /= Utility::conversionFactor(timeUnit_);
            h0 /= Utility::conversionFactor(lengthUnit_);
            s_aq /= Utility::conversionFactor(lengthUnit_);
            s_w /= Utility::conversionFactor(lengthUnit_);
            observation_well->appendResult(t, h0, s_aq, s_w);
        }

        for (int i = 0; i < wells_.length(); i++) {
            wells_[i].fromStdUnits(lengthUnit_, timeUnit_, dischargeUnit_);
        }
        temporalDomain_.fromStdUnits(timeUnit_);
        aquiferDrawdownModel_->fromStdUnits(lengthUnit_, timeUnit_);
    }
}

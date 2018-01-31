#include "well.h"

#include <cassert>
#include <cmath>
#include <QDebug>

namespace awfm {
    Well::Well(QString name, double x, double y, double rw, double h0)
    {
        name_ = name;
        x_ = x;
        y_ = y;
        rw_ = rw;
        h0_ = h0;
        dh0_ = 0;
        b_ = 0;
        c_ = 0;
        db_ = 0;
        dc_ = 0;
        clearResults();
    }

    void Well::setName(QString name)
    {
        name_ = name;
    }

    void Well::setX(double x)
    {
        x_ = x;
    }

    void Well::setY(double y)
    {
        y_ = y;
    }

    void Well::setRw(double rw)
    {
        rw_ = rw;
    }

    void Well::setH0(double h0)
    {
        h0_ = h0;
    }

    void Well::setB(double b)
    {
        b_ = b;
    }

    void Well::setDeltaB(double db)
    {
        db_ = db;
    }

    void Well::setC(double c)
    {
        c_ = c;
    }

    void Well::setDeltaC(double dc)
    {
        dc_ = dc;
    }

    void Well::setDeltaH0(double dh0)
    {
        dh0_ = dh0;
    }

    void Well::toStdUnits(LengthUnit lu, TimeUnit tu, DischargeUnit du)
    {
        x_ *= Utility::conversionFactor(lu);
        y_ *= Utility::conversionFactor(lu);
        rw_ *= Utility::conversionFactor(lu);
        h0_ *= Utility::conversionFactor(lu);
        dh0_ *= Utility::conversionFactor(lu) / Utility::conversionFactor(tu);

        double b_factor = Utility::conversionFactor(tu)
                / pow(Utility::conversionFactor(lu), 2);
        b_ *= b_factor;
        db_ *= b_factor / Utility::conversionFactor(tu);

        double c_factor = pow(Utility::conversionFactor(tu), 2)
                / pow(Utility::conversionFactor(lu), 5);
        c_ *= c_factor;
        dc_ *= c_factor / Utility::conversionFactor(tu);

        wl_.scaleT(Utility::conversionFactor(tu));
        wl_.scaleV(Utility::conversionFactor(lu));

        q_.scaleT(Utility::conversionFactor(tu));
        q_.scaleV(Utility::conversionFactor(du));

        dQ_.scaleT(Utility::conversionFactor(tu));
        dQ_.scaleV(Utility::conversionFactor(du));
    }

    void Well::fromStdUnits(LengthUnit lu, TimeUnit tu, DischargeUnit du)
    {
        x_ /= Utility::conversionFactor(lu);
        y_ /= Utility::conversionFactor(lu);
        rw_ /= Utility::conversionFactor(lu);
        h0_ /= Utility::conversionFactor(lu);
        dh0_ /= Utility::conversionFactor(lu) / Utility::conversionFactor(tu);

        double b_factor = Utility::conversionFactor(tu)
                / pow(Utility::conversionFactor(lu), 2);
        b_ /= b_factor;
        db_ /= b_factor / Utility::conversionFactor(tu);

        double c_factor = pow(Utility::conversionFactor(tu), 2)
                / pow(Utility::conversionFactor(lu), 5);
        c_ /= c_factor;
        dc_ /= c_factor / Utility::conversionFactor(tu);

        wl_.scaleT(1/Utility::conversionFactor(tu));
        wl_.scaleV(1/Utility::conversionFactor(lu));

        q_.scaleT(1/Utility::conversionFactor(tu));
        q_.scaleV(1/Utility::conversionFactor(du));

        dQ_.scaleT(1/Utility::conversionFactor(tu));
        dQ_.scaleV(1/Utility::conversionFactor(du));
    }

    void Well::clearResults()
    {
        results_["t"] = QList<double>();
        results_["h_0"] = QList<double>();
        results_["s_aq"] = QList<double>();
        results_["s_w"] = QList<double>();
        results_["wl"] = QList<double>();
    }

    void Well::deleteWindowAt(double t)
    {
        for(int i = 0; i < windows_.size(); i++) {
            double w0 = windows_[i].first;
            double wf = windows_[i].second;

            if (w0 <= t && t < wf) {
                windows_.removeAt(i);
                return;
            }
        }
    }

    void Well::appendResult(double t, double h0, double s_aq, double s_w)
    {
        results_["t"].push_back(t);
        results_["h_0"].push_back(h0);
        results_["s_aq"].push_back(s_aq);
        results_["s_w"].push_back(s_w);
        results_["wl"].push_back(h0 - s_aq - s_w);
        return;
    }

    bool Well::hasResults()
    {
        return results_["t"].length() > 0;
    }

    void Well::setResult(QString result_key, QList<double> ts)
    {
        if (results_.keys().contains(result_key)) {
            results_[result_key] = ts;
        }
    }

    QList<double> Well::result(QString result_key)
    {
        if (results_.keys().contains(result_key)) {
            return results_[result_key];
        } else {
            return QList<double>();
        }
    }

    QMap<QString, double> Well::resultsByIndex(size_t idx)
    {
        QMap<QString, double> m;
        foreach(QString key,
                QStringList() << "t" << "s_aq" << "s_w"
                              << "h0" << "wl") {
            m[key] = results_[key][idx];
        }
        return m;
    }

    double Well::wellLossAt(double t,
                            bool turbulant_well_loss,
                            bool laminar_well_loss,
                            bool transient_well_loss)
    {
        if (!turbulant_well_loss && !laminar_well_loss) {
            return 0;
        }
        double Q = q_.valueAtT(t);

        if (Utility::floatCompare(Q, 0)) {
            return 0;
        }

        double s_w = 0;
        if (turbulant_well_loss) {
            double C = cAtT(t, turbulant_well_loss, transient_well_loss);
            s_w += C*pow(Q, 2);
        }

        if (laminar_well_loss) {
            double B = bAtT(t, laminar_well_loss, transient_well_loss);
            s_w += B*Q;
        }

        return s_w;
    }

    double Well::cAtT(double t,
                      bool turbulant_well_loss,
                      bool turbulant_well_loss_transient
                      )
    {
        if (!turbulant_well_loss) {
            return 0;
        }

        if (!turbulant_well_loss_transient) {
            return c_;
        } else {
            return c_ + dc_*t;
        }
    }

    double Well::bAtT(double t, bool laminar_well_loss,
                      bool laminar_well_loss_transient)
    {
        if (!laminar_well_loss) {
            return 0;
        }

        if (!laminar_well_loss_transient) {
            return b_;
        } else {
            return b_ + db_*t;
        }
    }

    double Well::h0AtT(double t, bool h0_is_transient)
    {
        if (!h0_is_transient) {
            return h0_;
        } else {
            return h0_ + dh0_*t;
        }
    }

    void Well::setQ(Timeseries q)
    {
        q_ = q;
        dQ_ = q_.deltaValues();
        return;
    }


    double Well::distanceTo(double x, double y)
    {
        double dx = x - x_;
        double dy = y - y_;
        double r = sqrt(pow(dx, 2) + pow(dy, 2));
        return fmax(r, rw_);
    }

    double Well::distanceTo(Well &w)
    {
        return distanceTo(w.x(), w.y());
    }

    bool Well::insertWindow(double t0, double tf)
    {
        // TODO check if windows are valid
        windows_.append(QPair<double, double>(t0, tf));
        return true;
    }
}

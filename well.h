#ifndef WELL_H
#define WELL_H

#include <QString>
#include "abstractwelllossmodel.h"
#include "timeseries.h"

namespace awfm {
    class Well
    {
        QString name_; // name (must be unique)
        double x_;  // c coordinate
        double y_;  // y coordinate
        double rw_; // well radius
        double h0_; // static water level
        double dh0_; // change in static water level per year
        double c_;   // well-loss due to turbulant flow
        double dc_;  // change in C per year
        double b_;   // well-loss due to laminar flow
        double db_;  // change in B per year

        Timeseries wl_;    // observed water levels
        Timeseries q_;     // observed pumping
        Timeseries dQ_;    // delta pumping (used by aquifer drawdown models)
        Timeseries sAq_;   // modeled aquifer drawdown
        Timeseries sLoss_; // modeled well loss

        AbstractWellLossModel* wellLossModel_;
    public:
        Well(QString name, double x, double y, double rw, double h0);

        QString name() { return name_; }
        double x() { return x_; }
        double y() { return y_; }
        double rw() { return rw_; }
        double h0() { return h0_; }
        double dh0() { return dh0_; }
        double b() { return b_; }
        double c() { return c_; }
        double db() { return db_; }
        double dc() { return dc_; }

        Timeseries wl() { return wl_; }
        Timeseries q() { return q_; }
        Timeseries dQ() { return dQ_; }
        Timeseries sAq() { return sAq_; }
        Timeseries sLoss() { return sLoss_; }

        void setName(QString name);
        void setX(double x);
        void setY(double y);
        void setRw(double rw);
        void setH0(double h0);
        void setWl(Timeseries wl) { wl_ = wl; }
        void setQ(Timeseries q);
        void setSAq(Timeseries sAq) { sAq_ = sAq; }
        void setSLoss(Timeseries sLoss) { sLoss_ = sLoss; }
        void setWellLossModel(AbstractWellLossModel *m);

        double distanceTo(double x, double y);
        double distanceTo(Well &w);
    };
}
#endif // WELL_H

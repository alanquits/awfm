#include "jacobwellloss.h"
#include "jacobsimplifiedwellloss.h"
#include "well.h"

#include <cmath>

namespace awfm {
    Well::Well(QString name, double x, double y, double rw, double h0)
    {
        name_ = name;
        x_ = x;
        y_ = y;
        rw_ = rw;
        h0_ = h0;
        wellLossModel_ = new JacobSimplifiedWellLoss(0);
    }

    void Well::setQ(Timeseries q)
    {
        q_ = q;
        dQ_ = q_.deltaValues();
    }

    void Well::setWellLossModel(AbstractWellLossModel *m)
    {
        delete wellLossModel_;
        wellLossModel_ = m;
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
}

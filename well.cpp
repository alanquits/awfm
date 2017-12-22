#include "well.h"

#include <cmath>

namespace awfm {
    Well::Well(std::string name, double x, double y, double rw)
    {
        name_ = name;
        x_ = x;
        y_ = y;
        rw_ = rw;
    }

    void Well::setQ(Timeseries q)
    {
        q_ = q;
        dQ_ = q_.deltaValues();
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

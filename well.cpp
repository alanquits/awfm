#include "well.h"
#include "jacobwellloss.h"
#include "jacobsimplifiedwellloss.h"


#include <cmath>

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

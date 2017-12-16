#ifndef WELL_H
#define WELL_H

#include <string>

#include "timeseries.h"


class Well
{
    std::string name_;
    double x_;
    double y_;
    double rw_;

    Timeseries wl_; // observed water levels
    Timeseries q_;  // observed pumping
    Timeseries dQ_;
public:
    Well(std::string name, double x, double y, double rw);

    std::string name() { return name_; }
    double x() { return x_; }
    double y() { return y_; }
    double rw() { return rw_; }
    Timeseries wl() { return wl_; }
    Timeseries q() { return q_; }
    Timeseries dQ() { return dQ_; }

    void setWl(Timeseries wl) { wl_ = wl; }
    void setQ(Timeseries q);

    double distanceTo(double x, double y);
    double distanceTo(Well &w);
};

#endif // WELL_H

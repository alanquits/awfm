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
public:
    Well(std::string name, double x, double y, double rw);

    std::string name() { return name_; }
    double x() { return x_; }
    double y() { return y_; }
    double rw() { return rw_; }

    Timeseries wl() { return wl_; }
    Timeseries q() { return q_; }
};

#endif // WELL_H

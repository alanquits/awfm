#ifndef TIMESERIES_H
#define TIMESERIES_H

#include <vector>
#include "measure.h"

class Timeseries
{
private:
    std::vector<Measure> data_;
    double errorCode_;
public:
    Timeseries();

    void append(double t, double v);
    void append(double t);


    void setErrorCode(double errorCode);
    void setT(int idx, double t);
    void setV(int idx, double v);

    double t(int idx) { return data_[idx].t(); }
    double v(int idx) { return data_[idx].v(); }
    double errorCode() { return errorCode_; }
    Measure at(int idx) { return data_[idx]; }

    Timeseries absolute();
    Timeseries averageByTolerance();
    Timeseries averageWhenOn();
    Timeseries dtdv();
    Timeseries extractWindow(double tmin, double tmax);
    Timeseries projectOntoLine(double tmin, double tmax, double dt);
    Timeseries scale(double s);
    Timeseries zeroBelow();
};

#endif // TIMESERIES_H

#include "measure.h"

#include <cmath>

namespace awfm {

    Measure::Measure(double t, double v)
    {
        t_ = t;
        v_ = v;
        measureState_ = VALUE;
    }

    Measure::Measure(double t)
    {
        t_ = t;
        measureState_ = NOVALUE;
    }

    double Measure::setV(double v)
    {
        v_ = v;
    }

    void Measure::absolute()
    {
        v_ = fabs(v_);
    }

    void Measure::scale(double s)
    {
        v_ *= s;
    }

    void Measure::zeroBelow(double min_value)
    {
        v_ = fabs(v_) < min_value ? 0 : v_;
    }
}

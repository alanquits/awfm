#include "measure.h"

#include <cmath>

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
    v_ = v_ < min_value ? 0 : v_;
}

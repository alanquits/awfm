#include "measure.h"

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

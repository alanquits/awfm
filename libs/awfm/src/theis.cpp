#include "theis.h"

Theis::Theis(double S, double T)
{
    S_ = S;
    T_ = T;
}

double Theis::drawdownAtWell(Well &w, double x, double y, double t)
{
    double s = 0;
    Timeseries dQ = w.dQ();
    for (size_t i = 0; i < dQ.size(); i++) {
        if (t <= dQ.t(i)) {
            continue;
        } else {
            double r = w.distanceTo(x, y);
            double u = (pow(r, 2)*S_)/(4*T_*t);
            s += (dQ.v(i)/(4*M_PI*T_)) * W(u);
        }
    }
    return s;
}

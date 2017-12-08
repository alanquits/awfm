#include "theis.h"

Theis::Theis(double S, double T)
{
    S_ = S;
    T_ = T;
}

double Theis::drawdown(double x, double y, double t)
{
    std::vector<Timeseries> dQs;
    for (size_t i = 0; i < wells_->size(); i++) {
        dQs.push_back(wells_->at(i).q().deltaValues());
    }

    double s = 0;
    for (size_t i = 0; i < wells_->size(); i++) {
        Well w = wells_->at(i);
        double r = w.distanceTo(x, y);
        Timeseries dQs_at_well = dQs[i];
        for (size_t j = 0; j < dQs_at_well.size(); j++) {
            double t_dQ = dQs[i].t(j);
            if (t <= t_dQ) {
                continue;
            }
            double dQ = dQs_at_well.v(j);
            double dt = t - t_dQ;
            double u = (pow(r, 2)*S_)/(4*T_*dt);
            s += (dQ/(4*M_PI*T_)) * W(u);
        }
    }

    return s;
}

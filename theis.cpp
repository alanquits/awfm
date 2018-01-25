#include "theis.h"

namespace awfm {
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
                break;
            } else {
                double r = w.distanceTo(x, y);
                double dt = t - dQ.t(i);
                double u = (pow(r, 2)*S_)/(4*T_*dt);
                s += (dQ.v(i)/(4*M_PI*T_)) * W(u);
            }
        }
        return s;
    }

    void Theis::toStdUnits(LengthUnit lu, TimeUnit tu)
    {
        T_ *= pow(Utility::conversionFactor(lu), 2)
                / Utility::conversionFactor(tu);
    }

    void Theis::fromStdUnits(LengthUnit lu, TimeUnit tu)
    {
        T_ /= pow(Utility::conversionFactor(lu), 2)
                / Utility::conversionFactor(tu);
    }

}

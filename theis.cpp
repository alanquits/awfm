#include "theis.h"

namespace awfm {
    Theis::Theis(double S, double T)
    {
        S_ = S;
        T_ = T;
    }

    double Theis::drawdownAtWell(Well &w, double x, double y, double t, bool spinup)
    {


        double s = 0;
        Timeseries dQ = w.dQ();

//        bool ok_to_spinup = dQ.size() > 1;
//        double spinup_dt_offset = (dQ.t(1) - dQ.t(0))
//                + (dQ.ts().last() - dQ.ts().first());

//        if (spinup && ok_to_spinup) {
//            for (size_t i = 0; i < dQ.size(); i++) {
//                double dq_adjusted_t = dQ.t(i) - spinup_dt_offset;
//                if (t <= dq_adjusted_t) {
//                    break;
//                } else {
//                    double r = w.distanceTo(x, y);
//                    double dt = t - dq_adjusted_t;
//                    double u = (pow(r, 2)*S_)/(4*T_*dt);
//                    s += (dQ.v(i)/(4*M_PI*T_)) * W(u);
//                }
//            }
//        }

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

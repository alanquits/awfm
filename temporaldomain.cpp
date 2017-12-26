#include "temporaldomain.h"
#include <cassert>

namespace awfm {
    TemporalDomain::TemporalDomain()
    {
        setAtWells();
    }

    void TemporalDomain::setAtWells()
    {
        domainType_ = TEMPORALDOMAIN_ATWELLS;
    }

    void TemporalDomain::setArbitrary(QList<double> ts)
    {
        domainType_ = TEMPORALDOMAIN_ARBITRARY;
        ts_ = ts;
    }

    void TemporalDomain::setLinear(double t0, double tf, double dt)
    {
        assert(tf > t0);
        ts_.clear();

        double t = t0;
        while (t < tf) {
            ts_.push_back(t);
            t += dt;
        }
    }

    QList<double> TemporalDomain::ts(Well &w)
    {
        return w.wl().ts();
    }
}

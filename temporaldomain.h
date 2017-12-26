#ifndef TEMPORALDOMAIN_H
#define TEMPORALDOMAIN_H

#include <QList>
#include "well.h"

namespace awfm {
typedef enum {
    TEMPORALDOMAIN_ARBITRARY
  , TEMPORALDOMAIN_LINEAR
  , TEMPORALDOMAIN_ATWELLS
} TemporalDomainType;

class TemporalDomain {
private:
    TemporalDomainType domainType_;
    QList<double> ts_;

public:
    TemporalDomain();
    TemporalDomainType domainType() { return domainType_; }
    void setAtWells();
    void setArbitrary(QList<double> ts);
    void setLinear(double t0, double tf, double dt);

    QList<double> ts() { return ts_; }
    QList<double> ts(Well &w);

};
}

#endif // TEMPORALDOMAIN_H

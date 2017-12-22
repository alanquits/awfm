#ifndef TEMPORALDOMAIN_H
#define TEMPORALDOMAIN_H

#include <vector>
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
    std::vector<double> ts_;

public:
    TemporalDomain();
    TemporalDomainType domainType() { return domainType_; }
    void setAtWells();
    void setArbitrary(std::vector<double> ts);
    void setLinear(double t0, double tf, double dt);

    std::vector<double> ts() { return ts_; }
    std::vector<double> ts(Well &w);

};
}

#endif // TEMPORALDOMAIN_H

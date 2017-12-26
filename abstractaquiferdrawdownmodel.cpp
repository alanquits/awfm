#include "abstractaquiferdrawdownmodel.h"

namespace awfm {

    AbstractAquiferDrawdownModel::AbstractAquiferDrawdownModel()
    {

    }

    double AbstractAquiferDrawdownModel::drawdown(QList<Well> &wells,
                                                  double x, double y, double t)
    {
        double s = 0;
        for (size_t i = 0; i < wells.size(); i++) {
            s += drawdownAtWell(wells[i], x, y, t);
        }
        return s;
    }

}

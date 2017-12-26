#ifndef UTILITY_H
#define UTILITY_H

#include <cmath>
#include <QString>
#include <QList>
#include "definitions.h"

namespace awfm {
    class Utility
    {
    public:
        static bool floatCompare(double x1, double x2, double tol=1e-6);
        static double conversionFactor(LengthUnit u);
        static double conversionFactor(LengthUnit u1, LengthUnit u2);
        static double conversionFactor(DischargeUnit u);
        static double conversionFactor(DischargeUnit u1, DischargeUnit u2);
        static double conversionFactor(TimeUnit u);
        static double conversionFactor(TimeUnit u1, TimeUnit u2);
        static bool caseInsensitiveStringCompare(QString s1, QString s2);
        static QString intercalateString(QStringList strings, QString separator);

    };
}

#endif // UTILITY_H

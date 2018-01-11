#include <algorithm>
#include <QFileInfo>
#include "abstractaquiferdrawdownmodel.h"
#include "utility.h"

namespace awfm {
    bool Utility::floatCompare(double x1, double x2, double tol)
    {
        return fabs(x1 - x2) < tol;
    }

    double Utility::conversionFactor(LengthUnit u)
    {
        switch (u) {
            case FEET: return FEET_TO_STD;
            case METERS: return METERS_TO_STD;
            case YARDS: return YARDS_TO_STD;
        }
    }

    double Utility::conversionFactor(LengthUnit u1, LengthUnit u2)
    {
        return conversionFactor(u1) * (1/conversionFactor(u2));
    }

    double Utility::conversionFactor(DischargeUnit u)
    {
        switch (u) {
            case M3D: return M3D_TO_STD;
            case CFS: return CFS_TO_STD;
            case GPM: return GPM_TO_STD;
        }
    }

    double Utility::conversionFactor(DischargeUnit u1, DischargeUnit u2)
    {
        return conversionFactor(u1) * (1/conversionFactor(u2));
    }

    double Utility::conversionFactor(TimeUnit u)
    {
        switch (u) {
            case DAYS: return DAYS_TO_STD;
            case HOURS: return HOURS_TO_STD;
            case MINUTES: return MINUTES_TO_STD;
            case SECONDS: return SECONDS_TO_STD;
        }
    }

    double Utility::conversionFactor(TimeUnit u1, TimeUnit u2)
    {
        return conversionFactor(u1) * (1/conversionFactor(u2));
    }

    bool Utility::caseInsensitiveStringCompare(QString s1, QString s2)
    {
        return s1.toLower() == s2.toLower();
    }

    QString Utility::intercalateString(QStringList strings, QString separator)
    {
        QString s_out;
        bool first = true;
        for (int i = 0; i < strings.size(); i++) {
            if (first) {
                first = false;
            } else {
                s_out += separator;
            }
            s_out += strings[i];
        }

        return s_out;
    }

    QString Utility::unitAsString(LengthUnit u)
    {
        switch (u) {
        case FEET: return "feet";
        case METERS: return "meters";
        case YARDS: return "yards";
        }
    }

    QString Utility::unitAsString(TimeUnit u)
    {
        switch (u) {
        case DAYS: return "days";
        case HOURS: return "hours";
        case MINUTES: return "minutes";
        case SECONDS: return "seconds";
        }
    }

    QString Utility::unitAsString(DischargeUnit u)
    {
        switch (u) {
        case M3D: return "m3/day";
        case CFS: return "ft3/sec";
        case GPM: return "gal/min";
        }
    }

    LengthUnit Utility::lengthUnitFromString(QString str)
    {
        if (str == "feet") {
            return FEET;
        } else if (str == "meters") {
            return METERS;
        } else if (str == "yards") {
            return YARDS;
        } else {
            return METERS;
        }
    }

    TimeUnit Utility::timeUnitFromString(QString str)
    {
        if (str == "days") {
            return DAYS;
        } else if (str == "hours") {
            return HOURS;
        } else if (str == "minutes") {
            return MINUTES;
        } else if (str == "seconds") {
            return SECONDS;
        } else {
            return DAYS;
        }
    }

    DischargeUnit Utility::dischargeUnitFromString(QString str)
    {
        if (str == "m3/day") {
            return M3D;
        } else if (str == "ft3/sec") {
            return CFS;
        } else if (str == "gal/min") {
            return GPM;
        } else {
            return M3D;
        }
    }

//    AquiferDrawdownModel Utility::aquiferDrawdownModelFromString(QString str)
//    {
//        if (str == "theis") {
//            return THEIS;
//        } else if (str == "hantush-jacob") {
//            return HANTUSHJACOB;
//        } else {
//            return THEIS;
//        }
//    }

    bool Utility::fileExists(QString path)
    {
        QFileInfo fi(path);
        if (fi.exists() && fi.isFile()) {
            return true;
        } else {
            return false;
        }
    }
}

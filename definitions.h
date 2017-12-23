#ifndef DEFINITIONS_H
#define DEFINITIONS_H

namespace awfm {
    typedef enum { FEET, METERS, YARDS } LengthUnit;
    typedef enum { GPM, CFS, M3D } DischargeUnit;
    typedef enum { DAYS, HOURS, MINUTES, SECONDS } TimeUnit;

    // Length multipliers (conversions to meters)
    const double METERS_TO_STD = 1;
    const double FEET_TO_STD = 0.3048;
    const double YARDS_TO_STD = 0.9144;

    // Discharge multipliers
    const double M3D_TO_STD = 1;
    const double CFS_TO_STD = 2446.58;
    const double GPM_TO_STD = 5.45099;

    // Time multipliers
    const double DAYS_TO_STD = 1;
    const double HOURS_TO_STD = 1.0/24.0;
    const double MINUTES_TO_STD = 1.0/1440.0;
    const double SECONDS_TO_STD = 1.0/86400.0;

}
#endif

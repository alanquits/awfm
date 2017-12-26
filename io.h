#ifndef IO_H
#define IO_H

#include <iostream>
#include <fstream>
#include <QString>

#include "timeseries.h"
#include "model.h"

namespace awfm {
    Timeseries readTimeseriesFromFile(QString file_path);
    void writeTimeseriesToFile(Timeseries *ts, QString file_path);

}

#endif // IO_H

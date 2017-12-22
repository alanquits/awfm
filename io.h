#ifndef IO_H
#define IO_H

#include <iostream>
#include <fstream>
#include <string>

#include "timeseries.h"
#include "model.h"

namespace awfm {
    Timeseries readTimeseriesFromFile(std::string file_path);
    void writeTimeseriesToFile(Timeseries *ts, std::string file_path);

}

#endif // IO_H

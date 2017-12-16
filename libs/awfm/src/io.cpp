#include "io.h"


Timeseries readTimeseriesFromFile(std::string file_path)
{
    Timeseries ts;
    std::ifstream fs(file_path);

    if (fs.is_open()) {
        size_t size;
        fs >> size;
        for (size_t i = 0; i < size; i++) {
            double t, v;
            fs >> t >> v;
            ts.append(t, v);
        }

        fs.close();
    } else {
        std::cout << "Unable to open file " << file_path
                  << " for reading ";
    }

    return ts;
}

void writeTimeseriesToFile(Timeseries *ts, std::string file_path)
{
    std::ofstream fs(file_path);
    if (fs.is_open()) {
        fs << ts->size() << "\n";
        for (size_t i = 0; i < ts->size(); i++) {
            Measure m = ts->at(i);
            fs << m.t() << " " << m.v() << "\n";
        }
        fs.close();
    } else {
        std::cout << "Unable to open file " << file_path
                  << " for writing ";
    }
    return;
}

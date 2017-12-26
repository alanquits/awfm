#include "csvdataframe.h"


namespace awfm {
    CSVDataFrame::CSVDataFrame(std::__cxx11::string infile)
    {
        reader_ = new io::LineReader(infile);
    }

    CSVDataFrame::~CSVDataFrame()
    {
        delete(reader_);
    }
}

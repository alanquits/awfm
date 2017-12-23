#ifndef ABSTRACTDATAFRAME_H
#define ABSTRACTDATAFRAME_H

#include <vector>
#include <string>

namespace awfm {
    class AbstractDataFrame {
        int columns()=0;
        std::string columnName(int i)=0;
        void beginReading()=0;
        void nextRow()=0;
        std::string getString(int column_idx)=0;
        int getInt(int column_idx)=0;
        double getDouble(int column_idx)=0;
    };
}

#endif

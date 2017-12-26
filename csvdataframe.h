#ifndef CSVDATAFRAME_H
#define CSVDATAFRAME_H

#include "abstractdataframe.h"
#include "csv.h"

namespace awfm {
    class CSVDataFrame : AbstractDataFrame {

    private:
        io::LineReader *reader_;
    public:
        CSVDataFrame(QString infile);
        ~CSVDataFrame();

        virtual int columns()=0;
        virtual int columnIndex(QString);
        virtual void windUp()=0;
        virtual void nextRow()=0;
        virtual QString getString(int column_idx)=0;
        virtual int getInt(int column_idx)=0;
        virtual double getDouble(int column_idx)=0;
    };
}

#endif // CSVDATAFRAME_H

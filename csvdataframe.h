#ifndef CSVDATAFRAME_H
#define CSVDATAFRAME_H

#include "abstractdataframe.h"

#include <QTextStream>

namespace awfm {
    class CSVDataFrame : public AbstractDataFrame {

    private:

        QFile inputFile_;
        QList<QString> rowValues_;
        QTextStream *ts_;

        void setFieldNames();

    public:
        CSVDataFrame(QString file_path);
        ~CSVDataFrame();

        virtual QStringList tables();
        virtual void setTable(QString table_name);
        virtual int columnIndex(QString);
        virtual void windUp();
        virtual bool nextRow();
        virtual QString getString(int column_idx);
        virtual int getInt(int column_idx);
        virtual double getDouble(int column_idx);
        virtual bool isNull(int column_idx);
        virtual void collectFieldNames();
    };
}

#endif // CSVDATAFRAME_H

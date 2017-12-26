#ifndef ABSTRACTDATAFRAME_H
#define ABSTRACTDATAFRAME_H

#include <QList>
#include <QString>
#include <QStringList>

namespace awfm {
    class AbstractDataFrame {

    protected:
        QStringList fieldNames_;
        QString error_;

    public:
        void setError(QString error) { error_ = error; }
        QString error() { return error_; }
        bool hasError() { return error_.size() > 0; }

        virtual QStringList tables()=0;
        virtual void setTable(QString table_name)=0;
        virtual int columnIndex(QString)=0;
        virtual void windUp()=0;
        virtual bool nextRow()=0;
        virtual QString getString(int column_idx)=0;
        virtual int getInt(int column_idx)=0;
        virtual double getDouble(int column_idx)=0;
        virtual void collectFieldNames()=0;
        QStringList fieldNames() { return fieldNames_; }
    };
}

#endif

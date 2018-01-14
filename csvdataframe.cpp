#include "csvdataframe.h"
#include <QFileInfo>


namespace awfm {
void CSVDataFrame::setFieldNames()
{
    if (ts_->atEnd()) {
        setError(QString("File contains no data."));
    }
    QString line = ts_->readLine();
    fieldNames_ = line.split(",");
}

CSVDataFrame::CSVDataFrame(QString file_path)
    {
        ts_ == NULL;
        inputFile_.setFileName(file_path);
        if (inputFile_.open(QIODevice::ReadOnly))
        {
            ts_ = new QTextStream(&inputFile_);
            setFieldNames();
        } else {
            setError(QString("Unable to open file %1 for reading: %2")
                     .arg(file_path)
                     .arg(inputFile_.errorString()));
        }


    }

    CSVDataFrame::~CSVDataFrame()
    {
        if (ts_ != NULL) {
            delete ts_;
        }
        inputFile_.close();
    }

    QStringList CSVDataFrame::tables()
    {
        return QStringList() << QFileInfo(inputFile_).path();
    }

    void CSVDataFrame::setTable(QString table_name)
    {
        return;
    }

    int CSVDataFrame::columnIndex(QString field_name)
    {
        return fieldNames_.indexOf(field_name);
    }

    void CSVDataFrame::windUp()
    {
        ts_->seek(0);
        ts_->readLine();
    }

    bool CSVDataFrame::nextRow()
    {
        if (ts_->atEnd()) {
            return false;
        } else {
            QString line = ts_->readLine();
            rowValues_ = line.split(",");
            return true;
        }
    }

    QString CSVDataFrame::getString(int column_idx)
    {
        if (column_idx < rowValues_.length()) {
            return rowValues_[column_idx];
        } else {
            return "";
        }
    }

    int CSVDataFrame::getInt(int column_idx)
    {
        if (column_idx < rowValues_.length()) {
            return rowValues_[column_idx].toInt();
        } else {
            return -9999;
        }
    }

    double CSVDataFrame::getDouble(int column_idx)
    {
        if (column_idx < rowValues_.length()) {
            return rowValues_[column_idx].toDouble();
        } else {
            return -9999;
        }
    }

    bool CSVDataFrame::isNull(int column_idx)
    {
        if (column_idx < rowValues_.length()) {
            return rowValues_[column_idx].isEmpty();
        } else {
            return true;
        }
    }

    void CSVDataFrame::collectFieldNames()
    {
        // field names collected at file open. Nothing to do here.
    }
}

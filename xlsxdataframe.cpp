#include "xlsxdataframe.h"
#include <string>

namespace awfm {
    XlsxDataFrame::XlsxDataFrame(QString db_path)
    {
        const std::string file_path = db_path.toStdString();
        wb_.load(file_path);
    }

    XlsxDataFrame::~XlsxDataFrame()
    {
    }

    double XlsxDataFrame::getDouble(int column_idx)
    {
        std::string value = ws_.cell(column_idx+1, currentRow_).to_string();
        return QString().fromStdString(value).toDouble();
    }

    int XlsxDataFrame::getInt(int column_idx)
    {
        std::string value = ws_.cell(column_idx+1, currentRow_).to_string();
        return QString().fromStdString(value).toInt();
    }

    QString XlsxDataFrame::getString(int column_idx)
    {
        std::string value = ws_.cell(column_idx+1, currentRow_).to_string();
        return QString().fromStdString(value);
    }

    bool XlsxDataFrame::nextRow()
    {
        currentRow_++;
        if (currentRow_ == ws_.rows().length()+1) {
            return false;
        } else {
            return true;
        }
    }

    void XlsxDataFrame::windUp()
    {
        currentRow_ = 1;
    }

    int XlsxDataFrame::columnIndex(QString field_name_to_match)
    {
        return fieldNames_.indexOf(field_name_to_match);
    }

    void XlsxDataFrame::collectFieldNames()
    {
        fieldNames_.clear();
        for (int col = 0; col < ws_.columns().length(); col++) {
            std::string cell_value = ws_.cell(col+1, 0+1).to_string();
            fieldNames_.push_back(QString().fromStdString(cell_value));
        }
    }

    void XlsxDataFrame::setTable(QString table_name)
    {
        ws_ = wb_.sheet_by_title(table_name.toStdString());
        collectFieldNames();
    }

    QStringList XlsxDataFrame::tables()
    {
        QStringList tables;
        foreach(std::string sheet_name, wb_.sheet_titles()) {
            tables.push_back(QString().fromStdString(sheet_name));
        }
        return tables;
    }
}

#ifndef SQLITEDATAFRAME_H
#define SQLITEDATAFRAME_H


#include <QString>
#include "abstractdataframe.h"
#include "sqlite3.h"

namespace awfm {
    class SQLiteDataframe : public AbstractDataFrame {
    private:
        sqlite3* db_;
        sqlite3_stmt* stmt_;
        QString tableName_;

    public:
        SQLiteDataframe(QString db_path);
        ~SQLiteDataframe();

        QString tableName() { return tableName_; }
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

#endif //SQLITEDATAFRAME_H

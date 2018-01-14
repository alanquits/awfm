#include "sqlitedataframe.h"
#include "utility.h"

namespace awfm {
    SQLiteDataframe::SQLiteDataframe(QString db_path)
    {
        int rc = sqlite3_open(db_path.toLatin1().data(), &db_);
        if (rc != SQLITE_OK) {
            setError("SQL Error: " + QString(sqlite3_errmsg(db_)));
            return;
        }
    }

    SQLiteDataframe::~SQLiteDataframe()
    {
        sqlite3_close(db_);
    }

    void SQLiteDataframe::setTable(QString table_name)
    {
        tableName_ = table_name;
        collectFieldNames();
    }

    QStringList SQLiteDataframe::tables()
    {
        QStringList tables;
        sqlite3_stmt* stmt;
        const char *sql = "SELECT name FROM sqlite_master where type='table'";
        int rc = sqlite3_prepare_v2(db_, sql, -1, &stmt, NULL);
        if (rc == SQLITE_OK) {
            while(sqlite3_step(stmt) == SQLITE_ROW) {
                tables.append(reinterpret_cast<const char*>(sqlite3_column_text(stmt, 0)));
            }
        } else {
            setError(QString("SQL Error: " + QString(sqlite3_errmsg(db_))));
        }

        sqlite3_finalize(stmt);
        return tables;
    }

    int SQLiteDataframe::columnIndex(QString col_name)
    {
        for (int i = 0; i < fieldNames_.size(); i++) {
            if (Utility::caseInsensitiveStringCompare(fieldNames_[i], col_name)) {
                return i;
            }
        }
        return -1;
    }

    void SQLiteDataframe::collectFieldNames()
    {
        fieldNames_.clear();
        sqlite3_stmt *stmt;
        QString sql = "pragma table_info ('" + tableName_ + "')";
        int rc = sqlite3_prepare_v2(db_, sql.toLatin1().data(), -1, &stmt, NULL);
        if (rc == SQLITE_OK) {
            while(sqlite3_step(stmt) == SQLITE_ROW) {
                fieldNames_.push_back(reinterpret_cast<const char*>(sqlite3_column_text(stmt, 1)));
            }
        }
        sqlite3_finalize(stmt);
    }

    double SQLiteDataframe::getDouble(int column_idx)
    {
        return sqlite3_column_double(stmt_, column_idx);
    }

    bool SQLiteDataframe::isNull(int column_idx)
    {
        return sqlite3_column_type(stmt_, column_idx) == SQLITE_NULL;
    }

    int SQLiteDataframe::getInt(int column_idx)
    {
        return sqlite3_column_int(stmt_, column_idx);
    }

    QString SQLiteDataframe::getString(int column_idx)
    {
        return QString(reinterpret_cast<const char*>
                           (sqlite3_column_text(stmt_, column_idx)));
    }

    bool SQLiteDataframe::nextRow()
    {
        return sqlite3_step(stmt_) == SQLITE_ROW;
    }

    void SQLiteDataframe::windUp()
    {
        QString sql = "select "
                + fieldNames_.join(',')
                + " from " + tableName_;
        int rc = sqlite3_prepare_v2(db_, sql.toLatin1().data(), -1, &stmt_, NULL);
        if (rc != SQLITE_OK) {
            setError("An error has occurred in query: " + QString(sqlite3_errmsg(db_)));
        }
    }
}

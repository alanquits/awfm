#include <fstream>
#include <iostream>
#include <QTextStream>
#include "dbio.h"

namespace awfm {
    void DBIO::open(QString db_path, bool *ok)
    {
        int rc = sqlite3_open(db_path.toLatin1().data(), &db_);
        if (rc != SQLITE_OK) {
            //fprintf(stderr, "Cannot open database: %s\n", sqlite3_errmsg(db));
            sqlite3_close(db_);
            *ok = false;
        }
        *ok = true;
    }

    QStringList DBIO::tables(bool *ok)
    {
        QStringList tables;
        sqlite3_stmt* stmt;
        const char *sql = "SELECT name FROM sqlite_master where type='table'";
        int rc = sqlite3_prepare_v2(db_, sql, -1, &stmt, NULL);
        if (rc == SQLITE_OK) {
            char *table_name;
            QString table_name_qstr;
            while(sqlite3_step(stmt) == SQLITE_ROW) {
                tables.append(reinterpret_cast<const char*>(sqlite3_column_text(stmt, 0)));
            }
            *ok = true;
        } else {
            *ok = false;
        }

        sqlite3_finalize(stmt);

        return tables;
    }

    QList<Well> DBIO::getWells(bool *ok)
    {
        QList<Well> wells;
        sqlite3_stmt *res;
        const char *sql = "select name, x, y, rw, h0 from wells";

        int rc = sqlite3_prepare_v2(db_, sql, -1, &res, 0);
        if (rc == SQLITE_OK) {
            *ok = true;
            while (sqlite3_step(res) == SQLITE_ROW) {
                QString name = reinterpret_cast<const char*>(sqlite3_column_text(res, 0));
                double x = sqlite3_column_double(res, 1);
                double y = sqlite3_column_double(res, 2);
                double rw = sqlite3_column_double(res, 3);
                double h0 = sqlite3_column_double(res, 4);
                Well w = Well(name, x, y, rw, h0);
                wells.push_back(w);
            }
        } else {
            //fprintf(stderr, "Failed to execute statement: %s\n", sqlite3_errmsg(db));
            *ok = false;
        }

        sqlite3_finalize(res);
        return wells;
    }

    void DBIO::readPumpingRatesIntoWells(QList<Well> &ws)
    {
        for (int i = 0; i < ws.size(); i++) {
            QString name = ws[i].name();
            // TODO
        }
    }

    void DBIO::close()
    {
        sqlite3_close(db_);
    }

    void DBIO::createBlank(bool *ok)
    {
        QString infile = "/home/alan/Dev/awfm/awfm/resources/create_db.sql";
        QFile f(infile);
        if (!f.open(QFile::ReadOnly | QFile::Text)) {
            *ok = false;
            return;
        }

        QTextStream in(&f);
        QString sql = in.readAll();

        char *err_msg;
        int rc = sqlite3_exec(db_, sql.toLatin1().data(), 0, 0, &err_msg);

        if (rc != SQLITE_OK ) {
            fprintf(stderr, "SQL error: %s\n", err_msg);
            sqlite3_free(err_msg);
            *ok = false;
        }

        *ok = true;
    }

    DBIO::DBIO()
    {

    }
}

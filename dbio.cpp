#include <fstream>
#include <iostream>
#include "dbio.h"

namespace awfm {
    void DBIO::open(std::string db_path, bool *ok)
    {
        int rc = sqlite3_open(db_path.c_str(), &db_);
        if (rc != SQLITE_OK) {
            //fprintf(stderr, "Cannot open database: %s\n", sqlite3_errmsg(db));
            sqlite3_close(db_);
            *ok = false;
        }
        *ok = true;
    }

    std::vector<Well> DBIO::getWells(bool *ok)
    {
        std::vector<Well> wells;
        sqlite3_stmt *res;
        const char *sql = "select name, x, y, rw, h0 from wells";

        int rc = sqlite3_prepare_v2(db_, sql, -1, &res, 0);
        if (rc == SQLITE_OK) {
            *ok = true;
            while (sqlite3_step(res) == SQLITE_ROW) {
                std::string name = reinterpret_cast<const char*>(sqlite3_column_text(res, 0));
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

    void DBIO::readPumpingRatesIntoWells(std::vector<Well> &ws)
    {
        for (int i = 0; i < ws.size(); i++) {
            std::string name = ws[i].name();
            // TODO
        }
    }

    void DBIO::close()
    {
        sqlite3_close(db_);
    }

    void DBIO::createBlank(bool *ok)
    {
        std::string infile = "/home/alan/Dev/awfm/awfm/resources/create_db.sql";
        std::ifstream t(infile);
        t.seekg(0, std::ios::end);
        size_t size = t.tellg();
        std::string sql(size, ' ');
        t.seekg(0);
        t.read(&sql[0], size);

        char *err_msg;
        int rc = sqlite3_exec(db_, sql.c_str(), 0, 0, &err_msg);

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

#ifndef DBIO_H
#define DBIO_H

#include "model.h"
#include "well.h"
#include "sqlite3.h"

namespace awfm {
    class DBIO {
    private:
        sqlite3 *db_;

    public:
        DBIO();

        Model toModel(std::string db_path);
        void toDatabase(std::string db_path, Model &m);

        void open(std::string db_path, bool *ok);
        std::vector<Well> getWells(bool *ok);
        void readPumpingRatesIntoWells(std::vector<Well> &ws);
        void close();
        void createBlank(bool *ok);
    };
}

#endif

#ifndef DBIO_H
#define DBIO_H

#include <QList>
#include <QString>
#include <QStringList>
#include "model.h"
#include "well.h"
#include "sqlite3.h"

namespace awfm {
    class DBIO {
    private:
        sqlite3 *db_;

    public:
        DBIO();

        sqlite3* db() { return db_; }

        Model toModel(QString db_path);
        void toDatabase(QString db_path, Model &m);

        void open(QString db_path, bool *ok);
        QStringList tables(bool *ok);
        QList<Well> getWells(bool *ok);
        void readPumpingRatesIntoWells(QList<Well> &ws);
        void close();
        void createBlank(bool *ok);
    };
}

#endif

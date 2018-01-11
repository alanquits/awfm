#ifndef MODELIO_H
#define MODELIO_H

#include <QString>

#include "model.h"

namespace awfm {
    class ModelIO {
    public:
        // Input functions
        static bool load(Model *model, QString file_path, QString *err_msg);
        static bool getTheisParameters(double &S, double &T, QString *err_msg);
        static bool loadSettings(Model *model, QString *err_msg);
        static bool loadWells(Model *model, QString *err_msg);

        // Output functions
        static bool save(Model *model, QString file_path, QString *err_msg);
        static bool setStaticVar(QString table_name, QString field_name, QString value, QString *err_msg);
        static bool setStaticVar(QString table_name, QString field_name, double value, QString *err_msg);
        static bool setAquiferDrawdownParameter(QString shortname, double value, QString *err_msg);
        static bool insertWells(Model* model, QString *err_msg);
    };
}

#endif // MODELIO

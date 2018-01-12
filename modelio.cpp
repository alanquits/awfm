#include "abstractaquiferdrawdownmodel.h"
#include "modelio.h"
#include "resources/create_db.h"
#include "utility.h"
#include "theis.h"
#include "well.h"

#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>

namespace awfm {
bool ModelIO::load(Model *model, QString file_path, QString *err_msg)
{
    *model = Model();
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(file_path);
    if (!db.open()) {
        *err_msg = QString("Failed to open file %1 for reading.\n"
                           "Do you have permissions to read from this location?")
                   .arg(file_path);
        return false;
    }
    if (!loadSettings(model, err_msg)) {
        return false;
    }
    if (!loadWells(model, err_msg)) {
        return false;
    }
}

bool ModelIO::getTheisParameters(double &S, double &T, QString *err_msg)
{
    QSqlQuery qry;
    qry.prepare("select shortname, value "
                "from aquifer_drawdown_model_parameters ");
    while (qry.next()) {
        QString shortname = qry.value(0).toString();
        double value = qry.value(1).toDouble();
        if (shortname == "S") {
            S = value;
        } else if (shortname == "T") {
            T = value;
        }
    }

    if (qry.lastError().isValid()) {
        *err_msg = QString("Sql Error: %1").arg(qry.lastError().text());
        return false;
    }
    return true;
}

bool ModelIO::loadSettings(Model *model, QString *err_msg)
{
    QSqlQuery qry;
    qry.prepare("select length_unit, time_unit, discharge_unit, aquifer_drawdown_model "
                "from settings");
    qry.exec();
    while (qry.next()) {
        LengthUnit length_unit = Utility::lengthUnitFromString(qry.value(0).toString());
        model->setLengthUnit(length_unit);

        TimeUnit time_unit = Utility::timeUnitFromString(qry.value(1).toString());
        model->setTimeUnit(time_unit);

        DischargeUnit discharge_unit = Utility::dischargeUnitFromString(qry.value(2).toString());
        model->setDischargeUnit(discharge_unit);

        QString aquifer_drawdown_model_str = qry.value(3).toString();
        if (aquifer_drawdown_model_str == "theis") {
            double S, T;
            if (!getTheisParameters(S, T, err_msg)) {
                return false;
            }
            model->setAquiferDrawdownModel(new Theis(S, T));
        } else if (aquifer_drawdown_model_str == "hantush-jacob") {
            // TODO
        } else {
            *err_msg =
                    QString("Aquifer drawdown model %1 is not recognized.")
                    .arg(aquifer_drawdown_model_str);
            return false;
        }
    }
    return true;
}

bool ModelIO::loadWells(Model *model, QString *err_msg)
{
    QList<Well> wells;
    QSqlQuery qry;
    qry.prepare(
        "select name, x, y, rw, h0, well_loss_model "
        "from wells order by name");
    qry.exec();
    while (qry.next()) {
        QString name = qry.value(0).toString();
        double x = qry.value(1).toDouble();
        double y = qry.value(2).toDouble();
        double rw = qry.value(3).toDouble();
        double h0 = qry.value(4).toDouble();
        QString well_loss_model = qry.value(5).toString();
        wells.append(Well(name, x, y, rw, h0));
        // TODO get well loss model
    }

    if (qry.lastError().isValid()) {
        *err_msg = QString("Sql Error: %1").arg(qry.lastError().text());
        return false;
    }
    model->setWells(wells);
    return true;
}

bool ModelIO::save(Model *model, QString file_path, QString *err_msg)
    {
        QSqlError err;
        QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
        db.setDatabaseName(file_path);
        if (!db.open()) {
            *err_msg = QString("Failed to open file %1 for writing.\n"
                               "Do you have permissions to write at this location?")
                       .arg(file_path);
            return false;
        }

        QSqlQuery qry;
        foreach(QString cmd, CREATE_DB_DEFINITION.split(";")) {
            qry.prepare(cmd);
            qry.exec();
        }

        if (qry.lastError().isValid()) {
            *err_msg = QString("Sql Error: %1")
                    .arg(qry.lastError().text());
            return false;
        }

        // write model settings
        if (!setStaticVar("settings", "length_unit",
            awfm::Utility::unitAsString(model->lengthUnit()), err_msg))
        { return false; }

        if (!setStaticVar("settings", "time_unit",
            awfm::Utility::unitAsString(model->timeUnit()), err_msg))
        { return false; }

        if (!setStaticVar("settings", "length_unit",
                          awfm::Utility::unitAsString(model->dischargeUnit()), err_msg))
        { return false; }

        if (!setStaticVar("settings", "aquifer_drawdown_model",
            model->aquiferDrawdownModel()->modelTypeAsString(), err_msg))
        { return false; }


        // write aquifer model parameters
        if (model->aquiferDrawdownModel()->modelType() == THEIS) {
            Theis *dd_model = (Theis*) model->aquiferDrawdownModel();
            if (!setAquiferDrawdownParameter("S", dd_model->S(), err_msg)
             || !setAquiferDrawdownParameter("T", dd_model->T(), err_msg)) {
                    return false;
            }
        } else if (model->aquiferDrawdownModel()->modelType() == HANTUSHJACOB) {
            // TODO
        }

        if (!insertWells(model, err_msg)) {
            return false;
        }

        if (qry.lastError().isValid()) {
            *err_msg = QString("Sql Error: %1").arg(qry.lastError().text());
            return false;
        }

        db.close();
        return true;
    }

    bool ModelIO::setStaticVar(QString table_name, QString field_name,
                               QString value, QString *err_msg)
    {
        QSqlQuery qry;
        qry.prepare(QString("update %1 set %2=?")
                    .arg(table_name).arg(field_name));
        qry.addBindValue(value);
        qry.exec();

        if (qry.lastError().isValid()) {
            *err_msg = QString("Sql Error: %1").arg(qry.lastError().text());
            return false;
        }

        return true;
    }

    bool ModelIO::setAquiferDrawdownParameter(QString shortname, double value, QString *err_msg)
    {
        QSqlQuery qry;
        qry.prepare(
            QString("update aquifer_drawdown_model_parameters "
                    "set value=? "
                    "where shortname='%1'").arg(shortname));
        qry.addBindValue(value);
        qry.exec();

        if (qry.lastError().isValid()) {
            *err_msg = QString("Sql Error: %1").arg(qry.lastError().text());
            return false;
        }

        return true;
    }

    bool ModelIO::insertWells(Model *model, QString *err_msg)
    {
        QList<Well> ws = model->wells();
        QSqlQuery qry;
        qry.prepare(
            "insert into wells "
            "(name, x, y, rw, h0, well_loss_model) "
            "values"
            "(?, ?, ?, ?, ?, ?)");
        foreach(Well w, ws) {
            QString name = w.name();
            double x = w.x();
            double y = w.y();
            double rw = w.rw();
            double h0 = w.h0();
            QString well_loss_model = w.wellLossModel()->modelTypeAsString();

            qry.prepare(
                "insert into wells "
                "(name, x, y, rw, h0, well_loss_model) "
                "values"
                "(?, ?, ?, ?, ?, ?)");
            qry.addBindValue(name);
            qry.addBindValue(x);
            qry.addBindValue(y);
            qry.addBindValue(rw);
            qry.addBindValue(h0);
            qry.addBindValue(well_loss_model);
            qry.exec();
        }

        if (qry.lastError().isValid()) {
            *err_msg = QString("Sql Error: %1").arg(qry.lastError().text());
            return false;
        }

        return true;
    }
}

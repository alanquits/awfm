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
    if (!loadPumpingRates(model, err_msg)) {
        return false;
    }
}

bool ModelIO::getTheisParameters(double &S, double &T, QString *err_msg)
{
    QSqlQuery qry;
    qry.prepare("select name, value "
                "from aquifer_drawdown_model_parameters ");
    while (qry.next()) {
        QString name = qry.value(0).toString();
        double value = qry.value(1).toDouble();
        if (name == "S") {
            S = value;
        } else if (name == "T") {
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
        "select name, x, y, rw, h0, dh0, b, db, c, dc "
        "from wells order by name");
    qry.exec();
    while (qry.next()) {
        QString name = qry.value(0).toString();
        double x = qry.value(1).toDouble();
        double y = qry.value(2).toDouble();
        double rw = qry.value(3).toDouble();
        double h0 = qry.value(4).toDouble();
        double dh0 = qry.value(5).toDouble();
        double b = qry.value(6).toDouble();
        double db = qry.value(7).toDouble();
        double c = qry.value(8).toDouble();
        double dc = qry.value(9).toDouble();
        Well w = Well(name, x, y, rw, h0);
        w.setDeltaH0(dh0);
        w.setB(b);
        w.setDeltaB(db);
        w.setC(c);
        w.setDeltaC(dc);
        wells.append(w);
    }

    if (qry.lastError().isValid()) {
        *err_msg = QString("Sql Error: %1").arg(qry.lastError().text());
        return false;
    }
    model->setWells(wells);
    return true;
}

bool ModelIO::loadPumpingRates(Model *model, QString *err_msg)
{
    QMap<QString, Timeseries> ts_map;    // Map from well name to time series

    QSqlQuery qry;
    qry.prepare(
        "select well, t, v "
        "from pumping_rates "
        "order by well, t");

    qry.exec();
    while (qry.next()) {
        QString well_name = qry.value(0).toString();
        double t = qry.value(1).toDouble();
        double v = qry.value(2).toDouble();
        if (!ts_map.contains(well_name)) {
            ts_map[well_name] = Timeseries();
        }
        ts_map[well_name].append(t, v);
    }

    for (int i = 0; i < (model->wellsRef()->length()); i++) {
        Well *w = model->wellRef(i);
        if (ts_map.contains(w->name())) {
            w->setQ(ts_map[w->name()]);
        }
    }

    if (qry.lastError().isValid()) {
        *err_msg = QString("Sql Error: %1").arg(qry.lastError().text());
        return false;
    }

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

        QStringList options = QStringList()
                << "well_loss_turbulant_on"
                << "well_loss_laminar_on"
                << "well_loss_transient_on"
                << "h0_transient_on";

        foreach(QString option, options) {
            if(!setStaticVar("settings", "well_loss_turbulant_on",
                             model->isOptionOn(option), err_msg)) {
                return false;
            }
        }


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

    bool ModelIO::setStaticVar(QString table_name, QString field_name,
                               bool value, QString *err_msg)
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
                    "where name='%1'").arg(shortname));
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
        QSqlDatabase::database().transaction();
        QList<Well> ws = model->wells();
        QSqlQuery qry;


        foreach(Well w, ws) {
            qry.prepare(
                "insert into wells "
                "(name, x, y, rw, h0, dh0, b, db, c, dc) "
                "values"
                "(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            qry.addBindValue(w.name());
            qry.addBindValue(w.x());
            qry.addBindValue(w.y());
            qry.addBindValue(w.rw());
            qry.addBindValue(w.h0());
            qry.addBindValue(w.dh0());
            qry.addBindValue(w.b());
            qry.addBindValue(w.db());
            qry.addBindValue(w.c());
            qry.addBindValue(w.dc());
            qry.exec();


            qry.prepare(
                "insert into pumping_rates "
                "(well, t, v) "
                "values "
                "(?, ?, ?)");
            Timeseries q = w.q();
            for (int i = 0; i < q.size(); i++) {
                double t = q.t(i);
                double v = q.v(i);
                qry.addBindValue(w.name());
                qry.addBindValue(t);
                qry.addBindValue(v);
                qry.exec();
            }
        }

        QSqlDatabase::database().commit();
        if (qry.lastError().isValid()) {
            *err_msg = QString("Sql Error: %1").arg(qry.lastError().text());
            return false;
        }

        return true;
    }
}

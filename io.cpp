#include <QDebug>
#include <QIODevice>
#include <QTextStream>
#include "io.h"

namespace awfm {

    Timeseries readTimeseriesFromFile(QString file_path)
    {
        Timeseries ts;

        QFile file(file_path);
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
            return ts;

        QTextStream in(&file);

        size_t size;
        in >> size;

        while (!in.atEnd()) {
            double t, v;
            in >> t >> v;
            ts.append(t, v);
        }

        file.close();
        return ts;
    }

    void writeTimeseriesToFile(Timeseries *ts, QString file_path)
    {
        QFile file(file_path);
        if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            qDebug() << "Unable to open file " << file_path
                      << " for writing ";
            return;
        }

        QTextStream out(&file);

        out << ts->size() << "\n";
        for (size_t i = 0; i < ts->size(); i++) {
            Measure m = ts->at(i);
            out << m.t() << " " << m.v() << "\n";
        }

        file.close();
        return;
    }
}

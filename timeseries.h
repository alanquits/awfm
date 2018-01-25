#ifndef TIMESERIES_H
#define TIMESERIES_H

#include <cstdlib>
#include <QString>
#include <QList>
#include "measure.h"
#include "utility.h"

namespace awfm {
    class Timeseries
    {
    private:
        QList<Measure> data_;
        double errorCode_;
    public:
        Timeseries();

        bool append(double t, double v);
        bool append(double t);
        bool append(Measure m);

        void debugToConsole();

        void readFromFile(QString file_path);
        void writeToFile(QString file_path);

        void setErrorCode(double errorCode);
        void setT(int idx, double t);
        void setV(int idx, double v);

        QList<Measure> data() { return data_; }
        double t(int idx) { return data_[idx].t(); }
        QList<double> ts();
        QList<double> vs();
        double v(int idx) { return data_[idx].v(); }
        double errorCode() { return errorCode_; }
        Measure at(int idx) { return data_[idx]; }
        size_t size() { return data_.size(); }

        /* Methods return a new Timeseries object when they extract
         * a subsection from the Timeseries. Otherwise, the object itself
         * is modified and returns void */
        void absolute();
        void averageByTolerance();
        void averageBySign();
        void consolidateZeros();
        Timeseries deltaValues();
        void dtdv();
        bool isEqual(Timeseries &ts, double tol=1e-6);
        double min();
        double max();
        double minT();
        double maxT();
        double minV();
        double maxV();
        double linearInterpolateValueAtTime(double t);
        Timeseries projectOntoLine(double tmin, double tmax, double dt);
        void removeByValue(double v);
        void interpolateOverValue(double v);
        void scale(double s);
        void scaleT(double s);
        void scaleV(double s);
        void translateT(double dt);
        void translateV(double dv);
        void setMinValue(double v);
        void setMaxValue(double v);
        void setMinMagnitude(double v);
        int sign(int idx);
        void signChanges(QList<int> *idxs, QList<int> *signs);
        Timeseries slice(size_t start_idx, size_t end_idx);
        Timeseries sliceByTime(double tmin, double tmax);
        double valueMean();
        double valueMedian();
        void zeroBelow(double min_value);
        double valueAtT(double t);
    };
}
#endif // TIMESERIES_H

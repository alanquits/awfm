#include "timeseries.h"
//#include "io.h"

#include <cassert>
#include <QDebug>

namespace awfm {
    Timeseries::Timeseries()
    {
        errorCode_ = -999999;
    }

    bool Timeseries::append(double t, double v)
    {
        return append(Measure(t, v));
    }

    bool Timeseries::append(double t)
    {
        return append(Measure(t));
    }

    bool Timeseries::append(Measure m)
    {
        if (data_.size() > 0) {
            if (m.t() > data_.back().t()) {
                data_.push_back(m);
                return true;
            } else {
                return false;
            }
        } else {
            data_.push_back(m);
            return true;
        }

    }

//    void Timeseries::readFromFile(QString file_path)
//    {
//        Timeseries ts = readTimeseriesFromFile(file_path);
//        data_ = ts.data();
//    }

//    void Timeseries::writeToFile(QString file_path)
//    {
//        writeTimeseriesToFile(this, file_path);
//    }

    QList<double> Timeseries::ts()
    {
        QList<double> ts;
        for (int i = 0; i < size(); i++) {
            ts.push_back(t(i));
        }
        return ts;
    }

    QList<double> Timeseries::vs()
    {
        QList<double> vs;
        for (int i = 0; i < size(); i++) {
            vs.push_back(v(i));
        }
        return vs;
    }

    void Timeseries::absolute()
    {
        for (size_t i = 0; i < data_.size(); i++) {
            data_[i].absolute();
        }
    }

    void Timeseries::averageBySign()
    {
        if (data_.size() == 0) {
            return;
        }

        QList<Measure> data_new;
        QList<int> idxs;
        QList<int> signs;
        signChanges(&idxs, &signs);

        for (size_t i = 1; i < idxs.size(); i++) {
            int start_idx = idxs[i-1];
            int end_idx = idxs[i];
            Timeseries ts_slice = slice(start_idx, end_idx);
            double v_mean = ts_slice.valueMean();
            Measure m = Measure(t(start_idx), v_mean);
            data_new.push_back(m);
        }

        // Pick up final block of values
        Timeseries ts_slice = slice(idxs.back(), data_.size());
        double v_mean = ts_slice.valueMean();
        Measure m = Measure(t(idxs.back()), v_mean);
        data_new.push_back(m);

        data_ = data_new;
    }

    void Timeseries::consolidateZeros()
    {
        if (data_.size() == 0) {
            return;
        }

        QList<Measure> data_new;
        data_new.push_back(data_[0]);
        bool reading_zeros = data_[0].v() == 0;

        for (size_t i = 1; i < data_.size(); i++) {
            if (data_[i].v() == 0 && reading_zeros) {
                continue;
            }
            reading_zeros = data_[i].v() == 0;
            data_new.push_back(data_[i]);
        }

        data_ = data_new;
    }

    Timeseries Timeseries::deltaValues()
    {
        Timeseries ts;
        if (size() == 0) {
            return ts;
        }

        if (size() == 1) {
            ts.append(t(0), v(0));
            return ts;
        }

        ts.append(data_[0]);
        for (size_t i = 1; i < size(); i++) {
            double dv = data_[i].v() - data_[i-1].v();
            ts.append(data_[i].t(), dv);
        }

        return ts;
    }

    bool Timeseries::isEqual(Timeseries &ts, double tol)
    {
        if (size() == ts.size()) {
            for (size_t i = 0; i < size(); i++) {
                bool t_equal = Utility::floatCompare(t(i), ts.t(i), tol);
                bool v_equal = Utility::floatCompare(v(i), ts.v(i), tol);
                if (!t_equal || !v_equal) {
                    return false;
                }
            }
        } else {
            return false;
        }
        return true;
    }

    double Timeseries::linearInterpolateValueAtTime(double t)
    {
        assert(data_.size() > 2);
        assert(this->t(0) <= t && t <= this->t(data_.size()-1));

        for (size_t i = 1; i < data_.size(); i++) {
            double t_final = this->t(i);
            double t_start = this->t(i-1);

            if (t_start <= t && t <= t_final) {
                double v_start = v(i-1);
                double v_final = v(i);
                double slope = (v_final - v_start)/(t_final-t_start);
                return v_start + slope*(t - t_start);
            }
        }
        // Function should never reach this point
        assert(false);
        return 0;
    }

    void Timeseries::scale(double s)
    {
        for (size_t i = 0; i < data_.size(); i++) {
            data_[i].scale(s);
        }
    }

    int Timeseries::sign(int idx)
    {
        double v = at(idx).v();
        if (v == 0) {
            return 0;
        } else if (v > 0) {
            return 1;
        } else { // (v < 0)
            return -1;
        }
    }

    void Timeseries::signChanges(QList<int> *idxs, QList<int> *signs)
    {
        idxs->clear();
        signs->clear();
        if (data_.size() == 0) {
            return;
        }

        int current_sign = sign(0);
        idxs->push_back(0);
        signs->push_back(current_sign);

        for (size_t i = 0; i < data_.size(); i++) {
            if (sign(i) != current_sign) {
                current_sign = sign(i);
                idxs->push_back(i);
                signs->push_back(current_sign);
            }
        }
    }

    Timeseries Timeseries::slice(size_t start_idx, size_t end_idx)
    {
        Timeseries ts;
        for (size_t i = start_idx; i < end_idx; i++) {
            ts.append(at(i));
        }
        return ts;
    }

    Timeseries Timeseries::sliceByTime(double tmin, double tmax)
    {
        Timeseries ts;
        for (size_t i = 0; i < data_.size(); i++) {
            Measure m = at(i);
            double t = m.t();
            if (tmin <= t && t < tmax) {
                ts.append(m);
            }
        }
        return ts;
    }

    double Timeseries::valueMean()
    {
        assert(data_.size() > 0);
        double sum = 0;
        for (size_t i = 0; i < data_.size(); i++) {
            sum += data_[i].v();
        }
        return sum/data_.size();
    }

    void Timeseries::zeroBelow(double min_value)
    {
        for (size_t i = 0; i < data_.size(); i++) {
            data_[i].zeroBelow(min_value);
        }
    }
}

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

    double Timeseries::bandwidth()
    {
        return maxV() - minV();
    }

    void Timeseries::pop()
    {
        data_.pop_back();
    }

    void Timeseries::debugToConsole()
    {
        for (int i = 0; i < data_.size(); i++) {
            qDebug() << data_[i].t() << " " << data_[i].v() << "\n";
        }
        qDebug() << "\n\n";
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

    void Timeseries::averageByBandwidth(double max_bandwidth)
    {
        if (data_.size() <= 1) {
            return;
        }

        QList<awfm::Measure> data_new;
        Timeseries ts_partial;

        for (int i = 0; i < data_.size(); i++) {
            ts_partial.append(t(i), v(i));
            if (ts_partial.bandwidth() > max_bandwidth) {
                ts_partial.pop();
                double t_part = ts_partial.t(0);
                double v_part = ts_partial.valueMean();
                data_new.append(Measure(t_part, v_part));

                ts_partial = Timeseries();
                ts_partial.append(t(i), v(i));
            }
        }
        double t_part = ts_partial.t(0);
        double v_part = ts_partial.valueMean();
        data_new.append(Measure(t_part, v_part));

        data_ = data_new;
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

    double Timeseries::min()
    {
        if (size() == 0) {
            assert(false);
        }
        double current_min = data_[0].v();
        foreach(Measure m, data_) {
            current_min = fmin(current_min, m.v());
        }
        return current_min;
    }

    double Timeseries::max()
    {
        if (size() == 0) {
            assert(false);
        }
        double current_max = data_[0].v();
        foreach(Measure m, data_) {
            current_max = fmax(current_max, m.v());
        }
        return current_max;
    }

    double Timeseries::minT()
    {
        if (size() == 0) {
            assert(false);
        }
        double current_min = data_[0].t();
        foreach(Measure m, data_) {
            current_min = fmin(current_min, m.t());
        }
        return current_min;
    }

    double Timeseries::maxT()
    {
        if (size() == 0) {
            assert(false);
        }
        double current_max = data_[0].t();
        foreach(Measure m, data_) {
            current_max = fmax(current_max, m.t());
        }
        return current_max;
    }

    double Timeseries::minV()
    {
        return this->min();
    }

    double Timeseries::maxV()
    {
        return this->max();
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

    Timeseries Timeseries::projectOntoLine(double tmin, double tmax, double dt)
    {
        Timeseries ts_projected;
        if (size() < 2) {
            return ts_projected;
        }

        int data_idx = 1;
        int loop_idx = 0;
        double current_time = tmin;
        while(current_time < tmax) {
            current_time = tmin + loop_idx*dt;
            if (current_time < data_[0].t()) {
                loop_idx += 1;
                continue;
            }

            if (current_time > data_.last().t()) {
                current_time = tmax+1; // break out of while loop
                break;
            }

            for (; data_idx < data_.size();) {
                double prev_t = data_[data_idx-1].t();
                double next_t = data_[data_idx].t();
                if (prev_t <= current_time && current_time < next_t) {
                    double dt = next_t - prev_t;
                    double prev_v = data_[data_idx-1].v();
                    double next_v = data_[data_idx].v();
                    double slope = (next_v - prev_v)/dt;
                    double v = prev_v + slope*(current_time - prev_t);
                    ts_projected.append(current_time, v);
                    break;
                }
                data_idx++;

            }
            loop_idx++;
        }
    }

    void Timeseries::removeByValue(double v)
    {
        for (int i = 0; i < data_.size(); i++) {
            if (Utility::floatCompare(v, data_[i].v())) {
                data_.removeAt(i);
                i--;
            }
        }
    }

    void Timeseries::interpolateOverValue(double v)
    {
        for (int i = 0; i < data_.size(); i++) {
            if (Utility::floatCompare(v, data_[i].v())) {
                if (i == 0) {
                    continue;
                } else if (i+1 == data_.size()) {
                    break;
                } else {
                    int interpolate_start_idx = i;
                    int interpolate_end_idx;
                    double prev_t = data_[i-1].t();
                    double prev_v = data_[i-1].v();

                    while (Utility::floatCompare(v, data_[i].v())) {
                        if (i+1 == data_.size()) {
                            break;
                        } else {
                            interpolate_end_idx = i;
                            i++;
                        }
                    }

                    double next_t = data_[i].t();
                    double next_v = data_[i].v();

                    double slope = (next_v - prev_v)/(next_t - prev_t);

                    for (int j = interpolate_start_idx; j <= interpolate_end_idx; j++) {
                        double dt = data_[j].t() - prev_t;
                        data_[j].setV(prev_v + slope*dt);
                    }
                }
            }
        }
    }

    void Timeseries::scale(double s)
    {
        for (size_t i = 0; i < data_.size(); i++) {
            data_[i].scale(s);
        }
    }

    void Timeseries::scaleT(double s)
    {
        for (size_t i = 0; i < data_.size(); i++) {
            data_[i].scaleT(s);
        }
    }

    void Timeseries::scaleV(double s)
    {
        for (size_t i = 0; i < data_.size(); i++) {
            data_[i].scaleV(s);
        }
    }

    void Timeseries::translateT(double dt)
    {
        for (size_t i = 0; i < data_.size(); i++) {
            data_[i].translateT(dt);
        }
    }

    void Timeseries::translateV(double dv)
    {
        for (size_t i = 0; i < data_.size(); i++) {
            data_[i].translateV(dv);
        }
    }

    void Timeseries::setMinValue(double v)
    {
        for (size_t i = 0; i < data_.size(); i++) {
            if (data_[i].v() < v) {
                data_[i].setV(v);
            }
        }
    }

    void Timeseries::setMaxValue(double v)
    {
        for (size_t i = 0; i < data_.size(); i++) {
            if (data_[i].v() > v) {
                data_[i].setV(v);
            }
        }
    }

    void Timeseries::setMinMagnitude(double v)
    {
        for (size_t i = 0; i < data_.size(); i++) {
            if (fabs(data_[i].v()) < fabs(v)) {
                data_[i].setV(0);
            }
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

    double Timeseries::valueAtT(double t)
    {
        assert(size() > 0 && t >= data_[0].t());

        if (size() == 1) {
            return data_[0].v();
        }

        for (int i = 1; i < size(); i++) {
            double prev_t = data_[i-1].t();
            double curr_t = data_[i].t();
            if (prev_t <= t && t < curr_t) {
                return data_[i-1].v();
            }
        }
        return data_.last().v();
    }
}
